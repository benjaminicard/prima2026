%AS1
believe(pBelief,credible(at(r,family),q)).
totalUti(s1,env,-4).
believe(env,credible(at(r,cemetery),q)).
believe(env,credible(at(r,family),q)).
principle(doNotEnableMurder).
believe(pBelief,utter(q,p,0,query(at(r)))).
believe(pBelief,credible(at(r,madrid),q)).
totalUti(s1,pBelief,0).
principle(doNotLieExcept).
permissible(s1,principialism1).
believe(env,at(r,cemetery)).
believe(env,hostile(q,p)).
locally_violated(s1,doNotLie).
believe(env,murderer(q)).
erroneous_lie(s1,p,at(r,cemetery)).
believe(pBelief,credible(at(r,cemetery),q)).
believe(env,hostile(q,r)).
beliefbase(pBelief).
utter(s1,p,q,0,inform(at(r,cemetery))).
believe(pBelief,check(q,p,cemetery,r)).
trigUti(s1,env,kill(q,p,r),-4).
believe(env,check(q,p,cemetery,r)).
believe(pBelief,hostile(q,p)).
believe(pBelief,at(r,family)).
believe(env,utter(q,p,0,query(at(r)))).
believe(env,kill(q,p,r)).
beliefbase(env).
believe(pBelief,murderer(q)).
believe(pBelief,hostile(q,r)).
impermissible(s1,deontologism).
%AS2
trigUti(s2,env,harm(q,p,uncredibleStatement),-3).
permissible(s2,principialism1).
totalUti(s2,pBelief,-3).
locally_violated(s2,doNotLie).
trigUti(s2,pBelief,harm(q,p,uncoveredLie),-3).
totalUti(s2,env,-3).
utter(s2,p,q,0,inform(at(r,madrid))).
objective_lie(s2,p,at(r,madrid)).
impermissible(s2,deontologism).
%AS3
trigUti(s3,env,harm(q,p,uncredibleStatement),-3).
permissible(s3,principialism1).
totalUti(s3,pBelief,-3).
locally_violated(s3,doNotLie).
totalUti(s3,env,-6).
trigUti(s3,pBelief,harm(q,p,uncoveredLie),-3).
act(s3,evade(p,q)).
utter(s3,p,q,0,inform(at(r,madrid))).
trigUti(s3,env,harm(q,p,failedEvade),-3).
objective_lie(s3,p,at(r,madrid)).
impermissible(s3,deontologism).
%AS4
trigUti(s4,pBelief,harm(q,p,refusedToAnswer),-3).
permissible(s4,deontologism).
totalUti(s4,pBelief,-3).
totalUti(s4,env,-3).
act(s4,silence(p,q,0)).
trigUti(s4,env,harm(q,p,refusedToAnswer),-3).
%AS5
impermissible(s5,principialism1).
utter(s5,p,q,0,inform(at(r,family))).
trigUti(s5,pBelief,kill(q,p,r),-4).
trigUti(s5,env,harm(q,p,uncoveredLie),-3).
trigUti(s5,pBelief,harm(q,p,uncoveredLie),-3).
totalUti(s5,pBelief,-7).
totalUti(s5,env,-3).
locally_violated(s5,doNotEnableMurder).
erroneous_truth(s5,p,at(r,family)).
impermissible(s5,deontologism).

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

% Permissibility and impermissibility for consequentialism2
impermissible(S,consequentialism2) :- totalUti(S,env,N1), totalUti(S2,env,N2), N2>N1.
permissible(S,consequentialism2) :- not impermissible(S,consequentialism2), utter(S,_,_,_,_).
