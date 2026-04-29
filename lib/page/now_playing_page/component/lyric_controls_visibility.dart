import 'dart:async';

import 'package:flutter/foundation.dart';

class LyricControlsVisibilityController extends ChangeNotifier {
  LyricControlsVisibilityController({
    this.hideDelay = const Duration(milliseconds: 160),
  });

  final Duration hideDelay;

  bool _regionHovered = false;
  bool _controlsHovered = false;
  bool _menuOpen = false;
  bool _visible = false;
  Timer? _hideTimer;

  bool get visible => _visible;

  void setRegionHovered(bool hovered) {
    _regionHovered = hovered;
    _syncVisibility();
  }

  void setControlsHovered(bool hovered) {
    _controlsHovered = hovered;
    _syncVisibility();
  }

  void setMenuOpen(bool open) {
    _menuOpen = open;
    _syncVisibility();
  }

  void _syncVisibility() {
    final shouldShow = _regionHovered || _controlsHovered || _menuOpen;
    _hideTimer?.cancel();
    if (shouldShow) {
      _setVisible(true);
      return;
    }
    final effectiveDelay = hideDelay == Duration.zero
        ? Duration.zero
        : hideDelay + const Duration(milliseconds: 1);
    _hideTimer = Timer(effectiveDelay, () {
      _setVisible(false);
    });
  }

  void _setVisible(bool value) {
    if (_visible == value) return;
    _visible = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }
}
