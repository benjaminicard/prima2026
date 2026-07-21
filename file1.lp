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
round(0..1).
beliefbase(env;pBelief).


% Description of situation base (current situation)

%% Beliefs about location
believe(env, at(r,cemetery)) :-situation(base).
believe(pBelief, at(r,family)):-situation(base).

%% Beliefs about hostility
believe(env,hostile(q,r)):-situation(base).
believe(env,hostile(q,p)):-situation(base).
believe(env,murderer(q)):-situation(base).
believe(pBelief,hostile(q,r)) :-situation(base).
believe(pBelief,hostile(q,p)) :-situation(base).
believe(pBelief,murderer(q)):-situation(base).

%% Beliefs about credible locations
believe(pBelief,credible(at(r,madrid), q)):-situation(base).
believe(pBelief,credible(at(r,cemetery), q)):-situation(base).
believe(pBelief,credible(at(r,family), q)):-situation(base).
believe(env,credible(at(r,cemetery), q)):-situation(base).
believe(env,credible(at(r,family), q)):-situation(base).



% Description of situation alt1 (alternative 1)


%% Beliefs about location
believe(env, at(r,cemetery)) :-situation(alt1).
believe(pBelief, at(r,family)):-situation(alt1).

%% Beliefs about hostility
believe(pBelief,hostile(q,r)) :-situation(alt1).
believe(env,hostile(q,r)):-situation(alt1).
believe(env,murderer(q)):-situation(alt1).
believe(pBelief,murderer(q)):-situation(alt1).

%% Beliefs about credible locations
believe(pBelief,credible(at(r,madrid), q)):-situation(alt1).
believe(pBelief,credible(at(r,cemetery), q)):-situation(alt1).
believe(pBelief,credible(at(r,family), q)):-situation(alt1).
believe(env,credible(at(r,cemetery), q)):-situation(alt1).
believe(env,credible(at(r,family), q)):-situation(alt1).
believe(env,credible(at(r,madrid), q)):-situation(alt1).


% Description of situation alt2 (alternative 2)

%% Beliefs about location
believe(env, at(r,cemetery)) :-situation(alt2).
believe(pBelief, at(r,family)):-situation(alt2).

%% Beliefs about hostility
believe(pBelief,hostile(q,r)) :-situation(alt2).
believe(env,hostile(q,r)):-situation(alt2).

%% Beliefs about credible locations
believe(pBelief,credible(at(r,madrid), q)):-situation(alt2).
believe(pBelief,credible(at(r,cemetery), q)):-situation(alt2).
believe(pBelief,credible(at(r,family), q)):-situation(alt2).
believe(env,credible(at(r,cemetery), q)):-situation(alt2).
believe(env,credible(at(r,family), q)):-situation(alt2).



% Relation between questioning round and actions
believe(env, utter(q,p,0,query(at(r)))).
believe(pBelief, utter(q,p,0,query(at(r)))).




1{utter(p,q,N,inform(at(r,L))): location(L), believe(pBelief,credible(at(r,L),q));
  act(silence(p,q,N))}1:- believe(pBelief,utter(q,p,N,query(at(r)))).

0{act(evade(p,Y))}1:- believe(pBelief,check(Y,X,madrid,r)).

% %unanticipated reaction
% 1{utter(p,q,D,inform(at(r,L))): location(L),believe(p(D+1),credible(at(r,L),q));
%   act(D+1,silence(p,q))}1 :- believe(env,D,utter(q,p,D,query(at(r)))),
%                              not believe(p(D),D,utter(q,p,D,query(at(r)))),
%                              plannumber(D).
% %Decision Inertia
% act(D+1,A):- act(D,A), not -act(D+1,A), plannumber(D+1).


% -act(D+1,attempt_evade(p,Y)):- act(D,attempt_evade(p,Y)), person(Y),
%                                not believe(p(D+1),D+1,check(Y,madrid,r)).



% ----------------------------------------------------------------------------------------------------------------

% RULES FOR PHYSICAL ACTIONS
% Rule for checking a location
believe(P1,check(X,Y,L,Z)) :- utter(Y,X,N, inform(at(Z,L))), believe(P1,credible(at(r,L), X)).


% % Rule for reasking a question based on non-credible information
% believe(Y,D+1,utter(P2,P1,D+1,query(at(r)))) :- utter(P1,P2,D,inform(at(r,L))), 
%                                                     not believe(Y,credible(at(r,L), P2)), 
%                                                     plannumber(D),plannumber(D+1), beliefbase(Y).

% Rule for evasion
believe(X,escaped(p,Y)) :- act(evade(p,Y)), believe(X,check(Y,madrid,r)).

% Rule for killing
believe(P1,kill(X,Y,Z)) :- believe(P1,check(X,Y,L,Z)), believe(P1,at(Z,L)), 
                              believe(P1,murderer(X)).


% % Rule for agents loosing patience (first condition)
% believe(Y,D,patienceLost(P2, P1)) :- utter(P1,P2,D,inform(at(r,L))), 
%                                      not believe(Y,credible(at(r,L), P2)), 
%                                      believe(Y,hostile(P2)), plannumber(D).

% % Rule for agents loosing patience (second condition)
% believe(Y,D,patienceLost(P2, P1)) :- act(D,silence(P1, P2)), believe(Y,hostile(P2)).

% % Rule for wrong information provided
% believe(Y,D,wrongInfo(P2, P1)) :- believe(Y,D,check(P2, L, r)), 
%                                   not believe(Y,at(r,L)), person(P1).

