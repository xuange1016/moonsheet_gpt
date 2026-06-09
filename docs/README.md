# MoonSheet 项目文档

| 项目 | 内容 |
|---|---|
| 状态 | Specification Review v2.0 |
| 当前阶段 | 正式仓库已初始化，准备执行 Milestone 0 |
| 最后更新 | 2026-06-09 |
| 目标 | 以一等奖标准建设 MoonBit 可解释电子表格计算引擎 |

## 一句话说明

MoonSheet 使用 MoonBit 计算电子表格公式、追踪单元格依赖，并把循环引用和错误传播路径解释给用户。

## 已确认方向

- 第一目标用户：需要检查复杂电子表格公式的数据分析人员、开发者与重度表格用户。
- 核心价值：让用户理解结果如何得出，并快速定位错误源与影响范围。
- MVP：公式解析与计算、依赖图、增量重算、循环引用、错误传播解释、CLI 与浏览器工作台。
- 比赛主演示：打开预算表，修改输入，立即看到局部重算；制造错误后，沿依赖链定位根因并修复。
- MoonBit 实现核心引擎；浏览器 UI 只承担交互与展示。

## 文档地图

| 文档 | 负责回答 | 状态 |
|---|---|---|
| [product-brief.md](product-brief.md) | 用户问题、产品价值与高风险假设 | In Review |
| [moonsheet-ecosystem-audit.md](moonsheet-ecosystem-audit.md) | 是否已有同类项目、如何持续查重 | Active |
| [moonsheet-product-requirements.md](moonsheet-product-requirements.md) | MVP 行为、范围和验收标准 | Approved for M0 |
| [formula-semantics.md](formula-semantics.md) | 地址、范围、值、运算与函数语义 | Approved for M0 |
| [diagnostics-spec.md](diagnostics-spec.md) | 错误排序、解释层与术语 | Approved for M0 |
| [workbook-format-v1.md](workbook-format-v1.md) | 权威 JSON v1 格式 | Approved for M0 |
| [cli-and-library-contract.md](cli-and-library-contract.md) | CLI、退出码与库接口 | Approved for M0 |
| [browser-workbench-spec.md](browser-workbench-spec.md) | 浏览器 UI、交互、状态和架构 | Approved for M0 |
| [moonsheet-technical-design.md](moonsheet-technical-design.md) | 计算模型、架构与技术边界 | Approved for M0 |
| [moonsheet-implementation-plan.md](moonsheet-implementation-plan.md) | 新仓库启动、交付顺序与门禁 | Approved |
| [repository-bootstrap.md](repository-bootstrap.md) | 新仓库身份、迁移边界与首个基线 | Ready |
| [first-stage-commit-plan.md](first-stage-commit-plan.md) | 第一阶段 16 个实质提交与验证证据 | Active |
| [milestone-0-probe-report.md](milestone-0-probe-report.md) | Milestone 0 探针证据与 Gate 1 剩余项 | Active |
| [moonsheet-test-plan.md](moonsheet-test-plan.md) | 正确性、性能与产品验证 | Approved |
| [spec-review-matrix.md](spec-review-matrix.md) | 规格问题关闭状态 | Active |
| [acceptance-traceability.md](acceptance-traceability.md) | R1-R11 的实现与验收证据 | Active |
| [competition-brief.md](competition-brief.md) | 比赛事实与申报约束 | Active |
| [decision-log.md](decision-log.md) | 关键决策与原因 | Active |
| [moonsheet-application-proposal.md](moonsheet-application-proposal.md) | 一页项目申报书草稿 | In Review |

## 当前事实

- 当前目录是正式 MoonSheet 仓库，尚无 MoonSheet 源代码或可编译包。
- Git 初始化完成后从 Milestone 0 技术探针开始正式开发。
- 本文档中的 `Approved for M0` 表示可用于技术探针，不表示能力已实现。

## 待技术验证问题

- MoonBit JS 后端与浏览器适配层是否稳定。
- 大依赖图能否达到量化性能门槛。
- Wasm 是否满足进入增强版的收益门槛。
