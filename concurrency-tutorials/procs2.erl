-module(procs2).
-export([loop/0, start/1]).

loop() ->
	receive
		{Msg, From} ->
			io:format("Received msg: ~p from: ~p~n", [Msg, From]),
			loop();
		stop ->
			ok
	end.

start(Name) ->
	Pid = spawn(?MODULE, loop, []),
	register(Name, Pid).
