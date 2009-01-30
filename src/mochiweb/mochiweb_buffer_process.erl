%% @doc MochiWebBufferProcess.

-module(mochiweb_buffer_process).
-author('lgerbarg@gmail.com').

-export([make/0]).

make() ->
    spawn(fun() -> loop([]) end).

loop(Data) ->
    receive
        shutdown ->
            ok;
        {From,append,NewData} ->
          FullData = Data ++ NewData,
          From ! lists:flatlength(FullData),
          loop(FullData);
        {From,push} ->
            From ! Data,
            loop([])
    end.
