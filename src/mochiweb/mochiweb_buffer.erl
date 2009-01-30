%% @doc MochiWebBuffer.

-module(mochiweb_buffer, [BufferProcess,Transform,Z]).
-author('lgerbarg@gmail.com').

-export([append/1,flush/0]).

-define(BUFFER_SIZE, 8192).

push() ->
    BufferProcess ! {self(),push},
    receive
        Data ->
            case Transform of 
                gzip ->
                    zlib:gzip(Data);
                _ ->
                    Data
            end
    end.

append(Data) ->
    BufferProcess ! {self(),append,Data},
    receive
        Count ->
            if Count >= ?BUFFER_SIZE ->
                push();
            true ->
                ok
            end
     end.

flush() ->
    Retval = push(),
    BufferProcess ! shutdown,
    Retval.
