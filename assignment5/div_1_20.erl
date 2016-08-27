%% What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?

-module(div_1_20).
-export([start/0]).

start() ->
	start(2540).

start(X) ->
	case X rem 11 of
		0 -> 
			case X rem 13 of
				0 -> 
					case X rem 14 of
						0 -> 
							case X rem 16 of
								0 -> 
									case X rem 17 of
										0 -> 
											case X rem 18 of
												0 -> 
													case X rem 19 of
														0 -> X;
														_ -> start(X + 20)
													end;
												_ -> start(X + 20)
											end;
										_ -> start(X + 20)
									end;
								_ -> start(X + 20)
							end;
						_ -> start(X + 20)
					end;
				_ -> start(X + 20)
			end;
		_ -> start(X + 20)
	end.

