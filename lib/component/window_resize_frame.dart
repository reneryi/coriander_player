import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:qisheng_player/window_controls.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

typedef WindowResizeStartCallback = Future<bool> Function(ResizeEdge edge);

class WindowResizeFrame extends StatelessWidget {
  const WindowResizeFrame({
    super.key,
    required this.child,
    this.edgeSize = 8,
    this.dragThreshold = 5,
    this.onStartResizing,
  });

  final Widget child;
  final double edgeSize;
  final double dragThreshold;
  final WindowResizeStartCallback? onStartResizing;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          left: edgeSize,
          right: edgeSize,
          top: 0,
          height: edgeSize,
          child: _WindowResizeEdge(
            edge: ResizeEdge.top,
            cursor: SystemMouseCursors.resizeUp,
            dragThreshold: dragThreshold,
            onStartResizing: onStartResizing,
          ),
        ),
        Positioned(
          left: edgeSize,
          right: edgeSize,
          bottom: 0,
          height: edgeSize,
          child: _WindowResizeEdge(
            edge: ResizeEdge.bottom,
            cursor: SystemMouseCursors.resizeDown,
            dragThreshold: dragThreshold,
            onStartResizing: onStartResizing,
          ),
        ),
        Positioned(
          left: 0,
          top: edgeSize,
          bottom: edgeSize,
          width: edgeSize,
          child: _WindowResizeEdge(
            edge: ResizeEdge.left,
            cursor: SystemMouseCursors.resizeLeft,
            dragThreshold: dragThreshold,
            onStartResizing: onStartResizing,
          ),
        ),
        Positioned(
          right: 0,
          top: edgeSize,
          bottom: edgeSize,
          width: edgeSize,
          child: _WindowResizeEdge(
            edge: ResizeEdge.right,
            cursor: SystemMouseCursors.resizeRight,
            dragThreshold: dragThreshold,
            onStartResizing: onStartResizing,
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          width: edgeSize,
          height: edgeSize,
          child: _WindowResizeEdge(
            edge: ResizeEdge.topLeft,
            cursor: SystemMouseCursors.resizeUpLeft,
            dragThreshold: dragThreshold,
            onStartResizing: onStartResizing,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          width: edgeSize,
          height: edgeSize,
          child: _WindowResizeEdge(
            edge: ResizeEdge.topRight,
            cursor: SystemMouseCursors.resizeUpRight,
            dragThreshold: dragThreshold,
            onStartResizing: onStartResizing,
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          width: edgeSize,
          height: edgeSize,
          child: _WindowResizeEdge(
            edge: ResizeEdge.bottomLeft,
            cursor: SystemMouseCursors.resizeDownLeft,
            dragThreshold: dragThreshold,
            onStartResizing: onStartResizing,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          width: edgeSize,
          height: edgeSize,
          child: _WindowResizeEdge(
            edge: ResizeEdge.bottomRight,
            cursor: SystemMouseCursors.resizeDownRight,
            dragThreshold: dragThreshold,
            onStartResizing: onStartResizing,
          ),
        ),
      ],
    );
  }
}

class _WindowResizeEdge extends StatefulWidget {
  const _WindowResizeEdge({
    required this.edge,
    required this.cursor,
    required this.dragThreshold,
    this.onStartResizing,
  });

  final ResizeEdge edge;
  final MouseCursor cursor;
  final double dragThreshold;
  final WindowResizeStartCallback? onStartResizing;

  @override
  State<_WindowResizeEdge> createState() => _WindowResizeEdgeState();
}

class _WindowResizeEdgeState extends State<_WindowResizeEdge> {
  int? _activePointer;
  Offset? _pointerDownPosition;
  bool _resizeStarted = false;

  bool _isPrimaryMouseButton(PointerEvent event) {
    return event.kind == PointerDeviceKind.mouse &&
        (event.buttons & kPrimaryMouseButton) != 0;
  }

  void _resetPointerState() {
    _activePointer = null;
    _pointerDownPosition = null;
    _resizeStarted = false;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!_isPrimaryMouseButton(event)) return;
    _activePointer = event.pointer;
    _pointerDownPosition = event.position;
    _resizeStarted = false;
  }

  Future<bool> _startResizing() async {
    final callback = widget.onStartResizing;
    if (callback != null) {
      return callback(widget.edge);
    }
    if (Platform.isWindows) {
      return WindowControls.startResizing(widget.edge);
    }
    await windowManager.startResizing(widget.edge);
    return true;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (_activePointer != event.pointer ||
        _pointerDownPosition == null ||
        _resizeStarted ||
        !_isPrimaryMouseButton(event)) {
      return;
    }

    final delta = event.position - _pointerDownPosition!;
    final distance = math.sqrt(delta.dx * delta.dx + delta.dy * delta.dy);
    if (distance < widget.dragThreshold) return;

    _resizeStarted = true;
    unawaited(_startResizing());
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_activePointer == event.pointer) {
      _resetPointerState();
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (_activePointer == event.pointer) {
      _resetPointerState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _handlePointerDown,
        onPointerMove: _handlePointerMove,
        onPointerUp: _handlePointerUp,
        onPointerCancel: _handlePointerCancel,
        child: const SizedBox.expand(),
      ),
    );
  }
}
