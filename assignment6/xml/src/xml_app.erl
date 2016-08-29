-module(xml_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).
-export([parse_body/1, parse_bin/2]).

start(_Type, _Args) ->
	{ok, Bin} = file:read_file("/home/taras/downloads/temp/AuthenticateitErlangAssignment/Test.xml"),
	Path="/tmp/output.csv",
	file:write_file(Path,<<"GTIN,NAME,DESC,COMPANY\n">>),
	parse_bin(Bin,Path),
%	io:format("XML: ~p~n", [RootElement]),
	xml_sup:start_link().

stop(_State) ->
	ok.


parse_body([]) ->
	[];
parse_body([{<<"BaseAttributeValues">>,_,Values},_,Rest]) ->
	io:format("BaseAttributeValues: ~p~n",[Values]),
	parse_body(Rest);
parse_body([{_,_,Rest}]) ->
	parse_body(Rest).

parse_bin(<<>>,_Path) ->
	<<>>;
parse_bin(<<34,"PROD_COVER_GTIN",34," value=",34,Rest/binary>>,Path) ->
	get_value(Rest,<<>>,Path);
parse_bin(<<34,"PROD_NAME",34," value=",34,Rest/binary>>,Path) ->
	get_value(Rest,<<>>,Path);
parse_bin(<<34,"PROD_DESC",34," value=",34,Rest/binary>>,Path) ->
	get_value(Rest,<<>>,Path);
parse_bin(<<34,"BRAND_OWNER_NAME",34," value=",34,Rest/binary>>,Path) ->
	get_value(Rest,<<>>,Path);
parse_bin(<<_X,Rest/binary>>,Path) ->
	parse_bin(Rest,Path).


get_value(<<34,Rest/binary>>,Val,Path) ->
	io:format("Value: ~p~n",[Val]),
	file:write_file(Path,<<Val/binary,",">>,[append]),
	parse_bin(Rest,Path);
get_value(<<X,Rest/binary>>,Val,Path) ->
	get_value(Rest,<<Val/binary,X>>,Path).
