-module(collatz_mod).
-export([calc/1]).

calc(N) ->
	calc(N, 0, N).

calc(1, Acc, Orig) ->
	{Orig, Acc + 1};
calc(X, Acc, Orig) ->
	case X rem 2 of
		0 -> calc(X div 2, Acc + 1, Orig);
		1 -> calc(X * 3 + 1, Acc + 1, Orig)
	end.

