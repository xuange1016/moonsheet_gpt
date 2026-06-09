# MoonSheet 规格评审矩阵

| # | 评审问题 | 决策状态 | 事实源 |
|---:|---|---|---|
| 0 | 当前目录无源码却被误认为可编译项目 | Resolved | `README.md`、`repository-bootstrap.md` |
| 1 | 范围、空白与 IF 语义不闭环 | Resolved | `formula-semantics.md` |
| 2 | 地址模型悬空 | Resolved | `formula-semantics.md` |
| 3 | 增量重算的变化定义缺失 | Resolved | `moonsheet-technical-design.md` |
| 4 | 多上游错误冲突未定义 | Resolved | `diagnostics-spec.md` |
| 5 | 浏览器工作台零设计 | Resolved | `browser-workbench-spec.md` |
| 6 | CLI 接口未设计 | Resolved | `cli-and-library-contract.md` |
| 7 | JSON 工作簿格式未定义 | Resolved | `workbook-format-v1.md` |
| 8 | XLSX 决策条件缺失 | Resolved | `moonsheet-technical-design.md` |
| 9 | 性能目标模糊 | Resolved | `moonsheet-test-plan.md` |
| 10 | 术语策略无落地 | Resolved | `diagnostics-spec.md` |
| 11 | 新仓库与命名状态矛盾 | Resolved | `moonsheet-implementation-plan.md` |

## 仍需用代码验证的事项

这些不是规格歧义，而是 Milestone 0 必须提供证据的技术风险：

- MoonBit Parser 与源码范围实现是否顺畅。
- 大依赖图的内存与性能是否达到门槛。
- MoonBit JS 后端与浏览器适配层是否稳定。
- Wasm 是否值得进入增强版。

## 文档审查规则

- 新问题必须记录到本矩阵，指定事实源和状态。
- `Resolved` 表示规格已经明确，不表示代码已经实现。
- `Verified` 只能在自动化测试或用户验证证据存在后使用。
