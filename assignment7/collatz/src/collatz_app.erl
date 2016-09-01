-module(collatz_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).
-export([collatz/3, run/1]).

start(_Type, _Args) ->
%	Max = 10,
%	register(cloop, spawn(fun() -> loop(Max,0,0) end)),
%	collatz(13, 0, cloop),
%	lists:map(fun(X) -> collatz_app:collatz(X,0,cloop) end, lists:reverse(lists:seq(1,Max))),
	collatz_sup:start_link().

run(Max) ->
	register(cloop, spawn(fun() -> loop(Max,0,0) end)),
	lists:map(fun(X) -> collatz_sup:start_one(X) end, lists:reverse(lists:seq(1,Max))).

stop(_State) ->
	ok.


collatz(1, Acc, From) ->
	From ! {self(), Acc + 1},
	ok;
collatz(X, Acc, From) ->
	case X rem 2 of
		0 -> collatz(X div 2, Acc + 1, From);
		1 -> collatz(X * 3 + 1, Acc + 1, From)
	end.

loop(X, X, Max) ->
	io:format("Max: ~p~n", [Max]),
	Max;
loop(X, Acc, Max) ->
	io:format("X: ~p, Acc: ~p, Max: ~p~n", [X,Acc,Max]),
	receive
		{From, Count} ->
			if 
				Count > Max ->
					loop(X, Acc + 1, Count);
				true -> loop(X, Acc + 1, Max)
			end,
			io:format("From: ~p, Count: ~p, Max: ~p, X: ~p~n", [From, Count, Max, X]),
			collatz_sup:terminate(From)
	end.
