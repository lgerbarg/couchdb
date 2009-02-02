%% @doc MochiWebBuffer.

-module(mochiweb_buffer, [BufferProcess,Transform,TransformState]).
-author('lgerbarg@gmail.com').

-export([append/1,close/0]).

-define(BUFFER_SIZE, 8192).

push(Flush) ->
    BufferProcess ! {self(),push},
    receive
        Data ->
            case Transform of 
                gzip ->
                    zlib:deflate(TransformState, Data,Flush);
                _ ->
                    Data
            end
    end.

append(Data) ->
    BufferProcess ! {self(),append,Data},
    receive
        Count ->
            if Count >= ?BUFFER_SIZE ->
                case push(none) of
                    [] ->
                        ok;
                    <<>> ->
                        ok;
                    ReturnData ->
                        ReturnData
                end;
            true ->
                ok
            end
     end.

close() ->
    Data = push(finish),
    if TransformState =/= none ->
        zlib:deflateEnd(TransformState),
        zlib:close(TransformState);
    true ->
        ok
    end,
    BufferProcess ! shutdown,
    Data.
