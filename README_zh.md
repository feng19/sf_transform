sf_transform 使用指南
=====

如果你正在使用`rebar3`工具来工具你的项目和代码,有可能会很讨厌在`shell`窗口中的报错部分的文件名,像这样:

``` erlang
{file,"/home/xxx/work/erlang/test/tsf/src/tsf_sup.erl"}
```

可能你的`shell`窗口显示的是这样:

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

是的,**报错的文件名真的是太长了**,长到怀疑人生

这是因为`rebar3`的和`erl`的编译机制造成的,曾相关修改`rebar3`的编译部分,但是考虑到不一定全部人都会有这个需要,因此便通过元编程的方法,去除文件名的路径部分,只保留文件名

## 用法

只需要将以下部分代码增加到你的 `rebar.config`文件中:

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

然后,你的世界会变得更加清晰和美好:

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

## 问题

可能你有更好的解决方案,请联系我,谢谢.