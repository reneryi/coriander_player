# 栖声 Qisheng Player

[![Windows CI](https://github.com/reneryi/coriander_player/actions/workflows/windows_ci.yml/badge.svg)](https://github.com/reneryi/coriander_player/actions/workflows/windows_ci.yml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

栖声是面向 Windows 10/11 的本地音乐播放器，基于 Flutter、Rust 与 BASS 构建。项目源自 [Ferry-200/coriander_player](https://github.com/Ferry-200/coriander_player)，当前分支已整合为 `qisheng_player v1.0.0`，重点优化本地曲库、歌词、播放队列、桌面歌词和沉浸式播放器界面。

## 主要功能

- 本地曲库：支持多文件夹扫描、索引缓存、A-Z/拼音索引、搜索、排序、视图切换和当前播放定位。
- 播放体验：支持播放队列、随机/顺序/单曲循环、拖拽重排、播放次数统计、ReplayGain 音量均衡和 CUE 分轨。
- 歌词系统：支持本地歌词、在线歌词匹配、逐字歌词、翻译显示开关、桌面歌词和音乐页右侧歌词预览。
- 资料管理：支持艺术家、专辑、文件夹、歌单与详细信息页面，右键菜单可编辑标签、封面和歌词。
- 视觉与交互：统一玻璃拟态界面、动态专辑取色、可折叠侧栏、页面淡入淡出切换、沉浸式/专业式 Now Playing 页面。
- 系统集成：支持自定义快捷键、鼠标侧键、系统托盘、任务栏缩略图控制、窗口拖拽/缩放和 Windows 背景材质回退。

## 支持格式

| 格式 | 播放 | 内嵌歌词 |
| --- | :---: | :---: |
| MP3 / MP2 / MP1 | 支持 | 支持 |
| FLAC | 支持 | 支持 |
| WAV / WAVE | 支持 | 支持 |
| OGG | 支持 | 支持 |
| AAC / ADTS / M4A | 支持 | 支持 |
| AIFF / AIF / AIFC | 支持 | 支持 |
| OPUS | 支持 | 支持 |
| APE / WV / WVC | 支持 | 视标签而定 |
| DSD / AC3 / WMA / MPC / MIDI / AMR / 3GA / DTS | 支持 | 视标签而定 |

同目录 LRC 文件、UTF-8/UTF-16 歌词文件与在线歌词匹配可作为补充歌词源。

## 默认快捷键

| 功能 | 快捷键 |
| --- | --- |
| 播放 / 暂停 | `Space` |
| 上一首 / 下一首 | `Left` / `Right` |
| 音量加 / 音量减 | `Up` / `Down` |
| 静音 | `Alt + M` |
| 显示 / 隐藏桌面歌词 | `Ctrl + M` |
| 显示 / 隐藏主界面 | `Ctrl + H` |
| 返回上一页 | `Esc` |
| 退出程序 | `Ctrl + Q` |

所有快捷键都可以在设置中自定义，部分动作支持后台全局触发。

## 项目结构

```text
qisheng_player/
├─ lib/                         Flutter 主程序、页面、组件、主题和服务
│  ├─ component/                 通用组件与播放器 UI
│  ├─ library/                   曲库、歌单、封面、播放次数和元数据
│  ├─ page/                      音乐、艺术家、专辑、文件夹、歌单、设置等页面
│  ├─ play_service/              播放、歌词与桌面歌词服务
│  └─ src/bass/                  BASS 播放桥接
├─ rust/                         Rust 元数据读取与原生能力
├─ rust_builder/                 flutter_rust_bridge 生成/桥接包
├─ windows/                      Windows Runner、资源和窗口集成
├─ third_party/desktop_lyric/    桌面歌词子程序
├─ test/                         Widget、服务和回归测试
├─ tools/release/                Windows 发布打包脚本
├─ tools/test/                   工具类测试
├─ docs/                         更新日志、结构说明和发布流程
├─ assets/                       栖声品牌图标资源
└─ BASS/                         本地运行依赖 DLL，不提交到 Git
```

更详细的目录说明见 [docs/project_structure.md](docs/project_structure.md)。

## 本地开发

```powershell
flutter pub get
flutter analyze
flutter test

Set-Location rust
cargo check
Set-Location ..

flutter build windows --debug
```

## Windows 发布

先构建主程序和桌面歌词：

```powershell
flutter build windows --release

Set-Location third_party\desktop_lyric
flutter pub get
flutter build windows --release
Set-Location ..\..
```

再生成发布包：

```powershell
powershell -ExecutionPolicy Bypass -File tools/release/package_release_windows.ps1 -Version 1.0.0
```

发布产物输出到 `dist/windows/artifacts/packages/`：

- `Qisheng-Player-v1.0.0-Windows-x64.zip`
- `Qisheng-Player-v1.0.0-Setup-x64.exe`

生成安装器需要本机安装 Inno Setup 6。完整流程见 [docs/release_workflow.md](docs/release_workflow.md)。

## 文档

- [更新日志](docs/changelog.md)
- [项目结构](docs/project_structure.md)
- [Windows 发布流程](docs/release_workflow.md)
- [贡献指南](CONTRIBUTING.md)

## License

本项目基于 GPL-3.0 许可证发布。请同时遵守 BASS 与相关第三方依赖的授权要求。
