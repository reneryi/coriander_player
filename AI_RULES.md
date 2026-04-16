# Coriander Player AI 工作规则

## 1. 目标
- 本文件定义 AI 在本仓库中的统一工作方式。
- 目标：稳定、可验证、可持续迭代。
- 默认原则：优先修复真实问题，其次再做功能扩展和界面优化。

## 2. 语言要求（强制）
- 所有 AI 输出、代码注释、提交说明、日志更新、任务记录一律使用中文。
- 即使外部文档或报错为英文，AI 对用户的解释和结论也必须给出中文版本。

## 3. 每次任务启动流程
1. 先读 `AI_RULES.md`。
2. 若存在 `TASK_LIST.md`，按优先级选择可执行任务。
3. 读取 `WORKLOG.md` 最近记录，避免重复改动或回归。
4. 检查工作区状态（`git status`）。
5. 默认直接实现，不在无必要时停留在纯分析阶段。

## 4. 项目结构认知
- 应用类型：Flutter 桌面音乐播放器（Windows 优先），通过 `flutter_rust_bridge` 调用 Rust 能力。
- 关键路径：
  - 启动入口：`lib/main.dart`
  - 路由入口：`lib/entry.dart`
  - 播放服务：`lib/play_service/`
  - 媒体库：`lib/library/`
  - 歌词：`lib/lyric/`
  - Rust Dart 桥：`lib/src/rust/`
  - Rust 实现：`rust/src/api/`
  - Windows Runner：`windows/runner/`
- 运行依赖注意：BASS 系列 dll/add-on 对完整播放能力是必需项。

## 5. 优先级策略
- 固定优先级：
  1. 崩溃、编译失败、启动失败
  2. 播放/歌词/状态同步正确性
  3. 配置与持久化安全（`settings.json`、`app_preference.json`）
  4. 用户可感知功能缺陷
  5. 新功能
  6. UI/UX 打磨
- 实施原则：
  - 小步可验证改动
  - 非需求驱动不改行为语义
  - 高耦合模块优先保守改法（播放服务、桥接层、Runner C++）

## 6. 文件边界
- 下列文件默认为生成产物或工具托管文件，非必要不手改：
  - `lib/src/rust/frb_generated*.dart`
  - `rust/src/frb_generated.rs`
  - `windows/flutter/generated_*`
- 本地私密占位文件：
  - `lib/page/settings_page/cpfeedback_key.dart` 为本地 gitignored 文件，不应提交真实密钥。

## 7. 验证矩阵（最低要求）
- 仅 Dart UI/逻辑改动：
  - `flutter analyze`
- 播放/桥接/原生交互改动：
  - `flutter analyze`
  - `flutter build windows --debug`
  - 修改 Rust 时补充：在 `rust/` 下执行 `cargo check`
- Windows Runner / CMake / C++ 改动：
  - `flutter build windows --debug`
  - 确认 IDE 索引问题已消除（不仅仅是可编译）

## 8. 完成定义（DoD）
- 任务完成必须同时满足：
  1. 代码已落地
  2. 对应验证命令通过
  3. 变更风险/副作用已说明
  4. `WORKLOG.md` 已追加本次记录（改动内容 + 验证结果）

## 9. TASK_LIST 协作规则
- 当 `TASK_LIST.md` 存在时，AI 以其为执行清单。
- 默认执行“当前阶段中优先级最高且可直接动手”的任务。
- 完成后应回写任务状态（例如 `[1]` -> `[x]` 或追加“已完成”标记）。
- 推荐字段：任务编号、标题、阶段、优先级、状态、验证方式、备注。

## 10. 风险防线
- 未经明确需求，不得破坏以下行为语义：
  - 播放控制（播放/暂停/上一首/下一首/循环/随机）
  - 配置读写兼容性
  - Rust 与 Dart API 对齐关系
- 任何可能影响跨模块行为的改动，必须在 `WORKLOG.md` 写清验证覆盖范围。
