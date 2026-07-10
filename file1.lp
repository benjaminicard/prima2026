% FACTS

% Main protagonists of the story
person(p;q;r).

% Possible locations
location(madrid;cemetery;family).


% Current and potential situations
situation(base). %mk1
% situation(alt1). %mk2
% situation(alt2). %mk3 pour afficher dans la bonne boite, rerun et chang mkx


% Belief base for the environment's objective facts and for the main agent's beliefs
plannumber(0..1).
beliefbase(env).
beliefbase(p(D)):-plannumber(D).


% Description of situation base (current situation)

%% Beliefs about location
believe(env, at(r,cemetery)) :-situation(base).
believe(p(0), at(r,family)):-situation(base).

%% Beliefs about hostility
believe(p(0),hostile(q)) :-situation(base).
believe(env,hostile(q)):-situation(base).
believe(env,murderer(q)):-situation(base).
believe(p(0),murderer(q)):-situation(base).

%% Beliefs about credible locations
believe(p(0),credible(at(r,madrid), q)):-situation(base).
believe(p(0),credible(at(r,cemetery), q)):-situation(base).
believe(p(0),credible(at(r,family), q)):-situation(base).
believe(env,credible(at(r,cemetery), q)):-situation(base).
believe(env,credible(at(r,family), q)):-situation(base).



% Description of situation alt1 (alternative 1)


%% Beliefs about location
believe(env, at(r,cemetery)) :-situation(alt1).
believe(p(0), at(r,family)):-situation(alt1).

%% Beliefs about hostility
believe(p(0),hostile(q)) :-situation(alt1).
believe(env,hostile(q)):-situation(alt1).
believe(env,murderer(q)):-situation(alt1).
believe(p(0),murderer(q)):-situation(alt1).

%% Beliefs about credible locations
believe(p(0),credible(at(r,madrid), q)):-situation(alt1).
believe(p(0),credible(at(r,cemetery), q)):-situation(alt1).
believe(p(0),credible(at(r,family), q)):-situation(alt1).
believe(env,credible(at(r,cemetery), q)):-situation(alt1).
believe(env,credible(at(r,family), q)):-situation(alt1).
believe(env,credible(at(r,madrid), q)):-situation(alt1).


% Description of situation alt2 (alternative 2)

%% Beliefs about location
believe(env, at(r,cemetery)) :-situation(alt2).
believe(p(0), at(r,family)):-situation(alt2).

%% Beliefs about hostility
believe(p(0),hostile(q)) :-situation(alt2).
believe(env,hostile(q)):-situation(alt2).

%% Beliefs about credible locations
believe(p(0),credible(at(r,madrid), q)):-situation(alt2).
believe(p(0),credible(at(r,cemetery), q)):-situation(alt2).
believe(p(0),credible(at(r,family), q)):-situation(alt2).
believe(env,credible(at(r,cemetery), q)):-situation(alt2).
believe(env,credible(at(r,family), q)):-situation(alt2).



%Inertia

believe(p(D+1),F):- believe(p(D),F), not -believe(p(D+1),F), plannumber(D+1).

-believe(p(D+1), credible(at(r,L), q)):- believe(p(D), credible(at(r,L), q)),
                                         utter(p,q,D,inform(at(r,L))),
                                         not believe(p(D),D, utter(q,p,D+1,query_ref(at(r)))),
                                         believe(env,D+1,utter(q,p,D+1,query_ref(at(r)))),
                                         plannumber(D+1).

believe(p(D+1), credible(at(r,L),q)) :- not believe(p(D), credible(at(r,L),q)),
                                        utter(p,q,D,inform(at(r,L))),
                                        not believe(p(D+1), D+1, utter(q,p,D+1,query_ref(at(r)))),
                                        believe(env, D+1, utter(q,p,D+1,query_ref(at(r)))),
                                        plannumber(D+1).

% Relation between questioning round and actions
believe(env,0, utter(q,p,0,query_ref(at(r)))).
believe(p(0),0, utter(q,p,0,query_ref(at(r)))).



