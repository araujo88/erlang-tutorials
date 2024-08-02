-module(monte_carlo).

-export([run/2, iterate/2]).

run(NumOfPoints, NumOfProcs) ->
	Args = [NumOfPoints div NumOfProcs, self()],
	_Pids = [spawn(?MODULE, iterate, Args) || 
		_ <- lists:seq(1, NumOfProcs)],
	CirclePoints = collect_circle_points(NumOfProcs),
	4 * CirclePoints / NumOfPoints.

iterate(NumOfPoints, CollectorPid) ->
	Points = [{rand:uniform(), rand:uniform()} ||
		_ <- lists:seq(1, NumOfPoints)],
	CirclePoints = [{X,Y} || {X, Y} <- Points, 
		inside_circle(X, Y)],
	CollectorPid ! length(CirclePoints).

inside_circle(X, Y) ->
	X * X + Y * Y =< 1.

collect_circle_points(NumOfProcesses) ->
	collect_circle_points(NumOfProcesses, 0).
collect_circle_points(0, Acc) -> Acc;
collect_circle_points(NumOfProcesses, Acc) ->
	receive
		CirclePoints ->
			collect_circle_points(NumOfProcesses - 1,
					      Acc + CirclePoints)
	end.
