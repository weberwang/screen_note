# App Shell Prototype Playback

## Page Structure Playback

### 1. Shared Shell Frame

- 底部固定三栏导航：`Home / History / Settings`
- `Home` 为默认落点
- 全局快速添加是独立悬浮动作，不与底栏导航混用

### 2. Home Primary Region

- 首屏顶部是轻量问候 / 状态摘要区
- 中间是一个绝对主导的主事项卡片
- 主卡片只承载一件当前最重要事项，不与次级队列争抢层级
- 主卡片允许轻微温和纸感，但不包含叶片、插画、胶带、卷角或强便签道具

### 3. Home Secondary Region

- 主卡片下方是紧急事项队列
- 队列保持行式结构与轻分隔
- 队列承担快速扫读，不承担复杂管理

### 4. Shared Navigation And Launch Host

- 壳层负责承接系统回流
- 若系统入口分发失败，回退到 `Home`，不阻断壳层渲染

## Interaction Checklist

- 点击底栏 `Home / History / Settings` 可切换三大一级目的地
- 点击全局快速添加可打开快速添加入口
- 点击主事项卡片可进入事项详情 / 编辑主链路
- 点击紧急事项行可进入对应事项详情
- `Home` 为默认启动页
- 系统深链 / 回流需能命中对应目的地，失败时安全回退到 `Home`
- 权限拒绝、刷新失败等全局反馈不能遮挡首要任务区

## Freeze Intent

- 本次原型只验证 `app-shell` 的共享结构、共享导航、主事项层级和快速添加关系
- 不展开 `task-flow`、`history-center`、`settings-center` 的模块内最终细节
- 后续模块原型与模块冻结都必须继承这里确认的壳层结构
