-module (ring_buf_server).

-export([start_link/2]).
-export([init/2]).

-record(state, {table, size, pos = 0}).

start_link(Size, Name) ->
  {ok, spawn_link(?MODULE, init, [Size, Name])}.

init(Size, Name)->
  Tid = ets:new(Name, [ordered_set, {read_concurrency, true}, named_table]),
  [ets:insert(Tid, [{N, <<>>}]) || N <- lists:seq(0, Size)],
  loop(#state{table=Tid, size=Size}).

loop(#state{table=Tid, size=Size, pos=Pos}=State)->
  receive
    {add, Data, From} ->
      LocalPos = Pos rem Size,
      ets:insert(Tid, {LocalPos, Data}),
      From ! {ok, LocalPos},
      loop(State#state{pos=Pos+1});
    _ ->
      loop(State)
  end.
