-module(sf_transform).

%% API exports
-export([parse_transform/2]).

%%====================================================================
%% API functions
%%====================================================================
parse_transform(AST, Options) ->
    NthTail = proplists:get_value(sf_nth_tail, Options, 0),
    Module = lists:concat([parse_trans:get_module(AST), ".erl"]),
    case proplists:get_value(sf_type, Options) of
        basename ->
            lists:map(
                fun({attribute, Line, file, {Filename, _Line}} = Form) ->
                    case filename:basename(Filename) == Module of
                        true ->
                            {attribute, Line, file, {Module, Line}};
                        _ -> Form
                    end;
                    (Form) -> Form
                end, AST);
        _ ->
            PrefixFilename =
                case proplists:get_value(sf_prefix, Options, cwd) of
                    cwd ->
                        {ok, Cwd} = file:get_cwd(),
                        Cwd;
                    PrefixFilenameTemp ->
                        PrefixFilenameTemp
                end,
            lists:map(
                fun({attribute, Line, file, {Filename, _Line}} = Form) ->
                    case filename:basename(Filename) =:= Module andalso
                        filename:pathtype(Filename) =:= absolute andalso
                        lists:prefix(PrefixFilename, Filename) of
                        true ->
                            NewFilename = rename_filename(PrefixFilename, Filename, NthTail),
                            {attribute, Line, file, {NewFilename, Line}};
                        _ -> Form
                    end;
                    (Form) -> Form
                end, AST)
    end.

%%====================================================================
%% Internal functions
%%====================================================================
rename_filename(PrefixFilename, Filename, NthTail) ->
    List = filename:split(Filename) -- filename:split(PrefixFilename),
    filename:join(lists:nthtail(NthTail, List)).
