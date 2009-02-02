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
            if binary(NewData) ->
               ListData = binary_to_list(NewData);
            list(NewData) ->
               ListData = NewData;
            true ->
               ListData = []
            end,
            FullData = Data ++ ListData,
            From ! lists:flatlength(FullData),
            loop(FullData);
        {From,push} ->
            From ! Data,
            loop([])
    end.
