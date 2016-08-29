-module(xml_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	{ok, Bin} = file:read_file("/home/taras/downloads/temp/AuthenticateitErlangAssignment/Test.xml"),
	RootElement = exomler:decode(Bin),
	io:format("XML: ~p~n", [RootElement]),
	xml_sup:start_link().

stop(_State) ->
	ok.
