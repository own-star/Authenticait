%% Find the largest palindrome made from the product of two 3-digit numbers.

-module(palindrev).
-export([start/0]).

start() ->
	start(999,999,[],0,100).

start(Min, 100, Acc, _F, Min) ->
	lists:max(Acc);
start(X, Y, Acc, F, X) ->
	case is_palindrome(X * Y) of
		true -> start(999, Y - 1, [(X * Y)|Acc], 1, X);
		false -> start(999, Y - 1, Acc, F, X)
	end;
start(X, Y, Acc, F, Min) ->
	case is_palindrome(X * Y) of
		true when F /= 1 ->	start(X, Y, [(X * Y)|Acc], 1, X);
		true when F =:= 1 -> start(X - 1, Y, [(X * Y)|Acc], 1, Min);
		false -> start(X - 1, Y, Acc, F, Min)
	end.

is_palindrome(N) ->
	N2L = integer_to_list(N),
	N2L =:= lists:reverse(N2L).
