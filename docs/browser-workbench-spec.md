# MoonSheet 浏览器工作台规格

| 项目 | 内容 |
|---|---|
| 状态 | Approved for Milestone 0 |
| MVP 设备 | 桌面浏览器，最小宽度 1024 px |

## 页面结构

```text
┌ Top bar: 示例 / 导入 JSON / 导出 / 全量重算 / 状态 ┐
├ Formula bar: 地址 | 原始值或公式 | 应用/取消            ┤
├ Sheet tabs                                            ┤
├ Grid                         ┬ Inspector               ┤
│ 单元格网格                  │ 结果 / 解释 / 依赖 / 错误 │
└ Status bar: 计算耗时、重算数、工作簿版本              ┘
```

## 核心交互

### 首次进入

1. 自动打开预算表示例。
2. 展示三步轻引导：选择利润率、修改收入、查看重算与错误。
3. 顶栏明确显示“所有计算在本地完成”。

### 编辑单元格

1. 单击选择；双击或聚焦公式栏进入编辑。
2. `Enter` 应用，`Escape` 取消。
3. 解析成功后更新依赖图并增量重算。
4. 解析失败时，用户输入只保存在 UI 编辑草稿中；工作簿继续使用上次有效 source 和结果。修正并应用成功后，草稿才提交到 Core。
5. 本次重算单元格短暂高亮；状态栏显示数量和耗时。

### 查看解释

- 默认显示选中单元格的值、原始公式和代入过程。
- “依赖”页签区分直接上游、直接下游和完整影响范围。
- “错误”页签显示主根因、默认路径和其他根因数量。
- 点击路径中的地址，网格滚动并选中对应单元格。

## 页面状态

| 状态 | 必须行为 |
|---|---|
| Initializing | 显示初始化进度，不展示可编辑假网格 |
| Ready | 网格与检查器可操作 |
| Calculating | 保持浏览，禁用冲突编辑，显示耗时 |
| Parse error | 保留输入、定位字符范围、允许修正 |
| Workbook error | 显示文件级诊断，不进入部分工作簿 |
| Resource limit | 解释超限项和当前限制 |
| Internal error | 提供可复制诊断，不泄露工作簿内容 |
| Empty | 提供打开示例或导入 JSON |

## 浏览器架构

```text
UI State / Components
        ↓ typed commands and view models
MoonSheet Browser Adapter
        ↓ serialized boundary
MoonBit Core Engine
```

- UI 不自行计算公式或依赖。
- UI 编辑草稿与 Core 中已提交的工作簿状态严格分离。
- Core 返回适合 UI 的稳定 ViewModel；UI 不读取内部 AST。
- 浏览器适配层只暴露 `openWorkbook(json)`、`commitCell(address, source)`、`selectCell(address)`、`exportWorkbook()` 四类命令。
- 每次 Core 响应包含 `content_version` 与 `calculation_version`；UI 丢弃早于当前内容版本的响应，避免异步响应覆盖新状态。
- Milestone 0 默认采用 MoonBit JS 后端 + TypeScript/JavaScript 薄 UI。
- Wasm 后端只有在探针中满足同等正确性、调试体验和性能后才替代 JS 后端。
- MVP 使用虚拟化 DOM 网格；Canvas 不作为首选，因为可访问性和交互开发成本较高。

## 可访问性与键盘

- 网格使用可识别的行列语义与焦点状态。
- 所有核心任务可通过键盘完成。
- 错误不能只通过颜色表达。
- 依赖高亮提供图例，颜色满足对比度要求。

## 隐私

- MVP 不发送工作簿内容到网络。
- 不使用远程分析脚本记录单元格内容。
- 导入文件只在当前浏览器会话内处理；刷新后的持久化不属于 MVP。
