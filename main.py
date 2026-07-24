from clyngor import ASP
from IPython.display import display, Markdown

with open('file1.lp', 'r') as f:
    program1 = f.read()
with open('file2.lp', 'r') as f:
    program2 = f.read()

# Function to convert answer sets to valid ASP facts
def answer_set_to_facts(answer_set,n,first):
    formatted_facts = []
    transmit= [("believe",2),("believe",3),("beliefbase",1), ("principle",1)]
    augment = [("utter",4),("act",1),("totalUti",2),("permissible",1), ("impermissible",1),('objective_lie',2),('objective_truth',2),('erroneous_lie',2),('erroneous_truth',2),('trigUti',3)]
    renamedAug = {("violated",1):"locally_violated"}
    for fact in answer_set:
        # Handle complex terms
        name = fact[0]
        args = fact[1] if isinstance(fact[1], tuple) else (fact[1],)
        arity = len(args)
        if first and (name,arity) in transmit :
          formatted_facts.append(f"{name}({','.join(map(str, args))}).")
        if (name,arity) in augment:
          newargs = ('s'+str(n),)+args
          formatted_facts.append(f"{name}({','.join(map(str, newargs))}).")
        if (name,arity) in renamedAug:
          newargs = ('s'+str(n),)+args
          newname = renamedAug[(name,arity)]
          formatted_facts.append(f"{newname}({','.join(map(str, newargs))}).")
    return "\n".join(formatted_facts)

# Run program1 to get its answer sets
answers_program1 = ASP(program1)
combined_program = ""

# Process each answer set from program1
for n, answer_set in enumerate(answers_program1, start=1):
    # print(f"Processing Answer Set {n} of program1...")

    # Convert answer set to ASP facts
    facts_from_program1 = answer_set_to_facts(answer_set,n,(n==1))

    # Combine program1 and program2
    combined_program = combined_program+"%AS"+str(n)+"\n"+f"{facts_from_program1}\n"

combined_program=combined_program+"\n"+program2

open('combined_program.lp', 'w').write(combined_program)

answers_program2 = ASP(combined_program)

def get_all_facts(answer_set):
  # récupère tous les faits de l'answer set
  facts = []
  for answer in answer_set:
    for fact in answer:
      facts.append(fact)
  return facts

def get_args(fact):
  # normalise les arguments d'un fait clyngor en tuple
  return fact[1] if isinstance(fact[1], tuple) else (fact[1],)

def get_pred(facts, scenario):
  # récupère les faits liés à un scénario
  res = []
  for fact in facts:
    args = get_args(fact)
    if len(args) > 0 and args[0] == scenario:
      res.append(fact)
  return res

def get_acts(facts_s):
  # récupère les actes 
  res = []
  for fact in facts_s:
    if fact[0] in ("utter", "act"):
      args = get_args(fact)
      act_str = args[-1]
      if act_str != "evade(p,q)":
        res.append(act_str)
  return res

def has_evade(facts_s):
  # indique si une tentative d'évasion a eu lieu dans ce scénario
  for fact in facts_s:
    if fact[0] == "act":
      args = get_args(fact)
      if args[-1] == "evade(p,q)":
        return True
  return False

def get_perm(facts_s, act_str):
  res = dict()
  for fact in facts_s:
    args = get_args(fact)
    if fact[0] == 'permissible':
      res[args[-1]] = 'perm'
    elif fact[0] == 'impermissible':
      res[args[-1]] = 'imp'
    elif fact[0] in ["erroneous_truth", "erroneous_lie", "objective_truth", "objective_lie"] and args[-1] in act_str:
      res["rule"] = fact[0]
  res.setdefault("rule", "----")
  for formalism in ["deontologism", "principialism1", "principialism2", "consequentialism1", "consequentialism2"]:
    res.setdefault(formalism, "----")
  return res

def get_total_uti(facts_s, agent):
  # récupère l'utilité totale pour un agent (pBelief ou env) dans un scénario
  for fact in facts_s:
    if fact[0] == 'totalUti':
      args = get_args(fact)
      if args[1] == agent:
        return args[-1]
  return "----"

def get_events(facts_s, agent, include_evade=False):
  # récupère les événements (kill/harm) déclenchés selon les croyances d'un agent
  events = []
  for fact in facts_s:
    if fact[0] == 'trigUti':
      args = get_args(fact)
      if args[1] == agent:
        events.append(str(args[2]))
  if include_evade and has_evade(facts_s):
    events.append("evade(p,q)")
  return events

facts = get_all_facts(answers_program2)

def build_big_table(all_facts, scenarios):
  header = ("| Scenario | Act | Rule | deontologism | principialism1 | principialism2 "
            "| consequentialism1 | consequentialism2 | attempt evade "
            "| uti (pBelief) | uti (env) "
            "| events (pBelief) | events (env) |\n")
  sep = "|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|\n"
  mk = header + sep

  for scenario in scenarios:
    facts_s = get_pred(all_facts, scenario)
    acts = get_acts(facts_s)
    evade = "True" if has_evade(facts_s) else "False"
    total_pbelief = get_total_uti(facts_s, "pBelief")
    total_env = get_total_uti(facts_s, "env")
    events_pbelief = get_events(facts_s, "pBelief", include_evade=True)
    events_env = get_events(facts_s, "env", include_evade=False)
    ev_pbelief_str = ", ".join(events_pbelief) if events_pbelief else "----"
    ev_env_str = ", ".join(events_env) if events_env else "----"

    if not acts:
      mk += (f"| {scenario} | ---- | ---- | ---- | ---- | ---- | ---- | ---- | {evade} "
             f"| {total_pbelief} | {total_env} | {ev_pbelief_str} | {ev_env_str} |\n")
      continue

    for act_str in acts:
      perm = get_perm(facts_s, act_str)
      mk += (f"| {scenario} | {act_str} | {perm['rule']} | {perm['deontologism']} "
             f"| {perm['principialism1']} | {perm['principialism2']} "
             f"| {perm['consequentialism1']} | {perm['consequentialism2']} "
             f"| {evade} | {total_pbelief} | {total_env} "
             f"| {ev_pbelief_str} | {ev_env_str} |\n")
  return mk

scenarios = [f"s{i}" for i in range(1, 6)]
mk_big = build_big_table(facts, scenarios)
display(Markdown(mk_big))

  

with open('output.md', 'w') as f:
    f.write(mk_big)
  