%anticipated reaction (true or false)
1{utter(p,q,D,inform(at(r,L))): location(L), believe(p(D),credible(at(r,L),q));
  act(D,silence(p,q))}1:- believe(p(D),D,utter(q,p,D,query_ref(at(r)))).
                          0{act(D,attempt_evade(p,Y))}1:- believe(p(D),D,check(Y,madrid,r)).

%unanticipated reaction
1{utter(p,q,D,inform(at(r,L))): location(L),believe(p(D+1),credible(at(r,L),q));
  act(D+1,silence(p,q))}1 :- believe(env,D,utter(q,p,D,query_ref(at(r)))),
                             not believe(p(D),D,utter(q,p,D,query_ref(at(r)))),
                             plannumber(D).
%Decision Inertia
act(D+1,A):- act(D,A), not -act(D+1,A), plannumber(D+1).


-act(D+1,attempt_evade(p,Y)):- act(D,attempt_evade(p,Y)), person(Y),
                               not believe(p(D+1),D+1,check(Y,madrid,r)).



% ----------------------------------------------------------------------------------------------------------------

% RULES FOR PHYSICAL ACTIONS
% Rule for checking a location
believe(Y,D,check(P2,L,r)) :- utter(P1,P2,D, inform(at(r,L))), believe(Y,credible(at(r,L), P2)).


% Rule for reasking a question based on non-credible information
believe(Y,D+1,utter(P2,P1,D+1,query_ref(at(r)))) :- utter(P1,P2,D,inform(at(r,L))), 
                                                    not believe(Y,credible(at(r,L), P2)), 
                                                    plannumber(D),plannumber(D+1), beliefbase(Y).

% Rule for evasion
believe(Y,D,evade_success(p,P2)) :- act(D, attempt_evade(p,P2)), believe(Y,D,
                                    check(P2,madrid,r)).

% Rule for killing
believe(Y,D,kill(P2,P1,r)) :- believe(Y,D,check(P2,L,r)), believe(Y,at(r,L)), 
                              believe(Y,murderer(P2)), person(P1).

% Rule for helping
believe(Y,D,help(P2)) :- believe(Y,D,check(P2,L,r)), believe(Y,at(r,L)), 
                         not believe(Y,hostile(P2)).

% Rule for agents loosing patience (first condition)
believe(Y,D,patienceLost(P2, P1)) :- utter(P1,P2,D,inform(at(r,L))), 
                                     not believe(Y,credible(at(r,L), P2)), 
                                     believe(Y,hostile(P2)), plannumber(D).

% Rule for agents loosing patience (second condition)
believe(Y,D,patienceLost(P2, P1)) :- act(D,silence(P1, P2)), believe(Y,hostile(P2)).

% Rule for wrong information provided
believe(Y,D,wrongInfo(P2, P1)) :- believe(Y,D,check(P2, L, r)), 
                                  not believe(Y,at(r,L)), person(P1).

% Rule for an agent being harmed based on another agent loosing patience
believe(Y,D,harm1(P2, P1)) :- believe(Y,D,patienceLost(P2, P1)).

% Rule for an agent being harmed based on hostility and another agent providing wrong information
believe(Y,D,harm2(P2, P1)) :- believe(Y,D,wrongInfo(P2, P1)), believe(Y,hostile(P2)), 
                              not believe(Y,D,evade_success(P1,P2)).


% ----------------------------------------------------------------------------------------------------------------

% RULES FOR SPEECH ACTS
% Rule for honest communication based on agents' telling what they believe
honest(p,D,F) :- utter(p,_,D,inform(F)), believe(p(D),F).

% Rule for dishonest communication based on agents' not telling what they believe
dishonest(p,D,F) :- utter(p,_,D,inform(F)), not believe(p(D),F).

% Rules for telling objective truth based on the environment's belief
truth(P1,D,F) :- utter(P1,_,D,inform(F)), believe(env,F).

% Rules for telling objective falsity based on the environment's belief
falsity(P1,D,F) :- utter(P1,_,D,inform(F)), not believe(env,F).

