-module(collatz_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1, start_one/1, terminate/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Procs = [],
	{ok, {{one_for_one, 1, 5}, Procs}}.

start_one(X) ->
	Pid = list_to_atom(integer_to_list(X)),
	ChildSpecs = [#{id => Pid,
					start => {collatz_app, collatz , [X,0,cloop]},
					shutdown => brutal_kill}],
			supervisor:start_child(?MODULE, ChildSpecs).

terminate(Pid) ->
	supervisor:terminate_child(?MODULE, Pid).
