%AS1
principle(doNotLieExcept).
objective_lie(s1,p,at(r,madrid)).
believe(env,hostile(q,r)).
trigUti(s1,pBelief,harm(q,p,uncoveredLie),-3).
believe(env,credible(at(r,family),q)).
permissible(s1,principialism1).
totalUti(s1,env,-3).
trigUti(s1,pBelief,harm(q,p,uncredibleStatement),-3).
believe(env,hostile(q,p)).
totalUti(s1,pBelief,-6).
believe(pBelief,check(q,p,madrid,r)).
believe(pBelief,harm(q,p,uncredibleStatement)).
believe(env,credible(at(r,cemetery),q)).
utter(s1,p,q,0,inform(at(r,madrid))).
believe(pBelief,credible(at(r,family),q)).
believe(pBelief,utter(q,p,0,query(at(r)))).
believe(pBelief,credible(at(r,madrid),q)).
believe(pBelief,credible(at(r,cemetery),q)).
impermissible(s1,deontologism).
believe(env,at(r,cemetery)).
locally_violated(s1,doNotLie).
believe(pBelief,harm(q,p,uncoveredLie)).
beliefbase(env).
believe(pBelief,at(r,family)).
believe(env,murderer(q)).
beliefbase(pBelief).
principle(doNotEnableMurder).
believe(pBelief,hostile(q,r)).
believe(pBelief,murderer(q)).
believe(pBelief,hostile(q,p)).
trigUti(s1,env,harm(q,p,uncredibleStatement),-3).
believe(env,utter(q,p,0,query(at(r)))).
believe(env,harm(q,p,uncredibleStatement)).
%AS2
objective_lie(s2,p,at(r,madrid)).
trigUti(s2,pBelief,harm(q,p,uncoveredLie),-3).
permissible(s2,principialism1).
trigUti(s2,pBelief,harm(q,p,uncredibleStatement),-3).
totalUti(s2,pBelief,-6).
utter(s2,p,q,0,inform(at(r,madrid))).
impermissible(s2,deontologism).
locally_violated(s2,doNotLie).
act(s2,evade(p,q)).
trigUti(s2,env,harm(q,p,uncredibleStatement),-3).
trigUti(s2,env,harm(q,p,failedEvade),-3).
totalUti(s2,env,-6).
%AS3
permissible(s3,principialism1).
trigUti(s3,pBelief,harm(q,p,uncredibleStatement),-3).
erroneous_lie(s3,p,at(r,cemetery)).
totalUti(s3,env,-7).
totalUti(s3,pBelief,-3).
impermissible(s3,deontologism).
locally_violated(s3,doNotLie).
utter(s3,p,q,0,inform(at(r,cemetery))).
trigUti(s3,env,kill(q,p,r),-4).
trigUti(s3,env,harm(q,p,uncredibleStatement),-3).
%AS4
act(s4,silence(p,q,0)).
trigUti(s4,env,harm(q,p,refusedToAnswer),-3).
totalUti(s4,env,-3).
totalUti(s4,pBelief,-3).
permissible(s4,deontologism).
trigUti(s4,pBelief,harm(q,p,refusedToAnswer),-3).
%AS5
impermissible(s5,principialism1).
erroneous_truth(s5,p,at(r,family)).
trigUti(s5,pBelief,harm(q,p,uncoveredLie),-3).
trigUti(s5,pBelief,harm(q,p,uncredibleStatement),-3).
utter(s5,p,q,0,inform(at(r,family))).
impermissible(s5,deontologism).
trigUti(s5,env,harm(q,p,uncoveredLie),-3).
totalUti(s5,pBelief,-10).
trigUti(s5,pBelief,kill(q,p,r),-4).
trigUti(s5,env,harm(q,p,uncredibleStatement),-3).
totalUti(s5,env,-6).
locally_violated(s5,doNotEnableMurder).

% #############  PRINCIPIALISM VERSION 2 ####################  +  #############  CONSEQUENTIALISM VERSIONS 1 AND 2 ####################

% Util predicate to check if two scenarios have the same history up to decision D
sameHistory(S1,S2,D):-
    utter(S1,_,_,D,_), utter(S2,_,_,D,_), S1!=S2,
    {act(S1, D2, A2) : D2<D, not act(S2, D2, A2)}0,
    {act(S2, D3, A3) : D3<D, not act(S1, D3, A3)}0,
    {utter(S1,X1,Y1,D4,F1) : D4<D, not utter(S2,X1,Y1,D4,F1)}0,
    {utter(S2,X2,Y2,D5,F2) : D5<D, not utter(S1,X2,Y2,D5,F2)}0.
    


% PRINCIPIALISM VERSION 2
% Rule for comparing decisions based on counterfactual comparison
counterfactual(S1, S2, inform(at(r, L1))) :-
    utter(S1,p,q,N,inform(at(r,L1))), L1!=L2,
    believe(pBelief, at(r, L2)),
    utter(S2,p,q,N,inform(at(r,L2))).

    
% Second exception rule for lies: lying is permitted if truth leads to worst consequences
exceptionRel(S, doNotLieExcept) :-
    utter(S,p,q,N,inform(at(r, L1))),
    counterfactual(S, S2, inform(at(r,L1))),
    totalUti(S,pBelief, T1),
    totalUti(S2, pBelief, T2),
    T1 > T2.


% Rule stating (local) violation of lying principle in the absence of second exception
violated(S, R) :-
    locally_violated(S, R),
    not exceptionRel(S, R).

% Permissibility and impermissibility for principialism2
permissible(S,principialism2) :- not impermissible(S,principialism2), utter(S,_,_,_,_).
impermissible(S,principialism2) :- violated(S, R), principle(R).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CONSEQUENTIALISM VERSION 1
% Permissibility and impermissibility for consequentialism1
impermissible(S,consequentialism1) :- totalUti(S,pBelief,N1), totalUti(S2,pBelief,N2), N2>N1.
permissible(S,consequentialism1) :- not impermissible(S,consequentialism1), utter(S,_,_,_,_).


% CONSEQUENTIALISM VERSION 2
% Calculation of total utility based on sums of total utilities of each action
% totalUti2(S,Y,D,T) :- T=#sum{N,D2:totalUti(S,Y,D2,N),D2<=D}, beliefbase(Y),utter(S,_,_,D,_).


% Permissibility and impermissibility for consequentialism2
impermissible(S,consequentialism2) :- totalUti(S,env,N1), totalUti2(S2,env,N2), N2>N1.
permissible(S,consequentialism2) :- not impermissible(S,consequentialism2), utter(S,_,_,_,_).



% #show totalUti/3.
%#show totalUti2/4.
%#show locally_violated/3.
%#show violated/3.
%#show act/3.
%#show exceptionRel/3.
%#show counterfactual/3.
%#show objective_lie/4.
%#show objective_truth/4.
%#show erroneous_lie/4.
%#show erroneous_truth/4.
%#show permissible/3.
%#show impermissible/3.
% #show trigUti/5.