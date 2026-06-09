# MoonSheet 公式与地址语义

| 项目 | 内容 |
|---|---|
| 状态 | Approved for Milestone 0 |
| 语义版本 | `moonsheet-formula/1` |

## 地址模型

MoonSheet 使用 A1 地址制。

- 行号从 `1` 开始，最大 `1,048,576`。
- 列号内部使用从 `1` 开始的整数，文本编码为 `A..Z, AA..ZZ, AAA...`，最大 `XFD`，即 `16,384`。
- 地址大小写不敏感，序列化时统一输出大写。
- `A1`：相对列、相对行。
- `$A$1`：绝对列、绝对行。
- `$A1`：绝对列、相对行。
- `A$1`：相对列、绝对行。
- 跨表引用：`Sheet2!A1`。
- 含空格或特殊字符的表名：`'Sales 2026'!A1`；单引号使用两个单引号转义。
- 工作表名称大小写敏感，必须唯一。

绝对/相对标记在 MVP 中被解析和保留，用于未来复制公式；当前编辑单个公式时不自动移动引用。

跨表范围可以写为 `Sheet2!A1:B3`，右端未写工作表时继承左端工作表。若两端显式工作表不同，则返回 `UNSUPPORTED_FEATURE`。

引用不存在的单元格是有效引用，其值为 Blank。引用不存在的工作表、越界行列或非法地址返回 `INVALID_REFERENCE`。

## 词法与语法

- 公式必须以 `=` 开头；`=` 不属于 AST 的源码范围。
- 标识符和函数名大小写不敏感，规范化为大写。
- 函数参数分隔符固定为英文逗号 `,`，不随 locale 改变。
- 数字使用 `.` 作为小数点；MVP 不支持千位分隔、百分号或科学计数法。
- 文本字面量使用双引号；内部双引号写成两个双引号，例如 `"say ""hi"""`。
- 空白字符可出现在 token 之间，不可拆分地址、数字或运算符。
- 未加引号的工作表名必须匹配 `[A-Za-z_][A-Za-z0-9_]*`；其他名称必须使用单引号形式。

```ebnf
formula      = "=", expression ;
expression   = comparison ;
comparison   = additive, [ ("=" | "<>" | "<" | "<=" | ">" | ">="), additive ] ;
additive     = multiplicative, { ("+" | "-"), multiplicative } ;
multiplicative = unary, { ("*" | "/"), unary } ;
unary        = [ "-" ], primary ;
primary      = number | string | boolean | reference | range
             | function_call | "(", expression, ")" ;
range        = reference, ":", reference ;
function_call = identifier, "(", [ expression, { ",", expression } ], ")" ;
reference    = [ sheet_name, "!" ], [ "$" ], column, [ "$" ], row ;
```

Parser 必须识别语法有效但 MVP 不支持的能力，并优先返回 `UNSUPPORTED_FEATURE`，而不是笼统的 `PARSE_ERROR`。

链式比较，例如 `A1<B1<C1`，返回 `PARSE_ERROR`。聚合函数要求 `1..1024` 个参数；`IF` 必须恰好 3 个参数；其他参数数量返回 `ARGUMENT_ERROR`。

源码范围使用公式字符串中的 UTF-8 字节半开区间 `[start, end)`，并额外提供从 `1` 开始的 Unicode 字符列号，供 CLI 与浏览器准确高亮。

## 范围语义

- `A1:B3` 表示包含边界的矩形范围。
- 起止地址允许反向书写；规范化后取最小/最大行列。
- 范围必须位于同一工作表；跨工作表三维范围不支持。
- 范围按**先行后列**展开：`A1, B1, A2, B2, A3, B3`。
- 依赖图中，范围依赖展开为每个非越界单元格的依赖边。
- 超过资源上限的范围返回 `RESOURCE_LIMIT`，不得部分展开。

## 值类型与空白

| 类型 | 示例 | 规则 |
|---|---|---|
| Number | `12.5` | MVP 使用 IEEE-754 双精度语义；计算结果必须有限 |
| Text | `"hello"` | 仅字符串字面量与 JSON 文本单元格 |
| Boolean | `TRUE`, `FALSE` | 大小写不敏感 |
| Blank | 空单元格 | 与数字 `0`、文本 `""` 不同 |
| Error | `#DIV/0!` 等 | 结构化错误值 |

标量算术中的空白按 `0` 处理；比较中的空白保持独立类型。聚合函数忽略范围中的空白和文本，但直接传入的非数字标量参数产生 `TYPE_ERROR`。

错误值只由引擎产生，MVP 公式和 JSON 输入不能直接创建 Error。

## 运算符

优先级从高到低：

1. 括号
2. 一元 `-`
3. `* /`
4. `+ -`
5. `= <> < <= > >=`

二元算术只接受数字或可按标量空白规则转换的值。MVP 不做文本到数字的隐式转换。产生 NaN 或 Infinity 的运算返回 `NUMERIC_ERROR`。

比较要求两侧类型相同：

- Number 按数值比较。
- Text 按 Unicode 标量值的字典序比较，不受 locale 影响。
- Boolean 顺序为 `FALSE < TRUE`。
- Blank 只支持 `=` 和 `<>`；排序比较返回 `TYPE_ERROR`。

## 函数语义

| 函数 | 语义 |
|---|---|
| `SUM(args...)` | 对数字求和；范围中的 Blank/Text 忽略 |
| `AVERAGE(args...)` | 数字总和除以数字数量；无数字时返回 `#DIV/0!` |
| `MIN(args...)` / `MAX(args...)` | 取数字极值；无数字时返回 `#VALUE!` |
| `COUNT(args...)` | 返回数字值数量 |
| `IF(condition, when_true, when_false)` | condition 必须为 Boolean；只计算被选中的分支 |

`IF` 是 AST 中的专用节点或专用求值分支。未选中的分支不产生值错误，但其中的静态引用仍进入依赖图，确保分支条件变化后能正确重算。

解析错误、不支持功能、无效引用和循环引用属于结构错误，不受 `IF` 短路影响；除零、类型、参数和数值错误属于运行时错误，未选中分支中的运行时错误不传播。

## 错误传播

- 解析错误阻止该公式求值。
- 普通运算遇到任一错误参数时传播根错误。
- 聚合函数遇到范围内错误时传播错误，不忽略错误。
- `IF` 只传播条件和被选中分支的运行时错误。
- 多个上游错误按 [diagnostics-spec.md](diagnostics-spec.md) 的稳定排序选出主错误，其余保留为附加根因。

## 易变与副作用

MVP 公式语言是确定性的、无副作用的。`RAND`、`NOW`、网络访问、自定义脚本和外部工作簿引用均返回 `UNSUPPORTED_FEATURE`。
