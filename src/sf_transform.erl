-module(sf_transform).

%% API exports
-export([parse_transform/2]).

%%====================================================================
%% API functions
%%====================================================================
parse_transform(AST, Options) ->
    PrefixFilename = proplists:get_value(sf_prefix, Options, cwd),
    NthTail = proplists:get_value(sf_nth_tail, Options, 0),
    lists:map(
        fun({attribute, Line, file, {Filename, _Line}}) ->
            NewFilename = rename_filename(PrefixFilename, Filename, NthTail),
            {attribute, Line, file, {NewFilename, Line}};
        (Form) -> Form
        end, AST).

%%====================================================================
%% Internal functions
%%====================================================================
rename_filename(cwd, Filename, NthTail) ->
    {ok, Cwd} = file:get_cwd(),
    rename_filename(Cwd, Filename, NthTail);
rename_filename(PrefixFilename, Filename, NthTail) ->
    List = filename:split(Filename) -- filename:split(PrefixFilename),
    filename:join(lists:nthtail(NthTail, List)).
