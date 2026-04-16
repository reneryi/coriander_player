# Coriander Player（Fork 版）

![音乐页](软件截图/音乐页.png)

> 基于 [Ferry-200/coriander_player](https://github.com/Ferry-200/coriander_player) 的维护分支。  
> 当前发布策略：
> - 第一次发布：阶段一（稳定性修复）+ 阶段二（功能扩展）
> - 第二次发布：阶段三（UI 重构）

## 本仓库版本定位

- 分支目标：Windows 桌面端稳定可发布版本
- 当前范围：`TASK_LIST.md` 中阶段一与阶段二功能均已落地
- 桌面歌词：已将 `desktop_lyric` 源码内置到 `third_party/desktop_lyric`

## 功能亮点（本次首发）

- 播放器窗口/托盘/任务栏控制增强（含最大化状态记忆、托盘恢复）
- 快捷键系统重构（后台可用范围控制、默认键位优化、音量步进优化）
- 音乐详情页能力增强（首字母查找、定位当前播放、播放次数排序与展示）
- 多选视图增强（批量添加到歌单、批量删除与删除行为确认）
- 播放页增强（右键菜单添加到歌单支持创建歌单、删除歌曲、控件自动隐藏优化）
- 桌面歌词增强（字体库接入、RGB 颜色、设置记忆、自定义背景、显示行为修复）
- 元数据与资源增强（WAV 元数据、在线封面补全、标签编辑、DTS 支持）

完整改动请见 [CHANGELOG.md](CHANGELOG.md)。

## 快速下载

- Releases: [reneryi/coriander_player releases](https://github.com/reneryi/coriander_player/releases)

## 开发环境

- Flutter `3.41.6`
- Dart SDK `>=3.1.4 <4.0.0`
- Rust stable（用于 `rust/`）
- Windows 10/11 x64（主要构建与验证平台）

## 依赖与目录说明

- 主程序：仓库根目录（Flutter + Rust）
- 桌面歌词：`third_party/desktop_lyric`（仓库内置 path 依赖）
- 音频动态库：运行时需要 `BASS/*.dll`
- 关键依赖声明：
  - `pubspec.yaml` 中 `desktop_lyric` 为 `path: third_party/desktop_lyric`
  - `pubspec.lock` 已固定为 `source: path`

## 本地构建（Windows）

1. 获取依赖

```bash
flutter pub get
```

2. 质量检查

```bash
flutter analyze
cd rust
cargo check
cd ..
flutter test tools/sort_smoke_test.dart
```

3. 构建主程序

```bash
flutter build windows --release
```

4. 构建桌面歌词

```bash
cd third_party/desktop_lyric
flutter pub get
flutter analyze --no-fatal-infos
flutter build windows --release
cd ../..
```

5. 准备 BASS 运行时（64 位）

将以下 DLL 放入发布目录 `BASS/`：

- `bass.dll`
- `bassape.dll`
- `bassdsd.dll`
- `bassflac.dll`
- `bassmidi.dll`
- `bassopus.dll`
- `basswv.dll`
- `basswasapi.dll`
- `bass_aac.dll`

## CI 说明

`/.github/workflows/windows_ci.yml` 已覆盖以下检查：

- 主工程：`flutter pub get`、`flutter analyze`、`cargo check`、`flutter test tools/sort_smoke_test.dart`、`flutter build windows --release`
- 桌面歌词：独立 `flutter pub get`、`flutter analyze --no-fatal-infos`、`flutter build windows --release`
- BASS 依赖下载与归档（含 `bassaac24.zip`）

## 提交规范

- 功能改动优先保证可复现（本地依赖优先 path/锁定版本）
- Bug 修复需附最小复现信息（输入条件、行为、期望、实际）
- PR 请尽量按功能分提交，避免“超大混合提交”

详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 致谢

- [Ferry-200/coriander_player](https://github.com/Ferry-200/coriander_player)
- [music_api](https://github.com/yhsj0919/music_api.git)
- [Lofty](https://crates.io/crates/lofty)
- [BASS](https://www.un4seen.com/bass.html)
- [flutter_rust_bridge](https://pub.dev/packages/flutter_rust_bridge)
- [desktop_lyric（原仓库）](https://github.com/Ferry-200/desktop_lyric)
