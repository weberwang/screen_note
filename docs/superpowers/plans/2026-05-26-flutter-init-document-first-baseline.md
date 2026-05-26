# Flutter Init 文档先行基线补齐 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为 `screen_note` 补齐项目本地 `flutter-dev` 技能、初始化基线审计文档和目标目录占位，同时保持现有 `lib/src` 运行链路不变。

**Architecture:** 本次实现只新增文档、技能和说明性占位，不迁移任何现有业务代码，不补接未落地的运行时基础设施。项目本地技能会继承 `flutter-project-guardrails`，并把当前仓库真实结构、未来目标结构和未对齐项显式写清，避免后续开发误把目标状态当成当前事实。

**Tech Stack:** Flutter、Markdown、项目本地 skills、RTK 命令代理

---

## 文件结构总览

### 新增文件

- `.agents/skills/flutter-dev/SKILL.md`
- `.agents/skills/flutter-dev/references/project-context.md`
- `.agents/skills/flutter-dev/references/feature-map.md`
- `.agents/skills/flutter-dev/references/decision-log.md`
- `docs/screen-note-flutter-init-baseline-audit-2026-05-26.md`
- `lib/app/README.md`
- `lib/core/README.md`
- `lib/features/README.md`

### 参考文件

- `.agents/skills/flutter-init/assets/flutter-dev-template/SKILL.md`
- `.agents/skills/flutter-init/assets/flutter-dev-template/references/project-context.md`
- `.agents/skills/flutter-init/assets/flutter-dev-template/references/feature-map.md`
- `.agents/skills/flutter-init/assets/flutter-dev-template/references/decision-log.md`
- `docs/superpowers/specs/2026-05-26-flutter-init-document-first-baseline-design.md`
- `pubspec.yaml`
- `lib/src/app/app.dart`
- `lib/src/app/router.dart`

### 约束说明

- 当前真实运行代码根仍是 `lib/src`
- 不复制现有业务代码到 `lib/app`、`lib/core`、`lib/features`
- 不改动现有路由、Provider、数据库和原生桥接
- Git 提交动作必须等用户在任务完成后选择 `仅提交`、`提交并推送` 或 `忽略`

## Task 1: 生成项目本地 flutter-dev 技能

**Files:**
- Create: `.agents/skills/flutter-dev/SKILL.md`
- Create: `.agents/skills/flutter-dev/references/project-context.md`
- Create: `.agents/skills/flutter-dev/references/feature-map.md`
- Create: `.agents/skills/flutter-dev/references/decision-log.md`

- [ ] **Step 1: 创建目标技能目录**

Run: `rtk proxy powershell -NoProfile -Command "New-Item -ItemType Directory -Force '.agents\\skills\\flutter-dev\\references' | Out-Null"`

Expected: `.agents/skills/flutter-dev/` 与 `references/` 目录存在，且不会覆盖其他技能目录。

- [ ] **Step 2: 写入项目专属 SKILL.md**

把模板中的占位符全部替换为 `screen_note` 项目真实信息，并保留以下关键段落：

```md
---
name: flutter-dev
description: Use when implementing or extending the screen_note Flutter app after initialization, especially when working inside existing bounded features, adding a new capability, wiring routes or integrations, or following the project's package, layering, and code-generation conventions.
---

# Flutter Dev

## Required Base Policy

- Apply `flutter-project-guardrails` first for mandatory package rules, DDD layering, annotation usage, and forbidden mixed stacks.

## Project Snapshot

- Project name: `screen_note`
- Package id: `com.example.screen_note` / `com.example.screenNote`
- Platforms: `iOS, Android, macOS, Linux, Windows, Web`
- Environments: `single default environment`
- Primary features: `tasks, history, settings, quick_add, widget_bridge`
- Core integrations: `drift, shared_preferences, home_widget, flutter_local_notifications, flutter gen-l10n`

## Hard Rules

- 当前真实代码根仍是 `lib/src`
- 新增功能默认优先扩展现有业务边界，不做无意义迁移
- 只有当某个 feature 被实质性重做时，才允许迁入 `lib/features/...`
- 不允许同时维护 `lib/src/<feature>` 与 `lib/features/<feature>` 两份真实代码
- 不要把目录占位误写成已完成迁移的运行时代码
```

- [ ] **Step 3: 写入 project-context.md**

