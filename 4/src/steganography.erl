%%%-------------------------------------------------------------------
%%% @author Alexander
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Dec 2017 21:00
%%%-------------------------------------------------------------------
-module('steganography').
-author("Alexander").
-export([code/0, decode/0]).

-define(In, "sw.bmp").
-define(Out, "sw_code.bmp").

replace(Replace, SymbolUnicodeData, Step) ->
  <<Insert:2/bitstring, Rest/bitstring>> = SymbolUnicodeData,

  ReplaceOffset = Step * 8 + 6,

  <<First:ReplaceOffset/bitstring, _:2/bitstring, Other/bitstring>> = Replace,
  NewReplace = <<First/bitstring, Insert/bitstring, Other/bitstring>>,

  if byte_size(Rest) =/= 0 -> replace(NewReplace, Rest, Step + 1);
     true -> {ok, NewReplace}
  end.

set(Binary, Offset, Text) ->
  %io:fwrite("~p~n", [Text]),
  if length(Text) == 0 -> {ok, Binary};
     true ->
     [Symbol | RestText] = Text,
     %io:fwrite("~c~n", [Symbol]),
     SymbolUnicodeData = unicode:characters_to_binary(io_lib:format("~c", [Symbol]), unicode, utf8),
     SymbolUnicodeDataSize = byte_size(SymbolUnicodeData) * 4,
     AvailableSize = byte_size(Binary) - Offset,
     %io:fwrite("~p~n", [SymbolUnicodeDataSize]),
     if AvailableSize >= SymbolUnicodeDataSize + 4 ->
        <<First:Offset/binary, Replace:SymbolUnicodeDataSize/binary, Rest/binary>> = Binary,
        {ok, New} = replace(Replace, SymbolUnicodeData, 0),
        NewBinary = <<First/binary, New/binary, Rest/binary>>,
        set(NewBinary, Offset + SymbolUnicodeDataSize, RestText);
        true ->
        <<First:Offset/binary, Replace:4/binary, Rest/binary>> = Binary,
        {ok, New} = replace(Replace, <<"$">>, 0),
        NewBinary = <<First/binary, New/binary, Rest/binary>>,
        {ok, NewBinary}
     end
  end.


code() ->
  Text = "Hello, my name is Alexander",
  {ok, Binary} = file:read_file(?In),
  <<Header:54/binary,
    Data/binary>> = Binary,

  TextList = unicode:characters_to_list(unicode:characters_to_binary(string:concat(Text, "$")), utf8),
  %io:fwrite("~p~n", [Data]),
  {ok, NewData} = set(Data, 0, TextList),
  %io:fwrite("~p~n", [NewData]),

  NewBinary = <<Header/binary, NewData/binary>>,
  file:write_file(?Out, NewBinary).


read(Binary, TextData) ->
  if byte_size(Binary) < 4 -> {ok, TextData};
     true ->
     <<_:6/bitstring, P1:2/bitstring,
       _:6/bitstring, P2:2/bitstring,
       _:6/bitstring, P3:2/bitstring,
       _:6/bitstring, P4:2/bitstring,
       Rest/binary>> = Binary,
       SymbolData = <<P1/bitstring,
                      P2/bitstring,
                      P3/bitstring,
                      P4/bitstring>>,
       if SymbolData == <<"$">> -> {ok, TextData};
          true -> read(Rest, <<TextData/binary, SymbolData/binary>>)
       end
  end.

decode() ->
  {ok, Binary} = file:read_file(?Out),
  <<_:54/binary,
    Data/binary>> = Binary,
  {ok, TextData} = read(Data, <<>>),
  io:fwrite("~s~n", [TextData]).
