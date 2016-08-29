-module(xml_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).
-export([parse_body/1, parse_bin/3]).

start(_Type, _Args) ->
	{ok, Bin} = file:read_file("/home/taras/downloads/temp/AuthenticateitErlangAssignment/Test.xml"),
	Path="/tmp/output.csv",
	file:write_file(Path,<<"GTIN,NAME,DESC,COMPANY\n">>),
	parse_bin(Bin,Path,[]),
%	io:format("XML: ~p~n", [RootElement]),
	xml_sup:start_link().

stop(_State) ->
	ok.


parse_body([]) ->
	[];
parse_body([{<<"BaseAttributeValues">>,_,_Values},_,Rest]) ->
%	io:format("BaseAttributeValues: ~p~n",[Values]),
	parse_body(Rest);
parse_body([{_,_,Rest}]) ->
	parse_body(Rest).

parse_bin(<<>>,Path,Acc) ->
%	io:format("Data: ~p~n",[Acc]),
	write_data(Acc,Path);
parse_bin(<<34,"PROD_COVER_GTIN",34," value=",34,Rest/binary>>,Path,Acc) ->
	parse_bin(Rest,Path,[{get_value(Rest,<<>>),<<>>,<<>>,<<>>}|Acc]);
parse_bin(<<34,"PROD_NAME",34," value=",34,Rest/binary>>,Path,[{GTIN,_,Desc,Owner}|Acc]) ->
	parse_bin(Rest,Path,[{GTIN,get_value(Rest,<<>>),Desc,Owner}|Acc]);
parse_bin(<<34,"PROD_DESC",34," value=",34,Rest/binary>>,Path,[{GTIN,Name,_,Owner}|Acc]) ->
	parse_bin(Rest,Path,[{GTIN,Name,get_value(Rest,<<>>),Owner}|Acc]);
parse_bin(<<34,"BRAND_OWNER_NAME",34," value=",34,Rest/binary>>,Path,[{GTIN,Name,Desc,_}|Acc]) ->
	parse_bin(Rest,Path,[{GTIN,Name,Desc,get_value(Rest,<<>>)}|Acc]);
parse_bin(<<_X,Rest/binary>>,Path,Acc) ->
	parse_bin(Rest,Path,Acc).


get_value(<<34,_Rest/binary>>,Val) ->
%	io:format("Value: ~p~n",[Val]),
%	file:write_file(Path,<<Val/binary,",">>,[append]),
%	parse_bin(Rest,Path);
	Val;
get_value(<<X,Rest/binary>>,Val) ->
	get_value(Rest,<<Val/binary,X>>).

write_data([{<<>>,_,_,_}|Rest],Path) ->
	write_data(Rest,Path);
write_data([{_,<<>>,_,_}|Rest],Path) ->
	write_data(Rest,Path);
write_data([{GTIN,Name,Desc,Owner}|Rest],Path) ->
	file:write_file(Path,<<GTIN/binary,",",Name/binary,",",Desc/binary,",",Owner/binary,"\n">>),
	write_data(Rest,Path);
write_data([],_Path) ->
	ok.