文档必须写明项目目标、平台、当前首版范围、关键集成和统一命令，至少覆盖以下内容：

```md
# Project Context

## Product Summary

- Project name: `screen_note`
- Goal: `围绕锁屏、小组件与系统入口交付极简、可靠、隐私优先的事项记录体验`
- Target users: `需要超低摩擦记录待办并在锁屏快速查看的个人用户`
- Package id: `com.example.screen_note` / `com.example.screenNote`
- Supported platforms: `Flutter 多端，当前以 iOS 体验优先`

## Delivery Scope

- First release scope: `任务生命周期、历史记录、设置、快速添加、小组件桥接、提醒基础能力`
- Out of scope: `复杂协作、云同步、AI 自动写入、Android 完整体验对齐`
- Key integrations: `drift, shared_preferences, home_widget, flutter_local_notifications, timezone, gen-l10n`

## Commands

- Fetch dependencies: `rtk flutter pub get`
- Generate code: `rtk dart run build_runner build --delete-conflicting-outputs`
- Analyze: `rtk flutter analyze`
- Test: `rtk flutter test`
- Run app: `rtk flutter run`
```

- [ ] **Step 4: 写入 feature-map.md 与 decision-log.md**

`feature-map.md` 必须固定当前业务边界；`decision-log.md` 必须固定结构现实与未对齐项。至少包含以下内容：

```md
# Feature Map

## Primary Features

- `tasks`: `任务生命周期、列表、详情、编辑、排序与状态推导`
- `history`: `已完成与已删除历史视图`
- `settings`: `设置、隐私设置、Widget 设置`
- `quick_add`: `系统快捷添加、草稿恢复与桥接`
- `widget_bridge`: `小组件快照、显示模式、刷新调度`
```

```md
# Decision Log

| Area | Decision | Reason | Impact |
| --- | --- | --- | --- |
| State | `flutter_riverpod + hooks_riverpod，当前以手写 Provider 为主` | `已覆盖当前状态组织，但尚未迁入注解生成链路` | `后续新增状态需先遵守现有边界，再决定是否迁移` |
| Routing | `go_router` | `当前所有主要页面已统一接入` | `后续路由扩展必须延续同一路由树` |
| Storage | `drift + shared_preferences` | `分别承担结构化数据与轻量偏好/桥接草稿` | `本轮不额外引入安全存储运行时实现` |
| Structure | `当前真实代码根为 lib/src，lib/app/core/features 仅为目标占位` | `避免制造双份运行代码` | `后续迁移必须以实质性 feature 重做为触发条件` |
```

- [ ] **Step 5: 扫描技能残留占位符**

Run: `rtk rg -n "\\{\\{|PLACEHOLDER|TODO|TBD" ".agents\\skills\\flutter-dev"`

Expected: 无输出；任何模板残留都必须在继续前清零。

## Task 2: 编写初始化基线审计文档

**Files:**
- Create: `docs/screen-note-flutter-init-baseline-audit-2026-05-26.md`

- [ ] **Step 1: 创建审计文档骨架**

文档必须至少包含以下章节：

```md
# Screen Note Flutter Init 基线审计

## 当前事实
## 目标基线
## 差距清单
## 本轮仅记录不落地项
## 后续收敛建议
```

- [ ] **Step 2: 写清当前事实与目标基线**

在 `当前事实` 中写清：

```md
- 当前真实运行代码根为 `lib/src`
- `lib/src/app` 已承担应用入口与路由装配
- `lib/src/shared` 已承担主题、通用 Scaffold 与共享展示组件
- `tasks/history/settings/quick_add/widget_bridge` 已按业务边界拆分
```

在 `目标基线` 中写清：

```md
- 目标结构为 `lib/app`、`lib/core`、`lib/shared`、`lib/features`
- 目标状态组织优先采用 Riverpod 注解生成链路
- 目标网络基线为 `dio + retrofit`
- 目标安全存储基线为 `flutter_secure_storage`
```

- [ ] **Step 3: 写清差距与本轮不落地项**

差距表至少包含这些条目：

```md
| Area | 当前状态 | 目标状态 | 本轮处理 |
| --- | --- | --- | --- |
| 目录结构 | `lib/src` 为真实运行根 | `lib/app/core/shared/features` | `仅建立说明性占位，不迁移代码` |
| Riverpod | `手写 Provider` | `@riverpod + riverpod_generator` | `仅记录差距` |
| 网络 | `暂无 dio/retrofit 运行时入口` | `dio + retrofit` | `仅记录差距` |
| 安全存储 | `未接入 flutter_secure_storage` | `secure storage 基线` | `仅记录差距` |
| 日志 | `未形成统一 logger 入口` | `logger 或等价统一入口` | `仅记录差距` |
```

