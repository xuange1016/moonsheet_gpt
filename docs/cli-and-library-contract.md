# MoonSheet CLI 与库接口契约

| 项目 | 内容 |
|---|---|
| 状态 | Approved for Milestone 0 |

## CLI 命令

```text
moonsheet validate <workbook.json> [--json]
moonsheet calculate <workbook.json> [--cell <Sheet!A1>] [--json]
moonsheet explain <workbook.json> <Sheet!A1> [--lang zh-CN|en-US] [--json]
moonsheet benchmark <fixture> [--json]
```

## 命令行为

| 命令 | 成功输出 | 失败行为 |
|---|---|---|
| `validate` | 文件、公式和依赖图有效摘要 | 输出所有可安全收集的诊断 |
| `calculate` | 全部非空结果，或指定单元格结果 | 文件级格式或资源错误时不输出部分结果；单元格解析、循环或普通计算错误时输出其他可计算结果并返回退出码 `1` |
| `explain` | 值、公式步骤、依赖和诊断 | 地址不存在时返回明确错误 |
| `benchmark` | 数据集、耗时、重算数量和环境 | 不作为普通用户命令承诺 |

默认人类可读输出写入 stdout；诊断写入 stderr。`--json` 时 stdout 只输出一个结构化 JSON 对象，stderr 只保留进程级异常。

“工作簿无效”指阻止建立工作簿模型的文件格式或资源上限错误。公式解析、循环、除零、类型和依赖错误属于可计算工作簿中的单元格诊断；无关区域继续计算。

## 退出码

| 退出码 | 含义 |
|---:|---|
| `0` | 命令成功，工作簿无错误 |
| `1` | 工作簿可读取，但存在公式或计算诊断 |
| `2` | CLI 参数错误 |
| `3` | 文件不存在、不可读或 JSON 格式错误 |
| `4` | 不支持的格式版本或功能 |
| `5` | 资源上限 |
| `10` | MoonSheet 内部错误 |

## JSON 输出信封

```json
{
  "schema": "moonsheet.cli/1",
  "command": "calculate",
  "ok": false,
  "workbook": "budget.json",
  "result": null,
  "diagnostics": []
}
```

字段必须稳定；新增字段只能是向后兼容的可选字段。

## MoonBit 库边界

```text
Engine::load_workbook_json(text) -> Result[Engine, FormatDiagnostics]
engine.validate() -> ValidationResult
engine.calculate_all() -> CalculationResult
engine.update_cell(address, source) -> UpdateResult
engine.explain_cell(address, locale) -> Explanation
engine.export_workbook_json() -> String
```

`Engine` 拥有工作簿、依赖图、计算缓存和版本状态。修改操作原地更新 `Engine`，结果对象只描述本次操作的值、诊断、版本、重算集合和耗时，不复制完整引擎状态。

公共接口只暴露领域类型，不暴露 UI、文件系统或 CLI 类型。调用方负责读取文件；核心库接收文本和结构化输入。

## 兼容规则

- CLI 命令和 JSON 信封版本独立于工作簿版本。
- 破坏性 CLI 变更必须提升 `moonsheet.cli` 主版本。
- `--json` 输出必须进入快照测试。
