# History Center Prototype Playback

## Page Structure Playback

### 1. Shared Shell Layer

- 页面继承已冻结的 `app-shell` 共享壳层：底部 `Home / History / Settings` 三栏导航与独立全局快速添加入口仍然存在。
- `History` 是当前选中目的地，但视觉优先级必须低于页面内容本身，不制造额外导航噪音。

### 2. Completed Section

- 页面第一主区块是最近完成事项分区。
- 该分区以信任恢复为目标，强调“事项已经完成且仍可追溯”，而不是强调操作面板。
- 单条完成事项保持行式结构，展示标题与完成时间线索，默认只读。

### 3. Deleted Section

- 第二主区块是最近删除事项分区。
- 该分区是当前页面的主交互区，因为恢复动作只发生在这里。
- 单条已删除事项保持行式结构，并在右侧保留清楚但克制的 `Restore` 动作。

### 4. Empty And Trust States

- 当最近完成和最近删除都为空时，页面应展示“事项没有无故消失”的轻量空态说明。
- 页面层级必须优先传达可追溯和可恢复，而不是分析统计或成就感。

## Interaction Checklist

- 点击底栏 `Home / History / Settings` 仍可切换一级目的地。
- 最近完成事项默认只读，不在当前模块原型里承接二级操作。
- 最近删除事项支持恢复动作，恢复后应明确反馈“已恢复到 active”。
- 全局快速添加继续可用，但不能抢走历史中心的主注意力。
- 页面应支持空态、恢复成功态和分区加载态的稳定结构表达。

## Please confirm before high-fidelity prototype build

- 当前播放稿覆盖 `history-center` 的单一页面族：`history_center`。
- 下一步将以 `history-center-history.png` 为视觉基线，生成模块 HTML 高保真原型和冻结包。
