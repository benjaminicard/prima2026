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
    utter(S1,p,q,D,inform(at(r,L1))), L1!=L2,
    believe(p(D), at(r, L2)),
    utter(S2,p,q,D,inform(at(r,L2))),
    sameHistory(S1,S2,D).

    
% Second exception rule for lies: lying is permitted if truth leads to worst consequences
exceptionRel(S, doNotLieExcept,D) :-
    utter(S,p,q,D,inform(at(r, L1))),
    counterfactual(S, S2, inform(at(r,L1))),
    totalUti(S,p(D),D , T1),
    totalUti(S2, p(D),D, T2),
    T1 > T2.


% Rule stating (local) violation of lying principle in the absence of second exception
violated(S, R,D) :-
    locally_violated(S, R,D),
    not exceptionRel(S, R,D).

% Permissibility and impermissibility for principialism2
permissible(S,principialism2, D) :- not impermissible(S,principialism2,D), utter(S,_,_,D,_).
impermissible(S,principialism2, D) :- violated(S, R,D), principle(R).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CONSEQUENTIALISM VERSION 1
% Permissibility and impermissibility for consequentialism1
impermissible(S,consequentialism1,D) :- totalUti(S,p(D),D,N1), totalUti(S2,p(D),D,N2), N2>N1,sameHistory(S,S2,D).
permissible(S,consequentialism1,D) :- not impermissible(S,consequentialism1,D), utter(S,_,_,D,_).


% CONSEQUENTIALISM VERSION 2
% Calculation of total utility based on sums of total utilities of each action
totalUti2(S,Y,D,T) :- T=#sum{N,D2:totalUti(S,Y,D2,N),D2<=D}, beliefbase(Y),utter(S,_,_,D,_).


% Permissibility and impermissibility for consequentialism2
impermissible(S,consequentialism2,D) :- totalUti2(S,env,D,N1), totalUti2(S2,env,D,N2), N2>N1, sameHistory(S,S2,D).
permissible(S,consequentialism2,D) :- not impermissible(S,consequentialism2,D), utter(S,_,_,D,_).



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