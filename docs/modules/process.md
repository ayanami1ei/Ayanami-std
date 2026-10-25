# process — 进程控制

```ayanami
import "process";
```

| API | 说明 |
|---|---|
| `process::exit(int code) -> !` | 立即退出进程（`code` 作为退出码；不返回） |
| `process::exit_ok() -> !` | 正常退出（退出码 0） |

- 运行时：C 后端 `exit()`；汇编后端 `exit_group` 系统调用 ✓；
- 命令行参数见 `env::arg_count` / `env::arg`（`docs/modules/env.md`）。

```ayanami
if bad_input {
    process::exit(2)
}
```
