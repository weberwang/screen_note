---
name: flutter-dev
description: Use when implementing or extending the screen_note Flutter app after initialization, especially when working inside existing bounded features, adding a new bounded feature, wiring routes or integrations, or following the project's chosen package, layering, and code-generation conventions.
---

# Flutter Dev

## Overview

Operate on the initialized `screen_note` Flutter app using the project decisions captured during setup. This skill is project-specific and inherits the base rules from `flutter-project-guardrails`.

## Scope

- This skill constrains implementation work inside the initialized project.
- Do not use this skill to handle project initialization, plugin setup, plugin reconfiguration, or `--force` flows.
- Initialization and plugin handling stay in `flutter-init`.

## Required Base Policy

- Apply `flutter-project-guardrails` first for mandatory package rules, DDD layering, annotation usage, and forbidden mixed stacks.
- Use this skill for project-specific details that do not belong in the global guardrails.

## Project Snapshot

- Project name: `screen_note`
- Package id: `Android: com.example.screen_note; Apple platforms: com.example.screenNote`
- Platforms: `iOS, Android, macOS, Linux, Windows, Web`
- Environments: `single default environment`
- Primary features: `tasks, history, settings, quick_add, widget_bridge`
- Core integrations: `drift, shared_preferences, flutter_secure_storage, home_widget, flutter_local_notifications, timezone, dio, retrofit, flutter gen-l10n`

## Workflow

1. Map the task to an existing bounded feature or decide whether a new feature is required.
2. Re-check the feature boundary, route ownership, data source ownership, and generation impact before editing files.
3. Follow the project command set and environment conventions defined in the references.
4. When adding new project-specific decisions, update the decision log instead of hiding them in implementation details.

## Hard Rules

- 当前真实运行代码根已迁移到 `lib/app`、`lib/shared` 与 `lib/features`，不要再向 `lib/src` 回填运行时代码。
- 新增功能默认优先扩展 `lib/features/<feature>` 下既有业务边界，跨 feature 复用再提升到 `lib/shared`。
- 业务模块统一收口到 `lib/features/...`，避免重新引入平铺顶层业务目录。
- 不允许同时维护旧 `lib/src/<feature>` 与新 `lib/features/<feature>` 两份真实运行代码。
- 不要绕过项目既有分层边界，页面层只负责展示、输入和导航。
- Do not add packages outside the approved project bundle without recording the reason and impact.
- Do not hand-edit generated `.g.dart` or `.freezed.dart` files.
- Do not create cross-feature dependencies without updating the feature map and rationale.
- Do not take over initialization, plugin setup, or force-based reconfiguration responsibilities.

## Project Conventions

- Route strategy: `继续以 go_router 维护统一路由树，现有运行入口在 lib/app`
- Networking strategy: `当前首版仍以本地数据与系统桥接为主，但 core/network 已补齐 dio + retrofit 初始化基座，新远程能力必须直接接在这条链路上`
- Storage strategy: `结构化数据走 drift，轻量偏好与桥接草稿走 shared_preferences，敏感配置与未来令牌统一走 flutter_secure_storage`
- Test commands: `rtk flutter analyze` and `rtk flutter test`
- Build commands: `rtk flutter pub get`, `rtk dart run build_runner build --delete-conflicting-outputs`, `rtk flutter run`

## References

- Read `references/project-context.md` for the concrete project summary and environment details.
- Read `references/feature-map.md` for the bounded contexts, ownership map, and extension rules.
- Read `references/decision-log.md` for project-specific architectural decisions and exceptions.
