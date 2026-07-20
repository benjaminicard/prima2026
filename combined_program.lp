%AS1
believe(pBelief,credible(at(r,cemetery),q)).
permissible(s1,deontologism).
act(s1,silence(p,q,0)).
believe(pBelief,at(r,family)).
believe(env,hostile(q,r)).
believe(env,harm(q,p,refusedToAnswer)).
believe(pBelief,hostile(q,r)).
believe(env,credible(at(r,family),q)).
believe(env,murderer(q)).
believe(pBelief,hostile(q,p)).
believe(pBelief,harm(q,p,refusedToAnswer)).
believe(env,utter(q,p,0,query(at(r)))).
believe(env,hostile(q,p)).
believe(env,credible(at(r,cemetery),q)).
principle(doNotEnableMurder).
principle(doNotLieExcept).
believe(pBelief,utter(q,p,0,query(at(r)))).
believe(env,at(r,cemetery)).
believe(pBelief,credible(at(r,family),q)).
believe(pBelief,credible(at(r,madrid),q)).
believe(pBelief,murderer(q)).
%AS2
utter(s2,p,q,0,inform(at(r,family))).
locally_violated(s2,doNotEnableMurder).
impermissible(s2,deontologism).
erroneous_truth(s2,p,at(r,family)).
trigUti(s2,pBelief,kill(q,p,r),-4).
impermissible(s2,principialism1).
%AS3
erroneous_lie(s3,p,at(r,cemetery)).
locally_violated(s3,doNotLie).
utter(s3,p,q,0,inform(at(r,cemetery))).
trigUti(s3,env,kill(q,p,r),-4).
impermissible(s3,deontologism).
permissible(s3,principialism1).
%AS4
locally_violated(s4,doNotLie).
impermissible(s4,deontologism).
permissible(s4,principialism1).
objective_lie(s4,p,at(r,madrid)).
utter(s4,p,q,0,inform(at(r,madrid))).
%AS5
locally_violated(s5,doNotLie).
impermissible(s5,deontologism).
permissible(s5,principialism1).
act(s5,evade(p,q)).
objective_lie(s5,p,at(r,madrid)).
utter(s5,p,q,0,inform(at(r,madrid))).

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
totalUti2(S,Y,D,T) :- T=#sum{N,D2:totalUti(S,Y,D2,N),D2<=D}, beliefbase(Y),utter(S,_,_,D,_).


% Permissibility and impermissibility for consequentialism2
impermissible(S,consequentialism2) :- totalUti2(S,env,D,N1), totalUti2(S2,env,D,N2), N2>N1, sameHistory(S,S2,D).
permissible(S,consequentialism2) :- not impermissible(S,consequentialism2,D), utter(S,_,_,D,_).



%#show totalUti/4.
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