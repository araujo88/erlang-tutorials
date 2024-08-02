-module(procs).

-export([check_mail/0]).
-define(TIMEOUT, timer:seconds(5)).

check_mail() ->
    receive
        {urgent, Msg} ->
            io:format("Received message: ~p~n", [Msg])
    after 0 ->
        receive
            OtherMsg ->
                io:format("Not so urgent: ~p~n", [OtherMsg])
        end
    end.