% Rules for telling an objective truth or an erroneous truth
objective_truth(P1,D,F) :- honest(P1,D,F), truth(P1,D,F).
erroneous_truth(P1,D,F) :- honest(P1,D,F), falsity(P1,D,F).

% Rules for telling an objective lie on
objective_lie(P1,D,F) :- dishonest(P1,D,F), falsity(P1,D,F).
erroneous_lie(P1,D,F) :- dishonest(P1,D,F), truth(P1,D,F).


%%%%%%%%%%%%%%%  DEONTOLOGISM %%%%%%%%%%%%%%%%%%

% Maxims prohibiting lying and murder for deontologism
maxim(doNotLie;doNotEnableMurder).

% Rule concerning the violation of the maxim against lying
violated(doNotLie,D) :- dishonest(p,D,F).

% Rule concerning the violation of the maxim against murder
violated(doNotEnableMurder,D) :- believe(p(D),D,kill(P2,p,r)).

% Permissibility and impermissibility for deontologism
impermissible(deontologism,D):- violated(R,D), maxim(R).
% permissible(deontologism,D):- not impermissible(deontologism,D), plannumber(D), act(D,_).
permissible(deontologism,D):- not impermissible(deontologism,D), plannumber(D), utter(_,_,D,_).


%%%%%%%%%%%%%%%  PRINCIPIALISM VERSION 1 %%%%%%%%%%%%%%%

% Principle prohibiting lying with exception and murder for principialism1
principle(doNotLieExcept;doNotEnableMurder).

% Rule stating violation of lying principle in the absence of first exception
violated(doNotLieExcept,D) :- utter(p,P2,D,inform(F)), not believe(p(D),F),
                              not exception(utter(p,P2,D,inform(F)),doNotLieExcept).

% Rule stating that Falangists do not deserve truth
dontDeserveTruth(P2,D):- believe(p(D),murderer(P2)).

% First exception rule for lies: lying is permitted if truth is not deserved
exception(utter(P1,P2,D,inform(F)),doNotLieExcept):-utter(P1,P2,D,inform(F)), 
                                                    dontDeserveTruth(P2,D).

% Permissibility and impermissibility for principialism1
impermissible(principialism1,D) :- violated(R,D), principle(R).
% permissible(principialism1,D) :- not impermissible(principialism1,D), plannumber(D), act(D,_).
permissible(principialism1,D) :- not impermissible(principialism1,D), plannumber(D), 
                                 utter(_,_,D,_).


%%%%%%%%%%%%%%%  UTILITIES CALCULATIONS %%%%%%%%%%%%%%%%%%

% Expected utilities for various physical actions according to consequentialism
uti(kill(P2,P1,r),-4):-person(P2), person(P1).
uti(harm1(P1,P2),-2):-person(P2), person(P1).
uti(harm2(P1,P2),-3):-person(P2), person(P1).
uti(wrongInfo(P1,P2),0):-person(P2), person(P1).
uti(help(P),2):-person(P).
uti(evade_success(P1,P2),0):- person(P1), person(P2).

% Actions triggering specific utility values
trigUti(Y,D,F,N) :- uti(F,N), believe(Y,D,F).

% Calculation of total utility values for agents and actions
% totalUti(Y,D,T):- T=#sum{N,F:uti(F,N),believe(Y,D,F)}, beliefbase(Y),plannumber(D).
totalUti(Y,D,T):- T=#sum{N:trigUti(Y,D,F,N)}, beliefbase(Y),plannumber(D).



% #show act/2.
% #show utter/4.
% #show believe/2.
% #show believe/3.
% #show impermissible/2.
% #show permissible/2.
% #show violated/2.
% #show trigUti/4.
% #show totalUti/3.
% #show objective_lie/3.
% #show objective_truth/3.
% #show erroneous_lie/3.
% #show erroneous_truth/3.
% #show beliefbase/1.
% #show principle/1.
% #show uti/2.
% #show nbAsk/1.
% #show truth/3.
% #show falsity/3.
% #show honest/3.
% #show dishonest/3.
