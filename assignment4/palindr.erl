-module(palindr).
-export([start/0]).

start() ->
	start(100,100,[]).

start(999, 999, Acc) ->
	lists:max(Acc);
start(999, Y, Acc) ->
	case is_palindrome(999 * Y) of 
		true ->  start(100, Y + 1, [(999 * Y)|Acc]);
		false -> start(100, Y + 1, Acc)
	end;
start(X, Y, Acc) ->
	case is_palindrome(X * Y) of
		true ->	start(X + 1, Y, [(X * Y)|Acc]);
		false -> start(X + 1, Y, Acc)
	end.

is_palindrome(N) ->
	N2L = integer_to_list(N),
	N2L =:= lists:reverse(N2L).
