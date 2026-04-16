# Contributing

感谢你关注 Coriander Player。

## 提交 Issue

1. 请写清楚复现步骤、期望行为、实际行为。
2. 建议附上截图/录屏、日志、音频样本信息（格式、编码、标签情况）。
3. 若是回归问题，请注明可复现版本与首次出现版本。

## 提交 PR

1. 尽量按功能拆分提交，避免把不相关改动混在一起。
2. 对行为变更请补充验证方式（命令、测试点、结果）。
3. 涉及 Windows Runner、Rust、Flutter 多层联动时，请在描述里写清调用链。

## 本地检查建议

```bash
flutter pub get
flutter analyze
cd rust
cargo check
cd ..
flutter test tools/sort_smoke_test.dart
flutter build windows --release
```

## 分支与提交建议

- 功能分支命名建议：`feature/...` 或 `fix/...`
- Commit message 建议包含模块前缀，例如：
  - `feat(player): ...`
  - `fix(desktop_lyric): ...`
  - `chore(ci): ...`

