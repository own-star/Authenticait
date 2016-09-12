-module(collatz_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Procs = [{start, {collatz_handler, start, []}, transient, 5000, worker,[collatz_handler]}],
	{ok, {{one_for_one, 1, 1}, Procs}};
init(X) ->
	Specs = {collatz, {collatz_handler, collatz, [X]}, transient, 5000, worker,[collatz_handler]},
			supervisor:start_child(?MODULE, Specs).

