-module(collatz_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).
-export([collatz/4, run/1]).

start(_Type, _Args) ->
	collatz_sup:start_link().


run(Max) ->
	register(cloop, spawn(fun() -> loop(Max,0,{0,0}) end)),
	lists:map(fun(X) -> collatz_sup:start_one(X) end, lists:reverse(lists:seq(1,Max))).

stop(_State) ->
	ok.


collatz(1, Acc, From, Orig) ->
	From ! {Orig, Acc + 1},
	ok;
collatz(X, Acc, From, Orig) ->
	case X rem 2 of
		0 -> collatz(X div 2, Acc + 1, From, Orig);
		1 -> collatz(X * 3 + 1, Acc + 1, From, Orig)
	end.

loop(X, X, Max) ->
	io:format("Max: ~p~n", [Max]),
	{ok, Max};
loop(X, Acc, {Old, Max}) ->
	receive
		{New, Count} ->
			if 
				Count > Max ->
					loop(X, Acc + 1, {New, Count});
				true -> loop(X, Acc + 1, {Old, Max})
			end
	end.