% % Rule for an agent being harmed based on another agent loosing patience
% believe(Y,D,harm1(P2, P1)) :- believe(Y,D,patienceLost(P2, P1)).

% % Rule for an agent being harmed based on hostility and another agent providing wrong information
% believe(Y,D,harm2(P2, P1)) :- believe(Y,D,wrongInfo(P2, P1)), believe(Y,hostile(P2)), 
%                               not believe(Y,D,evade_success(P1,P2)).



% Rules for an agent being harmed based on differents reasons
reason(uncredibleStatement;refusedToAnswer;uncoveredLie;failedEvade).

% believe(P1, harm(X,Y,uncredibleStatement)):- utter(Y,X,N,F), not believe(P1, credible(F,X)), believe(P1,hostile(X,Y))  .
believe(P1, harm(X,Y,uncredibleStatement)):- utter(Y,X,N,inform(at(Z,L))), not believe(P1, credible(at(Z,L),X)), believe(P1,hostile(X,Y)) 
believe(P1, harm(X,Y,refusedToAnswer)):- act(silence(Y,X,N)), believe(P1, hostile(X,Y)) .

% believe(P1, harm(X,Y,uncoveredLie)):- believe(P1,check(X,Y,L,Z)), not believe(env, at(Z,L)) ,believe(P1,hostile(X,Y)) .
believe(P1, harm(X,Y,uncoveredLie)):- believe(P1,check(X,Y,L1,Z)), believe(env, at(Z,L2)),L1!=L2 ,believe(P1,hostile(X,Y)) .

believe(P1, harm(X,Y,failedEvade)):-  act(evade(Y,X)), not believe(P1, check(X,_,madrid,_)), beliefbase(P1).



% ----------------------------------------------------------------------------------------------------------------

% RULES FOR SPEECH ACTS
% Rule for honest communication based on agents' telling what they believe
honest(p,F) :- utter(p,_,_,inform(F)), believe(pBelief,F).

% Rule for dishonest communication based on agents' not telling what they believe
dishonest(p,F) :- utter(p,_,_,inform(F)), not believe(pBelief,F).

% Rules for telling objective truth based on the environment's belief
truth(P1,F) :- utter(P1,_,_,inform(F)), believe(env,F).

% Rules for telling objective falsity based on the environment's belief
falsity(P1,F) :- utter(P1,_,_,inform(F)), not believe(env,F).

% Rules for telling an objective truth or an erroneous truth
objective_truth(P1,F) :- honest(P1,F), truth(P1,F).
erroneous_truth(P1,F) :- honest(P1,F), falsity(P1,F).

% Rules for telling an objective lie on
objective_lie(P1,F) :- dishonest(P1,F), falsity(P1,F).
erroneous_lie(P1,F) :- dishonest(P1,F), truth(P1,F).


%%%%%%%%%%%%%%%  DEONTOLOGISM %%%%%%%%%%%%%%%%%%

% Maxims prohibiting lying and murder for deontologism
maxim(doNotLie;doNotEnableMurder).

% Rule concerning the violation of the maxim against lying
violated(doNotLie) :- dishonest(p,F).

% Rule concerning the violation of the maxim against murder
violated(doNotEnableMurder) :- believe(pBelief,kill(X,p,Z)).

% Permissibility and impermissibility for deontologism
impermissible(deontologism):- violated(R), maxim(R).
% permissible(deontologism):- not impermissible(deontologism), utter(_,_,N,_).
permissible(deontologism):- not impermissible(deontologism).


%%%%%%%%%%%%%%%  PRINCIPIALISM VERSION 1 %%%%%%%%%%%%%%%

% Principle prohibiting lying with exception and murder for principialism1
principle(doNotLieExcept;doNotEnableMurder).

% Rule stating violation of lying principle in the absence of first exception
violated(doNotLieExcept) :- utter(p,P2,N,inform(F)), not believe(pBelief,F),
                              not exception(utter(p,P2,N,inform(F)),doNotLieExcept).

% Rule stating that Falangists do not deserve truth
dontDeserveTruth(X):- believe(pBelief,murderer(X)).

% First exception rule for lies: lying is permitted if truth is not deserved
exception(utter(X,Y,N,inform(F)),doNotLieExcept):-utter(X,Y,N,inform(F)), 
                                                    dontDeserveTruth(Y).

% Permissibility and impermissibility for principialism1
impermissible(principialism1) :- violated(R), principle(R).
% permissible(principialism1,D) :- not impermissible(principialism1,D), plannumber(D), act(D,_).
permissible(principialism1) :- not impermissible(principialism1), 
                                 utter(_,_,N,_).


%%%%%%%%%%%%%%%  UTILITIES CALCULATIONS %%%%%%%%%%%%%%%%%%

% Expected utilities for various physical actions according to consequentialism
uti(kill(X,Y,r),-4):-person(X), person(Y).
uti(harm(X,Y,R),-3):-person(X), person(Y), reason(R).

% Actions triggering specific utility values
trigUti(Y,F,V) :- uti(F,V), believe(Y,F).

% Calculation of total utility values for agents and actions
% totalUti(Y,D,T):- T=#sum{N,F:uti(F,N),believe(Y,D,F)}, beliefbase(Y),plannumber(D).
totalUti(Y,T):-  beliefbase(Y), T=#sum{V,F:trigUti(Y,F,V)}.


% #show reason/1.
% #show act/1.
% #show utter/4.
% #show believe/2.
% #show believe/3.
% #show impermissible/1.
% #show permissible/1.
% #show violated/2.
% #show trigUti/3.
% #show totalUti/2.
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
