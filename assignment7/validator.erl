%% Implement a GTIN-14 validator as 
%% an Erlang module function validate({gtin, Value}) -> ok | {error, Error}, 
%% Value is iolist() or binary().
%%
%% Function get_sum/1 calculates Check Digit for GTIN13.


-module(validator).
-export([validate/1,get_sum/1]).

validate({gtin, Value}) ->
	check_size(iolist_to_binary(Value));
validate(_) ->
	{error, "Invalid argument"}.


check_size(Value) ->
	case byte_size(Value) of
		14 -> check_content(Value, <<>>);
		_ -> {error, "Incorrect size of an argument"}
	end.

check_content(<<>>, Acc) ->
	check_sum(Acc);
check_content(<<X,Rest/binary>>, Acc) ->
	if
		X < 10 -> check_content(Rest, <<Acc/binary,X>>);
		true -> {error, "Not all simbols are digits"}
	end.

check_sum(<<GTIN13:13/binary,Sum>>) ->
	case get_sum(GTIN13,0,1) == Sum of
		true -> ok;
		false -> {error, "Check digit is not correct"}
	end.

get_sum(<<>>,Sum,_Count) ->
	case Sum rem 10 of
		0 -> 0;
		Low -> 10 - Low
	end;
get_sum(<<X,Rest/binary>>,Sum,Count) ->
	case Count rem 2 of
		1 -> get_sum(Rest, X * 3 + Sum, Count + 1);
		0 -> get_sum(Rest, X + Sum, Count +1)
	end.

get_sum(GTIN13) ->
	get_sum(iolist_to_binary(GTIN13),0,1).
