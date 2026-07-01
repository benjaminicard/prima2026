# -*- coding: utf-8 -*-
"""prima2026_asp.ipynb

"""

!pip install clingo
!pip install clyngor-with-clingo

import clingo
import tempfile
from clyngor import ASP, solve
from IPython.display import display, Markdown

# Commented out IPython magic to ensure Python compatibility.
# program1 = """
# 
# % FACTS
# 
# % Main protagonists of the story
# person(p;f).
# 
# % Possible locations
# location(madrid;cemetery;family).
# 
# % Current and potential situations
# situation(s1). %mk1
# %situation(s2). %mk2
# %situation(s3). %mk3 pour afficher dans la bonne boite, rerun et chang mkx
# 
# 
# % Belief base for the environment's objective facts and for the main agent's beliefs
# plannumber(0..1).
# beliefbase(env).
# beliefbase(p(D)):-plannumber(D).
# 
# 
# % Description of situation s1 (current situation)
# 
# %% Beliefs about location
# believe(env, at(r,cemetery)) :-situation(s1).
# believe(p(0), at(r,family)):-situation(s1).
# 
# %% Beliefs about hostility
# believe(p(0),hostile(f)) :-situation(s1).
# believe(env,hostile(f)):-situation(s1).
# believe(env,murderer(f)):-situation(s1).
# believe(p(0),murderer(f)):-situation(s1).
# 
# %% Beliefs about credible locations
# believe(p(0),credible(at(r,madrid), f)):-situation(s1).
# believe(p(0),credible(at(r,cemetery), f)):-situation(s1).
# believe(p(0),credible(at(r,family), f)):-situation(s1).
# believe(env,credible(at(r,cemetery), f)):-situation(s1).
# believe(env,credible(at(r,family), f)):-situation(s1).
# 
# 
# 
# % Description of situation s2 (alternative 1)
# 
# 
# %% Beliefs about location
# believe(env, at(r,cemetery)) :-situation(s2).
# believe(p(0), at(r,family)):-situation(s2).
# 
# %% Beliefs about hostility
# believe(p(0),hostile(f)) :-situation(s2).
# believe(env,hostile(f)):-situation(s2).
# believe(env,murderer(f)):-situation(s2).
# believe(p(0),murderer(f)):-situation(s2).
# 
# %% Beliefs about credible locations
# believe(p(0),credible(at(r,madrid), f)):-situation(s2).
# believe(p(0),credible(at(r,cemetery), f)):-situation(s2).
# believe(p(0),credible(at(r,family), f)):-situation(s2).
# believe(env,credible(at(r,cemetery), f)):-situation(s2).
# believe(env,credible(at(r,family), f)):-situation(s2).
# believe(env,credible(at(r,madrid), f)):-situation(s2).
# 
# 
# % Description of situation s3 (alternative 2)
# 
# %% Beliefs about location
# believe(env, at(r,cemetery)) :-situation(s3).
# believe(p(0), at(r,family)):-situation(s3).
# 
# %% Beliefs about hostility
# believe(p(0),hostile(f)) :-situation(s3).
# believe(env,hostile(f)):-situation(s3).
# 
# %% Beliefs about credible locations
# believe(p(0),credible(at(r,madrid), f)):-situation(s3).
# believe(p(0),credible(at(r,cemetery), f)):-situation(s3).
# believe(p(0),credible(at(r,family), f)):-situation(s3).
# believe(env,credible(at(r,cemetery), f)):-situation(s3).
# believe(env,credible(at(r,family), f)):-situation(s3).
# 
# 
# 
# %Inertia
# believe(p(D+1),F):- believe(p(D),F), not -believe(p(D+1),F), plannumber(D+1).
# 
# -believe(p(D+1), credible(at(r,X), f)):- act(D,tell(p,at(r,X),f,N)), not believe(p(D),D, ask(f,where,p,N+1)), believe(env,D,ask(f,where,p,N+1)).
# 
# 
# % Relation between questioning round and actions
# 
# nbAsk(0..1).
# believe(env, 0, ask(f,where,p,0)).
# believe(p(0),0, ask(f,where,p,0)).
# 
# 
# 
# %anticipated reaction
# %1{act(D,tell(p,at(r,L),f,N)): location(L), believe(p(D),credible(at(r,L),f));act(D,silence(p,f,N))}1:- believe(p(D),D,ask(f,where,p,N)), believe(env,D,ask(f,where,p,N)), nbAsk(N).
# %0{act(D,attempt_evade(p,P2)}1:- believe(p(D),D,check(P2,madrid,p)), believe(env,D,check(P2,madrid,p)).
# %wrongly anticipated reaction
# %0{act(D,attempt_evade(p,P2))}1:- believe(p(D),D,check(P2,madrid,p)), not believe(env,D,check(P2,madrid,p)).
# 
# %anticipated reaction (true or false)
# 1{act(D,tell(p,at(r,L),f,N)): location(L), believe(p(D),credible(at(r,L),f));act(D,silence(p,f,N))}1:- believe(p(D),D,ask(f,where,p,N)), nbAsk(N).
# 0{act(D,attempt_evade(p,P2))}1:- believe(p(D),D,check(P2,madrid,p)).
# 
# %unanticipated reaction
# 1{act(D+1,tell(p,at(r,L),f,N)): location(L), believe(p(D+1),credible(at(r,L),f));act(D+1,silence(p,f,N))}1:- believe(env,D,ask(f,where,p,N)),not act(D,tell(p,_,f,N)),not believe(p(D),D,ask(f,where,p,N)), nbAsk(N).
# 
# 
# %Decision Inertia
# act(D+1,A):- act(D,A), not -act(D+1,A), plannumber(D+1).
# 
# -act(D+1,attempt_evade(p,P2)):- act(D,attempt_evade(p,P2)), not believe(p(D+1),D+1, check(P2,madrid,p)).
# 
# 
# 
# 
# % ----------------------------------------------------------------------------------------------------------------
# 
# % RULES FOR PHYSICAL ACTIONS
# % Rule for checking a location
# believe(Y,D,check(P2,X,P1)) :- act(D,tell(P1, at(r,X), P2, N)), believe(Y,credible(at(r,X), P2)),nbAsk(N).
# 
# % Rule for reasking a question based on non-credible information
# believe(Y,D,ask(P2, where, P1, N+1)) :- act(D,tell(P1, at(r,X), P2, N)), not believe(Y,credible(at(r,X), P2)), nbAsk(N),nbAsk(N+1), beliefbase(Y).
# 
# % Rule for evasion
# believe(Y,D,evade_success(p,P2)) :- act(D, attempt_evade(p,P2)), believe(Y,D,check(P2,madrid,p)).
# %believe(Y,D,harm2(P2,p)) :- act(D, attempt_evade(p,P2)), not believe(Y,D,check(P2,madrid,p)), beliefbase(Y).
# 
# % Rule for killing
# believe(Y,D,kill(P2,r,P1)) :- believe(Y,D,check(P2,X,P1)), believe(Y,at(r,X)), believe(Y,hostile(P2)).
# 
# % Rule for helping
# believe(Y,D,help(P2)) :- believe(Y,D,check(P2,X,P1)), believe(Y,at(r,X)), not believe(Y,hostile(P2)).
# 
# % Rule for agents loosing patience (first condition)
# believe(Y,D,patienceLost(P2, P1)) :- act(D,tell(P1, at(r,X), P2, N)), not believe(Y,credible(at(r,X), P2)), believe(Y,hostile(P2)), nbAsk(N), not nbAsk(N+1).
# 
# % Rule for agents loosing patience (second condition)
# believe(Y,D,patienceLost(P2, P1)) :- act(D,silence(P1, P2,N)), believe(Y,hostile(P2)),nbAsk(N).
# 
# % Rule for wrong information provided
# believe(Y,D,wrongInfo(P2, P1)) :- believe(Y,D,check(P2, X, P1)), not believe(Y,at(r,X)).
# 
# % Rule for an agent being harmed based on another agent loosing patience
# believe(Y,D,harm1(P2, P1)) :- believe(Y,D,patienceLost(P2, P1)).
# 
# % Rule for an agent being harmed based on hostility and another agent providing wrong information
# believe(Y,D,harm2(P2, P1)) :- believe(Y,D,wrongInfo(P2, P1)), believe(Y,hostile(P2)), not believe(Y,D,evade_success(P1,P2)).
# 
# 
# % ----------------------------------------------------------------------------------------------------------------
# 
# % RULES FOR SPEECH ACTS
# % Rule for honest communication based on agents' telling what they believe
# honest(p,D,F) :- act(D,tell(p,F,_,N)), believe(p(D),F).
# 
# % Rule for dishonest communication based on agents' not telling what they believe
# dishonest(p,D,F) :- act(D,tell(p,F,_,N)), not believe(p(D),F).
# 
# % Rules for telling objective truth based on the environment's belief
# truth(P1,D,F) :- act(D,tell(P1,F,_,_)), believe(env,F).
# 
# % Rules for telling objective falsity based on the environment's belief
# falsity(P1,D,F) :- act(D,tell(P1,F,_,N)), not believe(env,F).
# 
# % Rules for telling an objective truth or an erroneous truth
# objective_truth(P1,D,F) :- honest(P1,D,F), truth(P1,D,F).
# erroneous_truth(P1,D,F) :- honest(P1,D,F), falsity(P1,D,F).
# 
# % Rules for telling an objective lie onAlternative  1,  Pablo  once  again  lies  to  the  hostile842Falangists  by  claiming  that  Ramon  is  in  Madrid.  Here,843unlike  in  the  original  version  of  the  story,  the  lie  helps844both  Ramon  and  Pablo  since  the  Falangists  will  search845for  Ramon  in  distant  Madrid,  giving  Pablo  enough  time846to  escape.  But  despite  its  greater  advantage,  “Madrid”847is  considered  equallypermissibleas  “Cemetery”  under848principialism.  Inprincipialism1,  the  exception  al-849lowing a lie is granted due to the hostility of the Falangists.850Underprincipialism2,  counterfactual  reasoning  shows851that  telling  the  truth  (“Ramon  is  at  his  family’s  house”)852would  lead  to  worse  outcomes  than  either  lie,  rendering853“Madrid”  and  “Cemetery”  morally  equivalent  within  the854framework  of  this  theory.  This  equivalence  does  not  hold855underconsequentialism1. From the perspective of ex-856pected utility, “Madrid” uniquely enables both Ramon’s and857Pablo’s survival, whereas “Cemetery”, though still protec-858tive of Ramon, increases the personal risk to Pablo. Thus,859whileprincipialismdeems both theobjectivelie860“Madrid”  and  theerroneouslie“Cemetery”  equally861permissible,consequentialism1identifies  “Madrid”  as862the uniquely optimal choicer an erroneous lie
# objective_lie(P1,D,F) :- dishonest(P1,D,F), falsity(P1,D,F).
# erroneous_lie(P1,D,F) :- dishonest(P1,D,F), truth(P1,D,F).
# 
# 
# %%%%%%%%%%%%%%%  DEONTOLOGISM %%%%%%%%%%%%%%%%%%
# 
# % Maxims prohibiting lying and murder for deontologism
# maxim(doNotLie;doNotEnableMurder).
# 
# % Rule concerning the violation of the maxim against lying
# violated(doNotLie,D) :- dishonest(p,D,F).
# 
# % Rule concerning the violation of the maxim against murder
# violated(doNotEnableMurder,D) :- believe(p(D),D,kill(P2,r,p)).
# 
# % Permissibility and impermissibility for deontologism
# impermissible(deontologism,D):- violated(R,D), maxim(R).
# permissible(deontologism,D):- not impermissible(deontologism,D), plannumber(D), act(D,_).
# 
# 
# %%%%%%%%%%%%%%%  PRINCIPIALISM VERSION 1 %%%%%%%%%%%%%%%
# 
# % Principle prohibiting lying with exception and murder for principialism1
# principle(doNotLieExcept;doNotEnableMurder).
# 
# % Rule stating violation of lying principle in the absence of first exception
# violated(doNotLieExcept,D) :- act(D,tell(p,F,P2)), not believe(p(D),F), not exception(act(D,tell(p,F,P2)),doNotLieExcept).
# 
# % Rule stating that Falangists do not deserve truth
# dontDeserveTruth(P2,D):- believe(p(D),murderer(P2)).
# 
# % First exception rule for lies: lying is permitted if truth is not deserved
# exception(act(D,tell(P1,F,P2)),doNotLieExcept):- act(D,tell(P1,F,P2)), dontDeserveTruth(P2,D).
# 
# % Permissibility and impermissibility for principialism1
# impermissible(principialism1,D) :- violated(R,D), principle(R).
# permissible(principialism1,D) :- not impermissible(principialism1,D), plannumber(D), act(D,_).
# 
# 
# %%%%%%%%%%%%%%%  UTILITIES CALCULATIONS %%%%%%%%%%%%%%%%%%
# 
# % Expected utilities for various physical actions according to consequentialism
# uti(kill(P2,r,P1),-4):-person(P2), person(P1).
# uti(harm1(P1,P2),-2):-person(P2), person(P1).
# uti(harm2(P1,P2),-4):-person(P2), person(P1).
# uti(wrongInfo(P1,P2),0):-person(P2), person(P1).
# uti(help(P),2):-person(P).
# uti(evade_success(P1,P2),0):- person(P1), person(P2).
# 
# % Actions triggering specific utility values
# trigUti(Y,D,F,N) :- uti(F,N), believe(Y,D,F).
# 
# % Calculation of total utility values for agents and actions
# totalUti(Y,D,T):- T=#sum{N:uti(F,N),believe(Y,D,F)}, beliefbase(Y),plannumber(D).
# %totalUti(Y,D,T):- T=#sum{N:trigUti(Y,D,F,N)}, beliefbase(Y),plannumber(D).
# 
# %#show act/2.
# %#show believe/2.
# %#show believe/3.
# %#show impermissible/2.
# %#show permissible/2.
# %#show violated/2.
# %#show trigUti/4.
# %#show totalUti/3.
# %#show objective_lie/3.
# %#show objective_truth/3.
# %#show erroneous_lie/3.
# %#show erroneous_truth/3.
# %#show beliefbase/1.
# %#show principle/1.
# %#show uti/2.
# %#show nbAsk/1.
# %#show truth/3.
# %#show falsity/3.
# %#show honest/3.
# %#show dishonest/3.
# """
#

