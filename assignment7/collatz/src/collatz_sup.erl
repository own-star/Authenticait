-module(collatz_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1, start_one/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
Procs = [{simple, {collatz_app, collatz, []}, permanent, 5000, worker,[collatz_app]}],
	{ok, {{simple_one_for_one, 0, 1}, Procs}}.

start_one(X) ->
			supervisor:start_child(?MODULE, [X,0,cloop,X]).

