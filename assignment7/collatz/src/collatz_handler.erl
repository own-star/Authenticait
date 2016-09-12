-module(collatz_handler).
-behaviour(gen_server).

-export([start/0, stop/0]).
-export([collatz/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

start() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, 1000000, []).
stop() ->
	gen_server:call(?MODULE, stop).


collatz(N) -> 
	gen_server:cast(?MODULE, N).


init(Max) ->
	io:format("Handler init: Max: ~p here~n",[Max]),
	timer:start(),
	{ok, _TRef} = timer:apply_after(1000, lists,map,[fun(X) -> collatz_sup:init(X) end, lists:reverse(lists:seq(1,Max))]),
	{ok, {Max-1, 0, {0,0}}}.

%handle_call(_, _From, {X, X, Max} = State) ->
%	io:format("Max: ~p~n", [Max]),
%	{stop, normal, Max, State};
%handle_call({New, Count}, _From, {X, Acc, {Old, Max}}) ->
%		State = 
%	   		case Count > Max of
%				true -> {X, Acc + 1, {New, Count}};
%				false -> {X, Acc + 1, {Old, Max}}
%			end,
%			io:format("State: ~p~n",[State]),
%			{reply, [], State};

handle_call(stop, _From, State) ->
	{stop, normal, stopped, State}.

handle_cast(_,  {X, X, Max} = State) ->
	io:format("Max: ~p~n", [Max]),
	{stop, normal, State};
handle_cast(N, {X, Acc, {Old, Max}}) ->
		{New, Count} = collatz_mod:calc(N),
		State = 
	   		case Count > Max of
				true -> {X, Acc + 1, {New, Count}};
				false -> {X, Acc + 1, {Old, Max}}
			end,
%			io:format("State: ~p~n",[State]),
			{noreply, State};

handle_cast(_Msg, State) -> {noreply, State}.

handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.


