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