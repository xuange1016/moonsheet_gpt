# MoonSheet MVP 验收追踪矩阵

| 需求 | 规格依据 | 自动化证据 | 产品证据 | 完成状态 |
|---|---|---|---|---|
| R1 工作簿 | `workbook-format-v1.md` | JSON 正反例、稳定导出 | 导入/导出演示 | Not Implemented |
| R2 地址与公式 | `formula-semantics.md` | Lexer/Parser/地址边界测试 | 公式栏错误定位 | Not Implemented |
| R3 计算 | `formula-semantics.md` | 参考差异测试 | 预算表结果 | Not Implemented |
| R4 依赖 | `moonsheet-technical-design.md` | 图边与遍历测试 | 依赖检查器 | Not Implemented |
| R5 增量重算 | `moonsheet-technical-design.md` | 增量/全量差异测试 | 重算高亮与耗时 | Not Implemented |
| R6 循环诊断 | `diagnostics-spec.md` | 循环路径快照 | 循环案例 | Not Implemented |
| R7 错误传播 | `diagnostics-spec.md` | 多根因排序测试 | 根因与路径交互 | Not Implemented |
| R8 公式解释 | `diagnostics-spec.md` | 解释模板快照 | 解释面板任务测试 | Not Implemented |
| R9 浏览器工作台 | `browser-workbench-spec.md` | 浏览器端到端测试 | 5 人核心任务测试 | Not Implemented |
| R10 CLI / 库 | `cli-and-library-contract.md` | 契约、退出码与快照测试 | CLI 演示 | Not Implemented |
| R11 示例 | `moonsheet-product-requirements.md` | 示例回归测试 | 三个演示故事 | Not Implemented |

## 状态规则

- `Not Implemented`：只有规格，没有代码。
- `In Progress`：已有实现，但验收证据不完整。
- `Verified`：自动化证据和要求的产品证据均存在。
- `Blocked`：存在明确阻断项，并链接到决策记录。

状态不得根据代码提交数量或主观完成度修改。
