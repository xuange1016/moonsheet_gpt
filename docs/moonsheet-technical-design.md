# MoonSheet 技术设计

| 项目 | 内容 |
|---|---|
| 状态 | Approved for Milestone 0 |
| 最后更新 | 2026-06-09 |

## 系统边界

MoonSheet Core 是确定性的、无副作用的表格计算库。CLI 和浏览器都是适配层，不拥有公式语义。

```text
JSON v1 / CLI / Browser
        ↓
Workbook Loader + Validator
        ↓
Formula Lexer + Parser + Typed AST
        ↓
Dependency Graph + Cycle Detector
        ↓
Recalculation Planner + Evaluator
        ↓
Diagnostics + Explain Trace + ViewModel
```

## 权威规格

| 领域 | 唯一事实源 |
|---|---|
| 产品行为 | [moonsheet-product-requirements.md](moonsheet-product-requirements.md) |
| 地址、范围、值、函数 | [formula-semantics.md](formula-semantics.md) |
| 错误排序与解释 | [diagnostics-spec.md](diagnostics-spec.md) |
| 文件格式 | [workbook-format-v1.md](workbook-format-v1.md) |
| CLI 与库接口 | [cli-and-library-contract.md](cli-and-library-contract.md) |
| 浏览器交互 | [browser-workbench-spec.md](browser-workbench-spec.md) |

## 核心数据模型

```text
Workbook
  sheets: Array[Sheet]
  semantic_version
  content_version
  calculation_version

Sheet
  id
  name
  cells: Map[CellAddress, Cell]

Cell
  source: Blank | Literal | FormulaText
  parsed: FormulaAst?
  value: Value
  diagnostic_ids[]
  last_calculated_version

CellAddress
  sheet_id
  row: UInt
  column: UInt

Reference
  address
  row_absolute
  column_absolute

RangeReference
  start: Reference
  end: Reference
```

`semantic_version` 固定标识公式语义，例如 `moonsheet-formula/1`。`content_version` 在每次成功提交且 source 变化后递增。`calculation_version` 在首次成功计算和每次实际发生重算后递增。UI 解析草稿、无变化编辑和失败加载不递增任何版本。

## 依赖图

- 正向边：公式单元格指向它读取的单元格，用于解释上游。
- 反向边：输入单元格指向依赖它的公式，用于脏传播。
- `IF` 的两个分支都建立静态依赖；运行时轨迹只记录实际求值分支。
- 使用稳定工作表顺序和地址顺序遍历。
- 循环检测采用强连通分量；自引用也是循环。
- 语法有效但形成循环的编辑允许提交：循环内单元格得到 `CIRCULAR_REFERENCE`，依赖它们的下游得到 `DEPENDENCY_ERROR`，无关区域继续计算。

## 变化与增量重算

一次编辑先规范化为 `CellSource`，再与旧 source 比较：

| 情况 | 是否变化 | 动作 |
|---|---:|---|
| 规范化后的 source 完全相同 | 否 | 不提升版本，不重算 |
| Literal 输入不同但规范化值相同，例如 `1` 到 `1.0` | 否 | 不修改工作簿，不重算 |
| 公式文本格式不同但规范化计算 AST 相同 | 内容变化，计算语义不变 | 保存新文本并提升 content_version，不重算 |
| 仅引用绝对/相对标记改变 | 内容变化，当前计算语义不变 | 保存新文本并提升 content_version，不重算 |
| 公式 AST 或引用集合改变 | 是 | 更新图并重算受影响并集 |
| 上游值或诊断改变 | 是 | 传播到下游 |
| 上游被重算但值与诊断未变 | 否 | 停止继续传播 |

规范化与语义等价规则：

- 持久化 AST 保留引用绝对标记；用于重算判定的规范化计算 AST 忽略 token 间空白、函数名大小写和引用绝对标记，但保留运算顺序、工作表、文本大小写和函数参数顺序。
- Number 规范化 `-0` 为 `0`，使用有限 IEEE-754 数值相等；Text 按精确 Unicode 内容比较；Boolean、Blank 按类型和值比较。
- 诊断等价比较错误码、severity、cell、源码范围、根因和路径；忽略诊断实例 id、语言和展示文案。
- 只要值或诊断不等价，就继续传播；不得仅根据显示字符串判断。

重算过程：

1. 解析编辑，得到新 source、AST 和引用集合。
2. 计算旧下游与新下游的受影响并集。
3. 更新依赖图并检测相关循环。
4. 按稳定拓扑顺序求值。
5. 仅当值或诊断发生语义变化时继续向下传播。
6. 记录 `content_version`、`calculation_version`、重算地址和耗时。

无效编辑只存在于浏览器 UI 草稿中，不调用 `update_cell`，因此不会改变工作簿、依赖图或计算版本。

MVP 没有易变函数，因此不存在无编辑自动重算。

## 诊断与解释

- 解析、图、求值和格式层产生结构化诊断。
- `DEPENDENCY_ERROR` 不取代根错误，而是引用根错误。
- 下游单元格的错误值使用主根错误对应的显示值；该单元格诊断使用 `DEPENDENCY_ERROR`，并通过根因与路径指回原始诊断。
- 解释轨迹只记录选中单元格或诊断需要的步骤，避免为整个工作簿保存巨量轨迹。
- 稳定排序和多根因处理遵循诊断规格。

## 浏览器方案决策

MVP 基线已锁定为：

- MoonBit JS 后端运行核心。
- 薄 JavaScript/TypeScript 浏览器适配层。
- 虚拟化 DOM 网格。
- Core 通过字符串 JSON 或窄结构化接口与 UI 交换。

Wasm 是竞争增强项，不是 MVP 阻断项。Milestone 0 会验证 Wasm 调用，但只有满足以下全部条件才采用：

- 与 JS 后端结果 100% 一致。
- 50,000 单元格基准至少快 20% 或内存至少低 20%。
- 调试与构建复杂度不会威胁 2026-07-05 浏览器 MVP 截止时间。

## XLSX 决策

XLSX 不进入 MVP。只有同时满足以下条件，才进入比赛增强版：

- 可复用库能稳定读取单元格值、公式和工作表名称。
- 在 20 个真实匿名化样例中导入成功率至少 90%。
- 公式原文可保留，未知功能会明确诊断。
- 实现与维护预算不超过 3 个开发日。

Plan B：提供 CSV 值导入和 MoonSheet JSON；答辩明确说明 XLSX 属于兼容适配层，不是核心创新。

## 资源上限

| 资源 | 默认上限 | 行为 |
|---|---:|---|
| 工作表 | 64 | 拒绝加载 |
| 非空单元格 | 200,000 | 拒绝加载 |
| 单公式长度 | 8,192 字符 | 单元格诊断 |
| AST 深度 | 256 | 单元格诊断 |
| 单范围展开 | 100,000 单元格 | 单元格诊断 |
| 总依赖边 | 2,000,000 | 拒绝计算 |
| 单次解释路径 | 1,000 节点 | 明确截断并标记 |

## 新仓库结构

```text
moonsheet/
├─ formula/
├─ workbook/
├─ graph/
├─ evaluator/
├─ diagnostics/
├─ formats/json_v1/
├─ cmd/moonsheet/
├─ web/
├─ examples/
├─ tests/fixtures/
└─ docs/
```

新仓库根目录、GitHub 仓库名、MoonBit 包名统一使用 `moonsheet`；不迁移无关构建产物或 Git 历史。
