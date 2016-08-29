-module(xml_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
%	{ok, Bin} = file:read_file("/home/taras/downloads/temp/AuthenticateitErlangAssignment/Test.xml"),
%	Path="/tmp/output.csv",
%	file:write_file(Path,<<"GTIN,NAME,DESC,COMPANY\n">>),
%	parse_bin(Bin,Path,[]),
%	io:format("XML: ~p~n", [RootElement]),

	Dispatch = cowboy_router:compile([
		{'_', [
			{"/capture", toppage_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_http(http, 10, [{port, 8080}], [
		{env, [{dispatch, Dispatch}]}
	]),

	xml_sup:start_link().

stop(_State) ->
	ok.
