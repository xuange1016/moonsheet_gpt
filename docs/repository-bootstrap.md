# MoonSheet 新仓库启动规格

| 项目 | 内容 |
|---|---|
| 状态 | In Progress |

## 新仓库身份

| 项目 | 固定值 |
|---|---|
| 本地文件夹 | `moonsheet` |
| GitHub 仓库名 | `xuange1016/moonsheet_gpt` |
| MoonBit 模块名 | `moonsheet/moonsheet` |
| 默认分支 | `main` |
| 许可证 | MIT |

## 仓库位置决策

规格暂存目录本身已位于目标路径 `E:\Codex_project\moonsheet`，因此直接将当前目录初始化为正式仓库，不再创建嵌套目录或迁移文件。云端比赛申报仓库使用已有公开仓库 `xuange1016/moonsheet_gpt`。仓库只包含 MoonSheet 文档、源码、测试、示例和必要工程配置，不纳入构建产物或本地缓存。

## 首个可编译基线

仓库初始化后的首个功能提交必须包含：

- `moon.mod.json`
- 至少一个最小 MoonBit 包及 `moon.pkg.json`
- `moon check` 和 `moon test` 可运行
- 基础 CI
- README 明确当前只完成项目骨架

文档迁移不单独伪装成功能实现；状态从“规格暂存”改为“Milestone 0”必须与可运行探针同时发生。

## 仓库健康检查

```text
目录、GitHub 仓库、模块名统一
无无关 Git 历史和构建产物
moon check 通过
moon test 通过
文档链接检查通过
CI 在公开仓库通过
```
