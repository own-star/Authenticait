%% Find the sum of all the multiples of 3 or 5 below N.

-module(sum_3_5).
-export([find_sum/1]).

find_sum(N) ->
	find_sum(N - 1, 0).

find_sum(3, Acc) ->
	Acc + 3;
find_sum(N, Acc) ->
	case N rem 3 of
		0 -> find_sum(N-1, Acc + N);
		_ ->
			case N rem 5 of
				0 -> find_sum(N - 1, Acc + N);
				_ -> find_sum(N - 1, Acc)
			end
	end.
