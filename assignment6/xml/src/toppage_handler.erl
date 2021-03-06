%% Feel free to use, reuse and abuse the code in this file.

-module(toppage_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Type, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
	{Method, Req2} = cowboy_req:method(Req),
	HasBody = cowboy_req:has_body(Req2),
	{ok, Req3} = capture(Method, HasBody, Req2),
	{ok, Req3, State}.

capture(<<"POST">>, true, Req) ->
	{_Args, Req1} = cowboy_req:qs_vals(Req),
	{ok, Bin, Req2} = cowboy_req:body(Req1),
	{{{A,B,C,D},Port},_} = cowboy_req:peer(Req2),
	Peer = integer_to_list(A) ++ "." ++ integer_to_list(B) ++ "." ++ integer_to_list(C) ++ "." ++ integer_to_list(D) ++ "." ++ integer_to_list(Port) ++ ".",
	STime = erlang:system_time(),
	TS=integer_to_list(STime),
	Path="/tmp/" ++ Peer ++ TS ++ ".csv",
	file:write_file(Path,<<"GTIN,NAME,DESC,COMPANY\n">>),
	parse_bin(Bin, Path, [],Req2);
capture(<<"POST">>, false, Req) ->
	cowboy_req:reply(400, [], <<"Missing body.">>, Req);
capture(_, _, Req) ->
	%% Method not allowed.
	cowboy_req:reply(405, Req).

parse_bin(<<>>,Path,Acc,Req) ->
	write_data(Acc,Path),
	BPath=list_to_binary(Path),
	cowboy_req:reply(200, [
		{<<"content-type">>, <<"text/plain; charset=utf-8">>}
	], <<"Data has been written to file",BPath/binary>>, Req);
parse_bin(<<34,"PROD_COVER_GTIN",34," value=",34,Rest/binary>>,Path,Acc,Req) ->
	parse_bin(Rest,Path,[{get_value(Rest,<<>>),<<>>,<<>>,<<>>}|Acc],Req);
parse_bin(<<34,"PROD_NAME",34," value=",34,Rest/binary>>,Path,[{GTIN,_,Desc,Owner}|Acc],Req) ->
	parse_bin(Rest,Path,[{GTIN,get_value(Rest,<<>>),Desc,Owner}|Acc],Req);
parse_bin(<<34,"PROD_DESC",34," value=",34,Rest/binary>>,Path,[{GTIN,Name,_,Owner}|Acc],Req) ->
	parse_bin(Rest,Path,[{GTIN,Name,get_value(Rest,<<>>),Owner}|Acc],Req);
parse_bin(<<34,"BRAND_OWNER_NAME",34," value=",34,Rest/binary>>,Path,[{GTIN,Name,Desc,_}|Acc],Req) ->
	parse_bin(Rest,Path,[{GTIN,Name,Desc,get_value(Rest,<<>>)}|Acc],Req);
parse_bin(<<_X,Rest/binary>>,Path,Acc,Req) ->
	parse_bin(Rest,Path,Acc,Req).


get_value(<<34,_Rest/binary>>,Val) ->
	Val;
get_value(<<X,Rest/binary>>,Val) ->
	get_value(Rest,<<Val/binary,X>>).

write_data([{<<>>,_,_,_}|Rest],Path) ->
	write_data(Rest,Path);
write_data([{_,<<>>,_,_}|Rest],Path) ->
	write_data(Rest,Path);
write_data([{GTIN,Name,Desc,Owner}|Rest],Path) ->
	file:write_file(Path,<<GTIN/binary,",",Name/binary,",",Desc/binary,",",Owner/binary,"\n">>,[append]),
	write_data(Rest,Path);
write_data([],_Path) ->
	ok.


terminate(_Reason, _Req, _State) ->
	ok.
