-module(collatz_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1, start_one/1, terminate/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Procs = [],
%	Procs = [{ ten, {collatz_app, collatz, [10, 0, cloop]}, permanent, 5000, worker,[collatz_app]}],
%	Max = 10,
%	Procs = lists:map(fun(X) -> {list_to_atom(integer_to_list(X)), {collatz_app, collatz, [[X, 0, cloop]]}, permanent, 5000, worker, [list_to_atom(integer_to_list(X))]} end, lists:reverse(lists:seq(1,Max))),
	{ok, {{one_for_one, 1, 5}, Procs}}.

start_one(X) ->
	Pid = list_to_atom(integer_to_list(X)),
	ChildSpecs = { Pid,	{collatz_app, collatz , [X,0,cloop]},
		permanent, 5000, worker, [collatz_app]},
			supervisor:start_child(?MODULE, ChildSpecs).

terminate(Pid) ->
	supervisor:terminate_child(?MODULE, Pid).
