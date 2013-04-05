-module (ring_buf_benchmark).

-export ([test/1]).

test(Limit)->
  Case = <<"182 <40>1 2013-03-21T22:52:26+00:00 d.de02fad5-ca75-4863-8d0a-de58404f9225 heroku web.1 - - source=heroku.6041702.web.1.dabb0da6-d9d5-4627-a299-0b218adf1d3e measure=load_avg_5m val=0.00\n">>,

  {ok, Pid} = ring_buf:start_link(8192, ?MODULE),

  Cases = [Case || _ <- lists:seq(1,Limit)],

  {Time, _} = timer:tc(fun()-> loop(Cases, Pid) end),

  io:format("~p iterations in ~ps~n", [Limit, Time/1000000]),
  io:format("~p frames/sec~n", [Limit/(Time/1000000)]).

loop(Cases, Pid) ->
  lists:foreach(fun(Case) ->
    ring_buf:add(Pid, Case)
  end, Cases).
