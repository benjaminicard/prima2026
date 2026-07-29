%AS1
utter(s1,p,q,0,inform(at(r,madrid))).
believe(env,hostile(q,r)).
believe(pBelief,credible(at(r,cemetery),q)).
believe(pBelief,murderer(q)).
believe(pBelief,credible(at(r,madrid),q)).
beliefbase(pBelief).
believe(env,murderer(q)).
locally_violated(s1,doNotLie).
trigUti(s1,env,harm(q,p,uncredibleStatement),-3).
believe(pBelief,harm(q,p,uncoveredLie)).
impermissible(s1,deontologism).
principle(doNotEnableMurder).
believe(env,credible(at(r,cemetery),q)).
principle(doNotLieExcept).
believe(env,harm(q,p,uncredibleStatement)).
objective_lie(s1,p,at(r,madrid)).
permissible(s1,principialism1).
totalUti(s1,pBelief,-3).
beliefbase(env).
believe(pBelief,hostile(q,p)).
believe(pBelief,at(r,family)).
trigUti(s1,pBelief,harm(q,p,uncoveredLie),-3).
totalUti(s1,env,-3).
believe(pBelief,check(q,p,madrid,r)).
believe(pBelief,utter(q,p,0,query(at(r)))).
believe(env,hostile(q,p)).
believe(env,credible(at(r,family),q)).
believe(env,utter(q,p,0,query(at(r)))).
believe(pBelief,credible(at(r,family),q)).
believe(pBelief,hostile(q,r)).
believe(env,at(r,cemetery)).
%AS2
utter(s2,p,q,0,inform(at(r,madrid))).
locally_violated(s2,doNotLie).
trigUti(s2,env,harm(q,p,uncredibleStatement),-3).
impermissible(s2,deontologism).
objective_lie(s2,p,at(r,madrid)).
totalUti(s2,env,-6).
permissible(s2,principialism1).
totalUti(s2,pBelief,0).
act(s2,evade(p,q)).
trigUti(s2,env,harm(q,p,failedEvade),-3).
%AS3
trigUti(s3,env,kill(q,p,r),-4).
erroneous_lie(s3,p,at(r,cemetery)).
locally_violated(s3,doNotLie).
impermissible(s3,deontologism).
permissible(s3,principialism1).
totalUti(s3,pBelief,-3).
totalUti(s3,env,-4).
trigUti(s3,pBelief,harm(q,p,uncoveredLie),-3).
utter(s3,p,q,0,inform(at(r,cemetery))).
%AS4
trigUti(s4,pBelief,harm(q,p,refusedToAnswer),-3).
permissible(s4,deontologism).
act(s4,silence(p,q,0)).
totalUti(s4,pBelief,-3).
totalUti(s4,env,-3).
trigUti(s4,env,harm(q,p,refusedToAnswer),-3).
%AS5
totalUti(s5,pBelief,-4).
impermissible(s5,deontologism).
utter(s5,p,q,0,inform(at(r,family))).
locally_violated(s5,doNotEnableMurder).
impermissible(s5,principialism1).
totalUti(s5,env,-3).
trigUti(s5,env,harm(q,p,uncoveredLie),-3).
erroneous_truth(s5,p,at(r,family)).
trigUti(s5,pBelief,kill(q,p,r),-4).

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
