# Changelog

All notable changes to this project will be documented in this file.

## [1.6.0-stage1-stage2] - 2026-04-16

本版本为 fork 后第一版发布，覆盖 `TASK_LIST.md` 的阶段一与阶段二。

### Added

- 关闭窗口最小化到托盘，托盘菜单支持上一首/播放暂停/下一首/打开/退出
- 任务栏缩略图媒体控制按钮（上一首、播放/暂停、下一首）
- 播放列表拖拽重排与自定义顺序持久化
- 歌曲播放次数统计、展示与排序
- 音乐详情页字母查找与“定位当前播放歌曲”入口
- 播放页“添加到歌单”支持创建歌单
- 多选视图批量操作（批量添加到歌单、删除、范围选择）
- 快捷键设置（支持自定义，含后台可用范围控制）
- 在线补全无封面歌曲封面
- 歌曲元数据在线编辑（封面、歌词、Tag）
- 导入播放列表文件（m3u）

### Changed

- `desktop_lyric` 改为仓库内置依赖：`path: third_party/desktop_lyric`
- 音量默认快捷键调整：静音改为 `Alt + M`
- 音量调节步进改为 `1`
- 播放详情页无操作自动隐藏控件时长调整为 5 秒
- 列表排序逻辑统一中英文行为，按拼音/字母一致排序
- 随机播放逻辑更新：上一首/下一首均在随机序列中跳转

### Fixed

- 播放状态与 UI 图标不一致问题
- 最大化后关闭到托盘，再打开时窗口状态丢失问题
- 扫描重复歌曲问题（跨目录同文件重复显示）
- WAV 元数据读取缺失问题
- 桌面歌词设置不记忆问题（字体、位置、颜色、锁定等）
- 桌面歌词字体选择空白与 RGB 设置界面异常问题
- 自定义背景不生效问题
- 中文歌曲首字母查找不准确问题
- 字母索引高亮与定位按钮显示异常问题
- 严重乱码与标签显示异常问题

### CI / Build

- 新增并重构 Windows CI：
  - 主工程 analyze/test/build
  - `third_party/desktop_lyric` 独立 analyze/build
  - BASS 依赖自动下载（含 `bassaac24.zip`）
- `analysis_options.yaml` 排除 `third_party/desktop_lyric/**`，避免 third-party 噪音干扰主仓质量门禁

