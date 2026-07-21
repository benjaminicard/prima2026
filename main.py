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
  #recupere tous les faits de l'answer set
  facts = []
  for answer in answer_set:
    for fact in answer:
      facts.append(fact)
  return facts

def get_pred(facts, scenario):
  #recupere les faits liés à un scénario
  res = []
  for fact in facts:
    if scenario in fact[1]:
      res.append(fact)
  return res

def get_act(facts):
  #recupère les prédicats d'action d'un ensemble de fait
  res = dict()
  i = 0
  for fact in facts:
    if fact[0] == "act" or fact[0]=="utter":
      res[i]=fact
      i+=1
  return res

def get_perm(all_facts,act):
  #construit un dictionnaire qui pour une action donnée fournis les permissions, la règle associée ainsi que le degré
  res = dict()
  scenario = act[1][0]
  facts = get_pred(all_facts, scenario)

  for fact in facts:
    if fact[0]=='permissible':
      res[fact[1][1]]= 'perm'
    elif fact[0]=='impermissible' :
      res[fact[1][1]]= 'imp'
    elif fact[0] in ["erroneous_truth", "erroneous_lie", "objective_truth", "objective_lie"] and fact[1][-1] in act[1][-1] :
      res["rule"] = fact[0]
  if "rule" not in res:
    res["rule"] = "----"

  return res

facts = get_all_facts(answers_program2)


def show_scenario(all_facts,scenario):
  #fonction d'affichage du markdown
  mk = f"# Scénario {scenario} \n"
  facts = get_pred(all_facts,scenario)
  acts = get_act(facts)
  clean_act = [act[1][-1] for act in acts.values()]

  
  line = '## Actions :'
  for a in clean_act:
    if  a!='evade(p,q)' :
      line+= f"{a}"
  mk+=line+"\n"
  mk += f" ## Attempt evade : {'evade(p,q)' in clean_act} \n"
  mk+= "\n"
  mk += "| Act | Rule |deontologism | principialism1 | principialism2 | consequentialism1 | consequentialism2 |\n"
  mk += "| :---------------: | :---------------: | :-----: | :-----: | :-----: | :-----: | :-----: |\n"

  for i in range(len(acts)):
    if acts[i][1][-1]=='evade(p,q)' or acts[i][1][-1]=='silence(p,q,0)':
      continue
    perm = get_perm(facts,acts[i])
    mk += f"| {acts[i][1][-1]} | {perm['rule']} | {perm['deontologism']} | {perm['principialism1']} | {perm['principialism2']} | {perm['consequentialism1']} | {perm['consequentialism2']} |\n"
  # display(Markdown(mk))
  return mk


mk3 = ""
for i in range(1,6):
  mk3 +=show_scenario(facts,"s"+str(i)) +"\n"
display(Markdown(mk3))

  

with open('output.md', 'w') as f:
    f.write(mk3)
  
