%% Evaluates sum of the even-valued terms in the Fibonacci sequence whose values do not exceed X.
%% Returns {n,Fn,Sum}.

-module(fib).
-export([fib/1]).

fib(X) -> fib(0,0,1,0,X).
	
fib(N,Acc1,Acc2,AccEv,X) when Acc2 >= X -> 
	{N-1,Acc1,AccEv};
fib(N,Acc1,Acc2,AccEv,X)  ->
	case Acc2 rem 2 of
		0 -> fib(N + 1, Acc2, Acc1 + Acc2, AccEv + Acc2, X);
		1 -> fib(N + 1, Acc2, Acc1 + Acc2, AccEv, X)
	end.
