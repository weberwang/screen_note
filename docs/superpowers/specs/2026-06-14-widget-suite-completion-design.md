# Widget Suite Completion Spec

## 目标

在现有 `widget_bridge` 稳定快照链路基础上，补齐一套可验收的小组件能力闭环，覆盖：

- iOS 锁屏小组件继续可用并接入统一回流规则
- iOS 桌面小组件新增小尺寸与中尺寸
- Android 桌面小组件新增 1 个中等信息量尺寸
- Flutter、iOS、Android 统一消费同一份稳定快照合同

## 已确认范围

- iOS 锁屏小组件：保留现状，继续展示 1 条主事项
- iOS 桌面小组件：
  - 小尺寸展示 1 条主事项
  - 中尺寸展示 2 到 3 条事项
- Android 桌面小组件：
  - 先落 1 个尺寸
  - 展示 2 条事项
- 点击行为：
  - 点击具体事项条目时，优先进入对应事项落点
  - 无法精确命中条目时，降级回首页或主事项安全落点

## 成功标准

- `widget_bridge` 输出的共享快照可以同时支持锁屏与桌面小组件渲染
- iOS 锁屏、iOS 桌面、Android 桌面都不直接查询主应用数据库
- 小尺寸只展示 1 条事项，中尺寸展示 2 到 3 条事项的规则稳定可测
- 隐私模式与私密事项遮罩规则在所有小组件形态下保持一致
- 小组件点击回流统一由 Flutter 侧入口桥接解释，不在原生层分叉业务导航规则
- 现有 `widget_bridge` 自动同步链路保持可用
- Flutter 侧相关测试、分析与代码生成验证通过

## 非目标

- 不实现 iOS 大尺寸桌面小组件
- 不实现 Android 多尺寸小组件矩阵
- 不在小组件内加入完成、删除、恢复等交互按钮
- 不扩展为 Android 锁屏小组件或额外系统入口能力
- 不改造现有任务排序业务真源，只消费当前 `task_flow` 已定义的优先级结果

## 方案选择

### 方案 A：共享一份稳定快照合同，由平台仅负责渲染

Flutter 保持 `widget_bridge` 作为唯一事实出口，原生层只读取共享 JSON、按尺寸渲染并触发回流。

优点：

- 最符合当前项目“Widget 只读稳定快照”的边界约束
- iOS、Android 不会各自重做隐私规则与排序逻辑
- 后续继续扩尺寸或补平台时复用成本最低

缺点：

- 需要同时修改 Flutter 合同、iOS 扩展与 Android 小组件宿主

### 方案 B：保持当前快照不变，平台各自推导展示与点击逻辑

优点：

- Flutter 改动更少

缺点：

- 原生层会开始承载业务推导
- iOS 与 Android 行为容易漂移
- 与项目既定边界冲突

### 结论

采用方案 A。所有平台共享一份稳定快照合同，平台只负责展示和回流触发，不负责业务推导。

## 架构与边界

### Flutter 侧边界

- `widget_bridge` 继续负责：
  - 从 `task_flow` 读取当前任务真源
  - 结合 `settings_center` 偏好生成稳定快照
  - 写入共享存储
  - 触发 Widget 刷新
- `widget_launch_bridge` 从当前“恒定回首页”的空实现，升级为统一解析 Widget 回流参数的入口
- `presentation` 层不直接接触 `home_widget` 或平台参数解析

### 原生侧边界

- iOS `WidgetExtension` 只读取共享快照并渲染对应 family
- Android 小组件宿主只读取共享快照并渲染 RemoteViews 或 Glance 视图
- iOS、Android 都不允许：
  - 直接查库
  - 自己决定优先级排序
  - 自己重算隐私模式
  - 自己拼装另一套文案规则

## 数据合同设计

### 现状

当前 `WidgetSnapshot` 具备整体展示所需字段，`WidgetSnapshotItem` 仅包含：

- `title`
- `statusLabel`
- `dueLabel`
- `isPinned`
- `isOverdue`
- `isPrivate`
- `rank`

这足够渲染，但不足以支持“点条目进入对应事项”。

### 合同扩展

本次只对 `WidgetSnapshotItem` 做最小必要扩展，新增：

- `taskId`
  - 用于标识当前条目对应的事项
  - 只传稳定主键，不传完整实体
- `launchTarget`
  - 统一描述点击后应回流到哪类落点
  - 典型值包括：`home`、`task`

### 合同约束

- 快照仍然只承载展示与回流必要信息
- 不新增正文原文、完整备注、复杂排序元数据
- 版本号继续保留，由 `version` 控制原生读取兼容边界
- iOS 与 Android 使用同一套 key，禁止平台私有字段分叉为两份模型
- Flutter 输出的是“已按业务优先级排好序的安全条目列表”
- 各平台只允许按对应 family 的固定容量裁剪前 N 条，不允许重排、跳项或额外补项

## 展示设计

### iOS 锁屏小组件

- 继续保留 `.accessoryRectangular`
- 只显示 1 条主事项
- 继续保留当前轻量信息密度与回退提示
- 点击行为从统一的“回首页”升级为：
  - 条目可点击时进入对应事项
  - 否则退回首页

