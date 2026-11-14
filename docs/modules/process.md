# process — 进程控制

```ayanami
import "process";
```

| API | 说明 |
|---|---|
| `process::exit(int code) -> !` | 立即退出进程（`code` 作为退出码；不返回） |
| `process::exit_ok() -> !` | 正常退出（退出码 0） |
| `process::id() -> int` | 当前进程 ID（`getpid`） |
| `process::parent_id() -> int` | 父进程 ID（`getppid`） |
| `process::run(String command) -> int` | 通过 `/bin/sh -c` 执行命令；返回退出码 / `128+sig` / `-1` |
| `process::output(String command) -> Option[String]` | 执行命令并捕获 stdout（失败 → None） |

- 运行时：C 后端 `exit()` / `getpid` / `getppid` / `system()` / `popen()`；汇编后端 `exit_group` / `getpid` / `getppid` / `fork`+`execve`+`wait4`、`pipe`+`dup2`+`read` 系统调用 ✓；
- 命令行参数见 `env::arg_count` / `env::arg`（`docs/modules/env.md`）。

```ayanami
if bad_input {
    process::exit(2)
}
```

```ayanami
out = process::output("printf abc").unwrap()
println(out)               // abc
code = process::run("exit 7")
println(code)              // 7
```
