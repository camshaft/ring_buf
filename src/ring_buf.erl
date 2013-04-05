-module(ring_buf).

-export ([start_link/0]).
-export ([start_link/1]).
-export ([start_link/2]).

-export ([add/2]).
-export ([add_all/2]).
-export ([read/1]).
-export ([read/2]).

start_link() ->
  start_link(512).

start_link(Length) ->
  ring_buf_server:start_link(Length, ?MODULE).

start_link(Length, Name) ->
  ring_buf_server:start_link(Length, Name).

%%%----------------------------------------------------------------------
%%% Usable Functions
%%%----------------------------------------------------------------------

add(Server, Data) ->
  Server ! {add, Data, self()},
  receive
    {ok, Pos} ->
      {ok, Pos};
    _ ->
      ok
  end.

add_all(Server, List)->
  Server ! {add_all, List, self()},
  receive
    {ok, Numbers} ->
      {ok, Numbers};
    _ ->
      ok
  end.

read(Pos)->
  read(?MODULE, Pos).
read(Table, Pos) ->
  {_, Value} = hd(ets:lookup(Table, Pos)),
  Value.
