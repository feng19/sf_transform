sf_transform
=====

[中文说明](README_zh.md)

## 2022.07.07 update

Thanks @haoxian for remind，this lib `sf_transform` now is outdate.

The new solution is better, only add `deterministic` to `erl_opts` in `rebar.config` file:

```erlang
{erl_opts, [
  deterministic
]}.
```

or setting by env：

```shell
ERL_COMPILER_OPTIONS="[deterministic]" rebar3 compile
```

The description for `deterministic` in [erlang docs](https://www.erlang.org/doc/man/compile.html)：

> Omit the `options` and `source` tuples in the list returned by `Module:module_info(compile)`, and reduce the paths in stack traces to the module name alone. This option will make it easier to achieve reproducible builds.

## Introduction

If you use `rebar3` to build your code and you **hate** the error log's filename is very long and also not clear,like this:

```erlang
{file,"/home/xxx/work/erlang/test/tsf/src/tsf_sup.erl"}
```

in your shell:

```verilog
17:09:28.275 [error] CRASH REPORT Process <0.227.0> with 0 neighbours exited with reason: {{test,[{tsf_sup,init,1,[{file,"/home/xxx/work/erlang/test/tsf/src/tsf_sup.erl"},{line,35}]},{supervisor,init,1,[{file,"supervisor.erl"},{line,294}]},{gen_server,init_it,6,[{file,"gen_server.erl"},{line,328}]},{proc_lib,init_p_do_apply,3,[{file,"proc_lib.erl"},{line,247}]}]},{tsf_app,start,[normal,[]]}} in application_master:init/4 line 134
17:09:28.275 [info] Application tsf exited with reason: {{test,[{tsf_sup,init,1,[{file,"/home/xxx/work/erlang/test/tsf/src/tsf_sup.erl"},{line,35}]},{supervisor,init,1,[{file,"supervisor.erl"},{line,294}]},{gen_server,init_it,6,[{file,"gen_server.erl"},{line,328}]},{proc_lib,init_p_do_apply,3,[{file,"proc_lib.erl"},{line,247}]}]},{tsf_app,start,[normal,[]]}}

=INFO REPORT==== 2-Mar-2019::17:09:28 ===
    application: lager
    exited: stopped
    type: temporary
===> Failed to boot tsf for reason {{test,
                                                [{tsf_sup,init,1,
                                                  [{file,
                                                    "/home/xxx/work/erlang/test/tsf/src/tsf_sup.erl"},
                                                   {line,35}]},
                                                 {supervisor,init,1,
                                                  [{file,"supervisor.erl"},
                                                   {line,294}]},
                                                 {gen_server,init_it,6,
                                                  [{file,"gen_server.erl"},
                                                   {line,328}]},
                                                 {proc_lib,init_p_do_apply,3,
                                                  [{file,"proc_lib.erl"},
                                                   {line,247}]}]},
                                               {tsf_app,start,[normal,[]]}}
```

## Usage

Just add little setting config to your `rebar.config`:

```erlang
{overrides, [
    %% For all apps:
    {add, [
        {deps, [sf_transform]},
        {erl_opts, [{sf_type, basename}, {parse_transform, sf_transform}]}
    ]},
    %% Or for just one app:
    {del, parse_trans, [
        {deps, [sf_transform]},
        {erl_opts, [{sf_type, basename}, {parse_transform, sf_transform}]}
    ]},
    {del, sf_transform, [
        {deps, [sf_transform]},
        {erl_opts, [{sf_type, basename}, {parse_transform, sf_transform}]}
    ]}
]}.
```

Then your world become clear and better:

```verilog
17:16:39.427 [error] CRASH REPORT Process <0.535.0> with 0 neighbours exited with reason: test in tsf_sup:init/1 line 35 in gen_server:init_it/6 line 352
17:16:39.427 [error] CRASH REPORT Process <0.533.0> with 0 neighbours exited with reason: {{test,[{tsf_sup,init,1,[{file,"tsf_sup.erl"},{line,35}]},{supervisor,init,1,[{file,"supervisor.erl"},{line,294}]},{gen_server,init_it,6,[{file,"gen_server.erl"},{line,328}]},{proc_lib,init_p_do_apply,3,[{file,"proc_lib.erl"},{line,247}]}]},{tsf_app,start,[normal,[]]}} in application_master:init/4 line 134
17:16:39.427 [info] Application tsf exited with reason: {{test,[{tsf_sup,init,1,[{file,"tsf_sup.erl"},{line,35}]},{supervisor,init,1,[{file,"supervisor.erl"},{line,294}]},{gen_server,init_it,6,[{file,"gen_server.erl"},{line,328}]},{proc_lib,init_p_do_apply,3,[{file,"proc_lib.erl"},{line,247}]}]},{tsf_app,start,[normal,[]]}}


=INFO REPORT==== 2-Mar-2019::17:16:39 ===
    application: compiler
    exited: stopped
    type: temporary
===> Failed to boot tsf for reason {{test,
                                                [{tsf_sup,init,1,
                                                  [{file,"tsf_sup.erl"},
                                                   {line,35}]},
                                                 {supervisor,init,1,
                                                  [{file,"supervisor.erl"},
                                                   {line,294}]},
                                                 {gen_server,init_it,6,
                                                  [{file,"gen_server.erl"},
                                                   {line,328}]},
                                                 {proc_lib,init_p_do_apply,3,
                                                  [{file,"proc_lib.erl"},
                                                   {line,247}]}]},
                                               {tsf_app,start,[normal,[]]}}
```