answers = ASP(program1)

def imprimer(N, L):
    print("\nAnswer Set ", N)
    for X in L:
        print(X[0], X[1])
n = 1
for answer in answers:
    imprimer(n, answer)
    n = n+1
    print("\n")

# Commented out IPython magic to ensure Python compatibility.
# #############  PRINCIPIALISM VERSION 2 ####################  +  #############  CONSEQUENTIALISM VERSIONS 1 AND 2 ####################
# 
# 
# # Define program2
# program2 = """
# 
# 
# % PRINCIPIALISM VERSION 2
# % Rule for comparing decisions based on counterfactual comparison
# counterfactual(S1, S2, tell(p, at(r, L1), f)) :-
#     act(S1,D,tell(p, at(r, L1), f)), L1!=L2,
#     believe(p(D), at(r, L2)),
#     act(S2,D,tell(p, at(r, L2), f)),
#     {act(S1, D2, A2) : D2<D, not act(S2, D2, A2)}0,
#     {act(S2, D3, A3) : D3<D, not act(S1, D3, A3)}0,
#     {act(S1, D, A4) : A4 != tell(p, at(r, L1), f, N), nbAsk(N), not act(S2, D, A4)}0.
# 
# 
# % Second exception rule for lies: lying is permitted if truth leads to worst consequences
# exceptionRel(S, doNotLieExcept,D) :-
#     act(S,D,tell(p, at(r, L1), f)),
#     counterfactual(S, S2, tell(p, at(r, L1), f)),
#     totalUti(S,p(D),D , T1),
#     totalUti(S2, p(D),D, T2),
#     T1 > T2.
# 
# 
# 
# % Rule stating (local) violation of lying principle in the absence of second exception
# violated(S, R,D) :-
#     locally_violated(S, R,D),
#     not exceptionRel(S, R,D).
# 
# % Permissibility and impermissibility for principialism2
# permissible(S,principialism2, D) :- not impermissible(S,principialism2,D), act(S,D, _).
# impermissible(S,principialism2, D) :- violated(S, R,D), principle(R).
# 
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
# % CONSEQUENTIALISM VERSION 1
# % Permissibility and impermissibility for consequentialism1
# impermissible(S,consequentialism1,D) :- totalUti(S,p(D),D,N1), totalUti(S2,p(D),D,N2), N2>N1.
# permissible(S,consequentialism1,D) :- not impermissible(S,consequentialism1,D), act(S,D,_).
# 
# 
# % CONSEQUENTIALISM VERSION 2
# % Calculation of total utility based on sums of total utilities of each action
# totalUti2(S,Y,D,T) :- T=#sum{N:totalUti(S,Y,D,N)}, beliefbase(Y),act(S,D,_).
# 
# 
# % Permissibility and impermissibility for consequentialism2
# impermissible(S,consequentialism2,D) :- totalUti2(S,env,D,N1), totalUti2(S2,env,D,N2), N2>N1.
# permissible(S,consequentialism2,D) :- not impermissible(S,consequentialism2,D), act(S,D,_).
# 
# 
# 
# %#show totalUti/4.
# %#show totalUti2/4.
# %#show locally_violated/3.
# %#show violated/3.
# %#show act/3.
# %#show exceptionRel/3.
# %#show counterfactual/3.
# %#show objective_lie/4.
# %#show objective_truth/4.
# %#show erroneous_lie/4.
# %#show erroneous_truth/4.
# %#show permissible/3.
# %#show impermissible/3.
# %#show trigUti/5.
# """
# 
# 
# 
# # Function to convert answer sets to valid ASP facts
# def answer_set_to_facts(answer_set,n,first):
#     formatted_facts = []
#     transmit= [("believe",2),("believe",3),("beliefbase",1), ("principle",1)]
#     augment = [("act",2),("totalUti",3),("permissible",2), ("impermissible",2),('objective_lie',3),('objective_truth',3),('erroneous_lie',3),('erroneous_truth',3),('trigUti',4)]
#     renamedAug = {("violated",2):"locally_violated"}
#     for fact in answer_set:
#         # Handle complex terms
#         name = fact[0]
#         args = fact[1] if isinstance(fact[1], tuple) else (fact[1],)
#         arity = len(args)
#         if first and (name,arity) in transmit :
#           formatted_facts.append(f"{name}({','.join(map(str, args))}).")
#         if (name,arity) in augment:
#           newargs = ('s'+str(n),)+args
#           formatted_facts.append(f"{name}({','.join(map(str, newargs))}).")
#         if (name,arity) in renamedAug:
#           newargs = ('s'+str(n),)+args
#           newname = renamedAug[(name,arity)]
#           formatted_facts.append(f"{newname}({','.join(map(str, newargs))}).")
#     return "\n".join(formatted_facts)
# 
# # Run program1 to get its answer sets
# answers_program1 = ASP(program1)
# combined_program = ""
# 
# # Process each answer set from program1
# for n, answer_set in enumerate(answers_program1, start=1):
#     # print(f"Processing Answer Set {n} of program1...")
# 
#     # Convert answer set to ASP facts
#     facts_from_program1 = answer_set_to_facts(answer_set,n,(n==1))
# 
#     # Combine program1 and program2
#     combined_program = combined_program+"%AS"+str(n)+"\n"+f"{facts_from_program1}\n"
# 
# combined_program=combined_program+"\n"+program2
# print(combined_program)

