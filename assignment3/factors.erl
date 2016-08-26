%% Finds the largest prime factor of the number N.

-module(factors).
-export([find_pf/1]).

find_pf(N) ->
	find_pf(N,2,[]).

find_pf(1,_,[H|_Acc]) ->
	H;
find_pf(N,X,Acc) ->
	case N rem X of
		0 -> find_pf(N div X, X + 1, [X|Acc]);
		_ -> find_pf(N, X + 1,Acc)
	end.
