# MoonSheet 诊断与解释规格

| 项目 | 内容 |
|---|---|
| 状态 | Approved for Milestone 0 |

## 诊断结构

```text
Diagnostic
  id
  code
  severity
  cell
  source_span?
  primary_root?
  additional_roots[]
  primary_path[]
  related_paths[]
  message_key
  message_args
```

MVP severity 只有 `error` 和 `warning`。影响计算结果或阻止加载的诊断为 `error`；兼容性、截断展示和非阻断提示为 `warning`。源码范围遵循公式语义规格的 UTF-8 字节半开区间。

## 稳定排序

当一个单元格存在多个上游错误时：

1. 先按错误优先级排序：解析/不支持 > 循环 > 无效引用 > 参数/数值/除零 > 类型 > 依赖错误。
2. 优先选择传播边数最少的根因。
3. 再按工作表在工作簿中的顺序排序。
4. 再按单元格行号、列号排序。
5. 最后按错误码排序。

第一项作为 `primary_root` 和默认展示路径；其余进入 `additional_roots`，UI 必须提示“另有 N 个根因”。

循环路径从循环中地址排序最小的单元格开始，按依赖边稳定顺序输出，并以起始单元格结束。

## 错误码

| 错误码 | 用户显示 | 说明 |
|---|---|---|
| `PARSE_ERROR` | 公式写法有误（解析错误） | 包含源码范围 |
| `UNSUPPORTED_FEATURE` | 当前尚不支持此写法 | 不得降级计算 |
| `INVALID_REFERENCE` | 引用了不存在的位置 | 对应 `#REF!` |
| `TYPE_ERROR` | 值的类型不能用于此计算 | 对应 `#VALUE!` |
| `ARGUMENT_ERROR` | 函数参数数量不正确 | 包含期望和实际数量 |
| `NUMERIC_ERROR` | 数值结果超出支持范围 | 禁止产生 NaN/Infinity |
| `DIVIDE_BY_ZERO` | 除数不能为零 | 对应 `#DIV/0!` |
| `CIRCULAR_REFERENCE` | 公式互相依赖（循环引用） | 包含循环路径 |
| `DEPENDENCY_ERROR` | 上游单元格出错 | 包含根因与传播路径 |
| `RESOURCE_LIMIT` | 工作簿超过处理上限 | 不部分计算 |
| `FORMAT_ERROR` | 工作簿文件格式无效 | 包含 JSON 路径 |

## 解释层

解释信息分为三层：

1. **一句话结果**：`利润率无法计算，因为收入为 0。`
2. **代入过程**：`= B4 / B2 → 120 / 0 → #DIV/0!`
3. **专业详情**：错误码、源码范围、依赖路径、计算版本。

解释模板使用 `message_key + args`，中文和英文模板在构建时维护；运行时不翻译。

## 术语表

| 专业术语 | 首次展示文案 | 后续短文案 |
|---|---|---|
| Dependency | 这个结果使用的单元格（依赖） | 依赖 |
| Dependent | 会被这个单元格影响的结果（下游） | 下游 |
| Recalculation | 输入改变后重新计算相关结果（重算） | 重算 |
| Circular reference | 公式互相等待，形成闭环（循环引用） | 循环引用 |
| Root cause | 最早导致问题的单元格（根因） | 根因 |
| Error propagation | 一个错误继续影响后续结果（错误传播） | 错误传播 |

术语首次出现状态由浏览器会话管理；CLI 始终输出专业短文案，并可通过 `--explain` 输出完整解释。