# Run the combined program
answers_program2 = ASP(combined_program)
res = ""
# Output results for this specific answer set
for m, result in enumerate(answers_program2, start=1):
        # res+= f"Answer Set {m} of program2 for Answer Set {n}:\n"
        for fact in result:
            res+=str(fact)+"\n"

print(res)

answers_program = ASP(combined_program)

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
    if fact[0] == "act":
      res[i]=fact
      i+=1
  return res

def get_perm(all_facts,act):
  #construit un dictionnaire qui pour une action donnée fournis les permissions, la règle associée ainsi que le degré
  res = dict()
  scenario = act[1][0]
  degre = act[1][1]
  res["degre"] = degre
  facts = get_pred(all_facts, scenario)
  for fact in facts:
    if fact[0]=='permissible' and fact[1][2]==degre:
      res[fact[1][1]]= 'perm'
    elif fact[0]=='impermissible' and fact[1][2]==degre:
      res[fact[1][1]]= 'imp'
    elif fact[0] in ["erroneous_truth", "erroneous_lie", "objective_truth", "objective_lie"] and fact[1][3] in act[1][2] and fact[1][2]==act[1][1]:
      res["rule"] = fact[0]
  if "rule" not in res:
    res["rule"] = "----"
  return res

facts = get_all_facts(answers_program)


