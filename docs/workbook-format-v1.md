# MoonSheet 工作簿 JSON v1

| 项目 | 内容 |
|---|---|
| 状态 | Approved for Milestone 0 |
| 格式标识 | `moonsheet.workbook` |
| 格式版本 | `1` |

## 设计原则

- JSON v1 是 MVP 唯一权威交换格式。
- 文件只保存用户输入，不保存可重新生成的 AST、依赖图、计算结果或诊断。
- 未知字段默认拒绝，避免拼写错误被静默忽略。
- 字段顺序不影响语义；导出时使用稳定顺序。

## 顶层结构

```json
{
  "format": "moonsheet.workbook",
  "version": 1,
  "locale": "zh-CN",
  "sheets": [
    {
      "name": "Budget",
      "cells": {
        "A1": { "value": "Revenue" },
        "B1": { "value": 1000 },
        "A2": { "value": "Cost" },
        "B2": { "value": 600 },
        "B3": { "formula": "=B1-B2" }
      }
    }
  ]
}
```

## 字段规则

| JSON 路径 | 类型 | 必须 | 规则 |
|---|---|---:|---|
| `format` | String | 是 | 必须等于 `moonsheet.workbook` |
| `version` | Integer | 是 | MVP 只接受 `1` |
| `locale` | String | 否 | 默认 `zh-CN`；只影响展示，不影响公式语法 |
| `sheets` | Array | 是 | 至少 1 个；顺序决定稳定排序 |
| `sheets[].name` | String | 是 | 非空、唯一、最长 100 字符 |
| `sheets[].cells` | Object | 是 | key 是规范 A1 地址 |
| `cells.*.value` | JSON scalar | 二选一 | String、有限 Number 或 Boolean |
| `cells.*.formula` | String | 二选一 | 必须以 `=` 开头 |

每个单元格必须且只能包含 `value` 或 `formula`。不存在的地址等价于 Blank。清空单元格时删除该地址；JSON v1 不保存显式 Blank。

工作簿文件不保存错误值。公式字符串使用 `formula-semantics.md` 规定的固定语法，`locale` 不改变小数点、函数名或参数分隔符。

## 版本规则

- 不支持的高版本返回 `FORMAT_ERROR`，不尝试猜测兼容。
- 同一主版本内，读取器不得改变已有字段语义。
- 未来迁移必须显式生成新文件，不原地静默修改用户输入。

## 验证顺序

1. JSON 语法。
2. 顶层格式与版本。
3. 资源上限。
4. 工作表名称唯一性。
5. 地址规范性。
6. 单元格字段互斥。
7. 公式解析并记录单元格诊断；单个公式解析失败不拒绝整个工作簿。
8. 依赖和计算。

失败报告必须包含 JSON Pointer，例如 `/sheets/0/cells/B3/formula`。

只有无法建立工作簿模型的文件级错误会拒绝加载。公式解析错误保留原始公式文本并产生单元格 `PARSE_ERROR`；无关区域仍可计算和导出。

## 稳定导出

- 顶层字段顺序：`format, version, locale, sheets`。
- 工作表保持用户顺序。
- 单元格按行号、列号排序。
- 单元格地址规范化为大写；公式文本按最后一次成功提交的原文保存，不重排空白或改写函数名。
- 不导出空单元格、AST、缓存值、诊断或 UI 状态。
