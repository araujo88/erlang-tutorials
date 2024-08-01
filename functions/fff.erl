-module(fff).
-export([doubles/1]).

doubles([]) -> [];
doubles([Hd | Tl]) -> [Hd * 2 | doubles(Tl)].

numbers() ->
    Numbers = [
        {one, 1},
        {two, 2},
        {three, 3}
    ],

NumbersMap = fun({name, number}) ->
    NewNumbers = case name of
        one -> "low";
        two -> "medium";
        three -> "high"
    end,
    {NewNumbers, number} end,

NumbersMap = lists::map(NumbersMap, Numbers)