### iOS 桌面小组件

#### 小尺寸

- 只展示 1 条主事项
- 信息优先级：
  - 标题
  - 状态标签
  - 到期提示
- 不展示次要列表，保持强提醒感

#### 中尺寸

- 展示 2 到 3 条事项
- 第 1 条是主事项，展示信息最完整
- 第 2、3 条弱化展示，只保留标题和状态
- 若当前快照不足 2 条，则按现有数据数量展示，不制造占位假数据

### Android 桌面小组件

- 首轮只提供 1 个尺寸
- 展示 2 条事项
- 布局语义对齐 iOS 中尺寸：
  - 顶部标题区域
  - 主事项
  - 次事项
- 若平台实现细节限制了条目级点击，则允许主事项精确点击、次事项降级到首页，但共享合同仍保持完整

## 隐私与降级规则

- `previewOnly` 模式下，所有尺寸都不得泄露事项正文
- 私密事项即使在 `fullContent` 模式下也必须遮罩
- 锁屏、小尺寸、桌面中尺寸的隐私规则完全复用 Flutter 投影结果，不允许平台层特判绕开
- 快照读取失败时：
  - 优先读取当前快照
  - 若当前快照为空，退回最后一次有效快照
  - 若都没有，展示空状态
- Widget 刷新失败只允许能力降级，不允许影响事项创建、编辑、完成、删除、恢复主链路

## 回流设计

### 统一原则

- 平台层只负责把点击事件带回 Flutter
- Flutter 侧统一解释点击来源、目标事项与降级落点

### Flutter 入口桥

`widget_launch_bridge` 升级后需要支持：

- 识别来源是否为 widget
- 识别目标是首页还是具体事项
- 在目标事项无效、缺失或平台无法提供精确点击时，回退到首页

### 平台传参

- iOS 通过 `widgetURL` 或 Link 组件传递统一参数
- Android 通过 `PendingIntent` 传递统一参数
- 参数最小集：
  - `source=widget`
  - `target=home | task`
  - `taskId=<stable-id>`（仅条目点击时需要）

## 代码落点

### Flutter

- `lib/features/widget_bridge/domain/entities/`
  - 扩展快照条目合同
- `lib/features/widget_bridge/infrastructure/widget_snapshot_projector.dart`
  - 输出新字段
  - 保持条目排序、隐私投影与回流目标生成的一致性
- `lib/features/widget_bridge/application/services/`
  - 保持同步服务边界不变，仅消费更新后的合同
- `lib/app/startup/widget_launch_bridge.dart`
  - 从空实现升级为可解析 Widget 回流参数的桥接层

### iOS

- `ios/WidgetExtension/`
  - 扩展共享快照读取模型
  - 保留锁屏 family
  - 增加桌面 family 的时间线与视图渲染

### Android

- `android/app/src/main/`
  - 新增桌面小组件宿主
  - 新增布局或 Glance 渲染实现
  - 在 Manifest 注册 Widget Provider

## 测试策略

### Flutter 单元与集成测试

必须先补失败测试，再补实现，覆盖：

- `WidgetSnapshotItem` 包含条目回流字段
- 共享快照输出稳定排序的事项列表
- `previewOnly` 模式遮罩正文
- 私密事项在 `fullContent` 模式下仍遮罩
- 点击目标字段在主事项、次事项、空状态下的生成规则
- 现有自动同步链路在新增字段后仍会写入快照

### 平台验证

- iOS WidgetExtension 能编译通过
- Android 小组件宿主能编译通过
- 平台侧字段名与 Flutter 输出保持一致
- iOS 小尺寸只渲染第 1 条，中尺寸只渲染前 2 到 3 条
- Android 首轮尺寸只渲染前 2 条

### 全量验证

- `rtk flutter gen-l10n`
- `rtk dart run build_runner build --delete-conflicting-outputs`
- `rtk flutter analyze`
- `rtk flutter test`

若平台构建命令在本机环境受限，需要明确记录阻塞点，但 Flutter 侧验证不能省略。

## 实施顺序

1. 先扩共享快照合同与测试，确保“条目点击目标 + 稳定排序列表”可测
2. 再补 `widget_launch_bridge`，让回流语义先稳定
3. 再补 iOS WidgetExtension，统一锁屏与桌面 family
4. 再补 Android 桌面小组件宿主
5. 最后跑生成、分析、测试与平台构建验证

## 风险与控制

### 风险 1：平台层为了省事重做业务逻辑

控制：

- 统一由 Flutter 输出点击目标和展示内容
- 原生代码只保留渲染与事件透传

### 风险 2：多尺寸补齐后泄露私密内容

控制：

- 继续以 `widget_snapshot_projector` 为唯一隐私投影出口
- 新增测试覆盖 `previewOnly` 与私密事项场景

### 风险 3：Android 与 iOS 展示结果漂移

控制：

- 使用同一份快照合同
- Flutter 只负责排序和安全投影
- 各平台只按已定义 family 容量裁剪前 N 条，不做额外推导

### 风险 4：点击精确落点在平台实现受限

控制：

- 合同中仍完整保留精确落点字段
- 平台受限时按“精确点击优先，无法实现则回首页”降级，不阻塞功能交付
