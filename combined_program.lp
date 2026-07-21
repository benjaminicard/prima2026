%AS1
believe(pBelief,utter(q,p,0,query(at(r)))).
believe(env,murderer(q)).
principle(doNotLieExcept).
beliefbase(env).
impermissible(s1,deontologism).
believe(env,at(r,cemetery)).
believe(env,hostile(q,p)).
locally_violated(s1,doNotLie).
believe(pBelief,hostile(q,p)).
believe(env,kill(q,p,r)).
permissible(s1,principialism1).
believe(pBelief,at(r,family)).
totalUti(s1,env,-4).
believe(pBelief,hostile(q,r)).
believe(env,credible(at(r,cemetery),q)).
believe(pBelief,credible(at(r,madrid),q)).
principle(doNotEnableMurder).
believe(pBelief,credible(at(r,cemetery),q)).
believe(pBelief,credible(at(r,family),q)).
believe(env,hostile(q,r)).
believe(env,credible(at(r,family),q)).
believe(env,check(q,p,cemetery,r)).
trigUti(s1,env,kill(q,p,r),-4).
utter(s1,p,q,0,inform(at(r,cemetery))).
believe(pBelief,murderer(q)).
believe(pBelief,check(q,p,cemetery,r)).
erroneous_lie(s1,p,at(r,cemetery)).
beliefbase(pBelief).
totalUti(s1,pBelief,0).
believe(env,utter(q,p,0,query(at(r)))).
%AS2
impermissible(s2,deontologism).
utter(s2,p,q,0,inform(at(r,madrid))).
locally_violated(s2,doNotLie).
objective_lie(s2,p,at(r,madrid)).
permissible(s2,principialism1).
trigUti(s2,pBelief,harm(q,p,uncoveredLie),-3).
trigUti(s2,env,harm(q,p,uncredibleStatement),-3).
totalUti(s2,env,-3).
totalUti(s2,pBelief,-3).
%AS3
impermissible(s3,deontologism).
utter(s3,p,q,0,inform(at(r,madrid))).
locally_violated(s3,doNotLie).
objective_lie(s3,p,at(r,madrid)).
permissible(s3,principialism1).
trigUti(s3,pBelief,harm(q,p,uncoveredLie),-3).
trigUti(s3,env,harm(q,p,failedEvade),-3).
trigUti(s3,env,harm(q,p,uncredibleStatement),-3).
act(s3,evade(p,q)).
totalUti(s3,pBelief,-3).
totalUti(s3,env,-6).
%AS4
trigUti(s4,pBelief,harm(q,p,refusedToAnswer),-3).
permissible(s4,deontologism).
act(s4,silence(p,q,0)).
totalUti(s4,env,-3).
trigUti(s4,env,harm(q,p,refusedToAnswer),-3).
totalUti(s4,pBelief,-3).
%AS5
totalUti(s5,pBelief,-7).
locally_violated(s5,doNotEnableMurder).
impermissible(s5,deontologism).
utter(s5,p,q,0,inform(at(r,family))).
trigUti(s5,pBelief,kill(q,p,r),-4).
trigUti(s5,env,harm(q,p,uncoveredLie),-3).
trigUti(s5,pBelief,harm(q,p,uncoveredLie),-3).
erroneous_truth(s5,p,at(r,family)).
impermissible(s5,principialism1).
totalUti(s5,env,-3).

% #############  PRINCIPIALISM VERSION 2 ####################  +  #############  CONSEQUENTIALISM VERSIONS 1 AND 2 ####################




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
impermissible(S,consequentialism2) :- totalUti(S,env,N1), totalUti(S2,env,N2), N2>N1.
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
#show trigUti/4.