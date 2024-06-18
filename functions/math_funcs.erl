-module(math_funcs).
-export([fact/1,test/0]).

test() ->
	1 = fact({num, 0}),
	1 = fact({num, 1}),
	2 = fact({num, 2}),
	6 = fact({num, 3}),
	24 = fact({num, 4}),
	tests_worked.

fact({num,0}) -> 1;
fact({num,X}) -> X * fact({num,X-1}).