def show_scenario(all_facts,scenario):
  #fonction d'affichage du markdown
  mk = f"# Scénario {scenario} \n"
  facts = get_pred(all_facts,scenario)
  acts = get_act(facts)

  clean_act = {act[1][2] for act in acts.values()}

  line = '## Actions :'
  for a in clean_act:
    if  a!='attempt_evade(p,f)':
      line+= f"{a}"
  mk+=line+"\n"
  mk += f" ## Attempt evade : {'attempt_evade(p,f)' in clean_act} \n"
  mk+= "\n"
  mk += "| Degre | Act | Rule |deontologism | principialism1 | principialism2 | consequentialism1 | consequentialism2 |\n"
  mk += "| :---------------:| :---------------: | :---------------: | :-----: | :-----: | :-----: | :-----: | :-----: |\n"

  for i in range(len(acts)):
    if acts[i][1][2]=='attempt_evade(p,f)':
      continue
    perm = get_perm(facts,acts[i])
    mk += f"| {perm['degre']} | {acts[i][1][2]} | {perm['rule']} | {perm['deontologism']} | {perm['principialism1']} | {perm['principialism2']} | {perm['consequentialism1']} | {perm['consequentialism2']} |\n"

  display(Markdown(mk))
  return mk

mk3 = ""
for i in range(1,9):
  mk3 +=show_scenario(facts,"s"+str(i)) +"\n"

"""# Scenario Initial"""

display(Markdown(mk3))

"""# Alternative 1"""

display(Markdown(mk2))

"""# Alternative 2"""

display(Markdown(mk3))

