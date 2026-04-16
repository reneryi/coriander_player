import 'dart:io';
import 'dart:math' as math;

import 'package:desktop_lyric/component/foreground.dart';
import 'package:desktop_lyric/desktop_lyric_controller.dart';
import 'package:desktop_lyric/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:win32/win32.dart' as win32;
import 'package:window_manager/window_manager.dart';

class ActionRow extends StatelessWidget {
  const ActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeChangedMessage>();
    const spacer = SizedBox(width: 8);
    final textDisplayController = context.read<TextDisplayController>();

    return ValueListenableBuilder<String?>(
      valueListenable: DesktopLyricController.instance.currentFontFamily,
      builder: (context, currentFontFromPlayer, _) {
        textDisplayController.initializeFontFamilyFromPlayer(
          currentFontFromPlayer,
        );
        return Stack(
          alignment: Alignment.centerRight,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () async {
                  hWnd = win32.GetForegroundWindow();

                  if (hWnd != null) {
                    final exStyle = win32.GetWindowLongPtr(
                      hWnd!,
                      win32.WINDOW_LONG_PTR_INDEX.GWL_EXSTYLE,
                    );

                    win32.SetWindowLongPtr(
                      hWnd!,
                      win32.WINDOW_LONG_PTR_INDEX.GWL_EXSTYLE,
                      exStyle |
                          win32.WINDOW_EX_STYLE.WS_EX_LAYERED |
                          win32.WINDOW_EX_STYLE.WS_EX_TRANSPARENT,
                    );

                    stdout.write(
                      "${const ControlEventMessage(ControlEvent.lock).buildMessageJson()}\n",
                    );
                  }
                },
                color: Color(theme.onSurface),
                icon: const Icon(Icons.lock),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: textDisplayController.increaseLyricFontSize,
                  color: Color(theme.onSurface),
                  icon: const Icon(Icons.text_increase),
                ),
                spacer,
                IconButton(
                  onPressed: textDisplayController.decreaseLyricFontSize,
                  color: Color(theme.onSurface),
                  icon: const Icon(Icons.text_decrease),
                ),
                spacer,
                IconButton(
                  onPressed: () => _showFontSelectorDialog(context),
                  color: Color(theme.onSurface),
                  tooltip: "歌词字体",
                  icon: const Icon(Icons.font_download),
                ),
                spacer,
                IconButton(
                  onPressed: () {
                    stdout.write(
                      "${const ControlEventMessage(ControlEvent.previousAudio).buildMessageJson()}\n",
                    );
                  },
                  color: Color(theme.onSurface),
                  icon: const Icon(Icons.skip_previous),
                ),
                spacer,
                ValueListenableBuilder(
                  valueListenable: DesktopLyricController.instance.isPlaying,
                  builder: (context, isPlaying, _) => IconButton(
                    onPressed: () {
                      stdout.write(
                        "${ControlEventMessage(isPlaying ? ControlEvent.pause : ControlEvent.start).buildMessageJson()}\n",
                      );
                    },
                    color: Color(theme.onSurface),
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  ),
                ),
                spacer,
                IconButton(
                  onPressed: () {
                    stdout.write(
                      "${const ControlEventMessage(ControlEvent.nextAudio).buildMessageJson()}\n",
                    );
                  },
                  color: Color(theme.onSurface),
                  icon: const Icon(Icons.skip_next),
                ),
                spacer,
                const _ShowColorSelectorBtn(),
                spacer,
                IconButton(
                  onPressed: () {
                    stdout.write(
                      "${const ControlEventMessage(ControlEvent.close).buildMessageJson()}\n",
                    );
                  },
                  color: Color(theme.onSurface),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

Color _currentLyricColor(
  TextDisplayController textDisplayController,
  ThemeChangedMessage theme,
) {
  if (textDisplayController.hasSpecifiedColor) {
    return textDisplayController.specifiedColor;
  }
  return Color(theme.primary);
}

void _syncThemeToPlayer(
  TextDisplayController textDisplayController,
  ThemeChangedMessage theme,
) {
  final primary = _currentLyricColor(textDisplayController, theme).toARGB32();
  stdout.write(
    "${PreferenceChangedMessage(primary, theme.surfaceContainer, theme.onSurface).buildMessageJson()}\n",
  );
}

int _colorChannel(Color color, int shift) => (color.toARGB32() >> shift) & 0xff;

List<String> _mergeFontOptions(List<String> loadedFonts, String? currentFont) {
  final unique = <String, String>{};
  for (final font in loadedFonts) {
    final normalized = font.trim();
    if (normalized.isEmpty) continue;
    unique.putIfAbsent(normalized.toLowerCase(), () => normalized);
  }
  final normalizedCurrent = currentFont?.trim();
  if (normalizedCurrent != null && normalizedCurrent.isNotEmpty) {
    unique.putIfAbsent(
        normalizedCurrent.toLowerCase(), () => normalizedCurrent);
  }
  final merged = unique.values.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return merged;
}

Future<void> _showFontSelectorDialog(BuildContext context) async {
  final theme = context.read<ThemeChangedMessage>();
  final textDisplayController = context.read<TextDisplayController>();
  final originSize = await windowManager.getSize();
  final targetHeight = math.max(originSize.height, 560.0);
  if (targetHeight > originSize.height) {
    await windowManager.setSize(Size(originSize.width, targetHeight));
  }
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Color(theme.surfaceContainer),
      surfaceTintColor: Colors.transparent,
      title: Text("选择歌词字体", style: TextStyle(color: Color(theme.onSurface))),
      content: SizedBox(
        width: 420,
        height: 420,
        child: Material(
          color: Color(theme.surfaceContainer),
          child: ValueListenableBuilder<List<String>>(
            valueListenable: DesktopLyricController.instance.installedFonts,
            builder: (context, loadedFonts, _) {
              return ValueListenableBuilder<String?>(
                valueListenable:
                    DesktopLyricController.instance.currentFontFamily,
                builder: (context, currentFontFromPlayer, __) {
                  final fontNames = _mergeFontOptions(
                    loadedFonts,
                    currentFontFromPlayer,
                  );
                  return ListView(
                    children: [
                      ListTile(
                        dense: true,
                        title: Text(
                          "系统默认",
                          style: TextStyle(color: Color(theme.onSurface)),
                        ),
                        trailing: textDisplayController.lyricFontFamily == null
                            ? Icon(Icons.check, color: Color(theme.onSurface))
                            : null,
                        onTap: () {
                          textDisplayController.setLyricFontFamily(null);
                          Navigator.pop(context);
                        },
                      ),
                      if (fontNames.isEmpty)
                        ListTile(
                          dense: true,
                          title: Text(
                            "字体列表同步中，请稍后重试",
                            style: TextStyle(color: Color(theme.onSurface)),
                          ),
                        )
                      else
                        ...fontNames.map(
                          (fontName) => ListTile(
                            dense: true,
                            title: Text(
                              fontName,
                              style: TextStyle(
                                color: Color(theme.onSurface),
                                fontFamily: fontName,
                              ),
                            ),
                            trailing: textDisplayController.lyricFontFamily ==
                                    fontName
                                ? Icon(Icons.check,
                                    color: Color(theme.onSurface))
                                : null,
                            onTap: () {
                              textDisplayController
                                  .setLyricFontFamily(fontName);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("关闭", style: TextStyle(color: Color(theme.onSurface))),
        ),
      ],
    ),
  );

  resizeWithForegroundSize();
}

final _colorSelectorController = MenuController();

class _ShowColorSelectorBtn extends StatelessWidget {
  const _ShowColorSelectorBtn();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeChangedMessage>();
    final textDisplayController = context.watch<TextDisplayController>();
    return MenuAnchor(
      controller: _colorSelectorController,
      consumeOutsideTap: true,
      onOpen: () {
        ALWAYS_SHOW_ACTION_ROW = true;
      },
      onClose: () {
        ALWAYS_SHOW_ACTION_ROW = false;
      },
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Color(theme.surfaceContainer)),
        elevation: const WidgetStatePropertyAll(8),
      ),
      menuChildren: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            width: 240,
            child: Wrap(
              children: List.generate(
                Colors.primaries.length,
                (i) => _ColorTile(color: Colors.primaries[i]),
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        MenuItemButton(
          leadingIcon: const Icon(Icons.tune),
          onPressed: () async {
            _colorSelectorController.close();
            await _showRgbColorDialog(context, textDisplayController, theme);
          },
          child: Text(
            "RGB 颜色",
            style: TextStyle(color: Color(theme.onSurface)),
          ),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.sync),
          onPressed: () {
            textDisplayController.usePlayerTheme();
            _syncThemeToPlayer(textDisplayController, theme);
            _colorSelectorController.close();
          },
          child: Text(
            "跟随播放器主题",
            style: TextStyle(color: Color(theme.onSurface)),
          ),
        ),
      ],
      builder: (context, controller, _) => IconButton(
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open(position: const Offset(0, 44));
          }
        },
        color: Color(theme.onSurface),
        icon: const Icon(Icons.palette),
      ),
    );
  }
}

Future<void> _showRgbColorDialog(
  BuildContext context,
  TextDisplayController textDisplayController,
  ThemeChangedMessage theme,
) async {
  final current = _currentLyricColor(textDisplayController, theme);
  final redController = TextEditingController(
    text: _colorChannel(current, 16).toString(),
  );
  final greenController = TextEditingController(
    text: _colorChannel(current, 8).toString(),
  );
  final blueController = TextEditingController(
    text: _colorChannel(current, 0).toString(),
  );
  String? errorText;

  int? parseChannel(String value) {
    final channel = int.tryParse(value.trim());
    if (channel == null || channel < 0 || channel > 255) {
      return null;
    }
    return channel;
  }

  Color? buildPreviewColor() {
    final red = parseChannel(redController.text);
    final green = parseChannel(greenController.text);
    final blue = parseChannel(blueController.text);
    if (red == null || green == null || blue == null) return null;
    return Color.fromARGB(255, red, green, blue);
  }

  final originSize = await windowManager.getSize();
  final targetHeight = math.max(originSize.height, 320.0);
  if (targetHeight > originSize.height) {
    await windowManager.setSize(Size(originSize.width, targetHeight));
  }
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          final previewColor = buildPreviewColor();
          return AlertDialog(
            title: Text(
              "设置歌词 RGB",
              style: TextStyle(color: Color(theme.onSurface)),
            ),
            content: SizedBox(
              width: 360,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: redController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (_) => setState(() {
                              errorText = null;
                            }),
                            decoration: const InputDecoration(
                              labelText: "R",
                              hintText: "0-255",
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: greenController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (_) => setState(() {
                              errorText = null;
                            }),
                            decoration: const InputDecoration(
                              labelText: "G",
                              hintText: "0-255",
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: blueController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (_) => setState(() {
                              errorText = null;
                            }),
                            decoration: const InputDecoration(
                              labelText: "B",
                              hintText: "0-255",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 30,
                      decoration: BoxDecoration(
                        color: previewColor ?? Colors.transparent,
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        previewColor == null ? "请输入有效 RGB" : "颜色预览",
                        style: TextStyle(
                          color: previewColor == null
                              ? Theme.of(context).colorScheme.error
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text("取消"),
              ),
              FilledButton(
                onPressed: () {
                  final nextColor = buildPreviewColor();
                  if (nextColor == null) {
                    setState(() {
                      errorText = "RGB 必须是 0 到 255 的整数";
                    });
                    return;
                  }
                  textDisplayController.spcifiyColor(nextColor);
                  _syncThemeToPlayer(textDisplayController, theme);
                  Navigator.of(dialogContext).pop();
                },
                child: const Text("应用"),
              ),
            ],
          );
        },
      );
    },
  );

  redController.dispose();
  greenController.dispose();
  blueController.dispose();
  resizeWithForegroundSize();
}

class _ColorTile extends StatelessWidget {
  final Color color;
  const _ColorTile({required this.color});

  @override
  Widget build(BuildContext context) {
    final textDisplayController = context.watch<TextDisplayController>();
    final theme = context.watch<ThemeChangedMessage>();
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Ink(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: InkWell(
          onTap: () {
            if (textDisplayController.hasSpecifiedColor) {
              if (textDisplayController.specifiedColor == color) {
                textDisplayController.usePlayerTheme();
              } else {
                textDisplayController.spcifiyColor(color);
              }
            } else {
              textDisplayController.spcifiyColor(color);
            }
            _syncThemeToPlayer(textDisplayController, theme);
            _colorSelectorController.close();
          },
          child: textDisplayController.hasSpecifiedColor &&
                  textDisplayController.specifiedColor == color
              ? const Center(
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