- [ ] **Step 4: 写出后续收敛建议**

至少写出以下 3 条建议：

```md
1. 后续只有在某个 feature 被实质性重做时，才把它迁入 `lib/features/...`
2. 如果引入远程接口，再补入 `dio + retrofit`，不要为清单而预埋假代码
3. Riverpod 注解化迁移应按 feature 分批推进，避免一次性全仓改造
```

- [ ] **Step 5: 自检审计文档口径**

Run: `rtk rg -n "已完成迁移|全面对齐|全部完成" "docs\\screen-note-flutter-init-baseline-audit-2026-05-26.md"`

Expected: 文档中不出现夸大完成度的表述；如果出现，改成“目标”“占位”“仅记录”。

## Task 3: 建立目标目录说明性占位

**Files:**
- Create: `lib/app/README.md`
- Create: `lib/core/README.md`
- Create: `lib/features/README.md`

- [ ] **Step 1: 建立 lib/app 占位说明**

`lib/app/README.md` 至少写明：

```md
# lib/app

该目录是未来应用壳层目标位置，计划承载：

- bootstrap
- app shell
- router
- route guard
- 全局装配

当前真实运行代码仍在 `lib/src/app`，本目录本轮只作结构占位，不放运行时代码。
```

- [ ] **Step 2: 建立 lib/core 占位说明**

`lib/core/README.md` 至少写明：

```md
# lib/core

该目录是未来跨 feature 基础设施目标位置，计划承载：

- network
- error model
- logging
- config
- secure storage
- 其他共享技术基座

当前仓库尚未把这些能力统一收口到本目录，本目录本轮只作职责说明。
```

- [ ] **Step 3: 建立 lib/features 占位说明**

`lib/features/README.md` 至少写明：

```md
# lib/features

该目录是未来按业务边界组织 feature 的目标位置。

每个 feature 目标结构：

- domain
- application
- infrastructure
- presentation

当前真实运行代码仍位于 `lib/src/tasks`、`history`、`settings`、`quick_add`、`widget_bridge`。后续只在 feature 被实质性重做时再迁入此目录。
```

- [ ] **Step 4: 确认未生成伪运行时代码**

Run: `rtk rg --files lib/app lib/core lib/features`

Expected: 只看到 `README.md`；如果出现 Dart 运行时代码文件，必须删除或改回纯说明文件。

## Task 4: 验证与结果收口

**Files:**
- Verify: `.agents/skills/flutter-dev/**`
- Verify: `docs/screen-note-flutter-init-baseline-audit-2026-05-26.md`
- Verify: `lib/app/README.md`
- Verify: `lib/core/README.md`
- Verify: `lib/features/README.md`

- [ ] **Step 1: 运行技能与文档占位符扫描**

Run: `rtk rg -n "\\{\\{|PLACEHOLDER|TODO|TBD" ".agents\\skills\\flutter-dev" "docs\\screen-note-flutter-init-baseline-audit-2026-05-26.md" "lib\\app\\README.md" "lib\\core\\README.md" "lib\\features\\README.md"`

Expected: 无输出。

- [ ] **Step 2: 运行工程分析**

Run: `rtk flutter analyze`

Expected: Analyze 通过；如果失败，需区分是否为仓库既有问题还是本轮新增问题。

- [ ] **Step 3: 运行测试**

Run: `rtk flutter test`

Expected: 测试尽可能通过；若失败，需要在总结中明确列出失败范围与是否和本轮改动相关。

- [ ] **Step 4: 汇总改动结果**

总结必须覆盖：

```md
- 新增了哪些技能与文档
- 哪些 guardrails 已记录但未落地
- `lib/src` 仍是当前真实运行根
- 验证命令结果
- 是否存在与本轮无关的已有问题
```

- [ ] **Step 5: 等待用户选择提交流程**

任务完成后不要直接执行 `git add` / `git commit` / `git push`。必须先提示用户选择：

```md
仅提交 / 提交并推送 / 忽略
```

Expected: 收到用户选择前，不做任何 git 提交动作。
