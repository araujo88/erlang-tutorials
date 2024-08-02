-module(music_server).
-define(SERVER, ?MODULE).

-record(state, {volume = 0}).

-export([start/1, loop/1, stop/1, set_volume/2,  get_software_update/1]).

start(ServerRef) ->
	State = #state{},
	Pid = spawn(?MODULE, loop, [State]),
	register(ServerRef, Pid),
	Pid.

set_volume(ServerRef, NewVolume) ->
	Pid = whereis(ServerRef),
	Pid ! {set_volume, NewVolume},
	ok.
	
stop(ServerRef) ->
	Pid = whereis(ServerRef),
	Pid ! stop.

get_software_update(ServerRef) ->
	Pid = whereis(ServerRef),
	From = self(),
	Request = {get_software_update},
	Pid ! {call, Request, From},
	receive Reply -> Reply end.

loop(State) ->
	receive
		{call, Request, From} ->
			{reply, Reply} = handle_call(Request),
			From ! Reply,
			loop(State);
		{set_volume, NewVolume} -> 
			NewState = handle_cast({set_volume, NewVolume}, State),
			loop(NewState);
		stop ->
			ok;
		Other ->
			io:format("Received unexpected msg: ~p", [Other]),
			loop(State)
	end.

%% internal functions
handle_call({get_software_update}) ->
	timer:sleep(timer:seconds(4)),
	{reply, no_update_available}.

handle_cast({set_volume, NewVolume}, State) ->
	timer:sleep(timer:seconds(4)),
	io:format("Volume is now set to ~p~n", [NewVolume]),
	State#state{volume = NewVolume}.
