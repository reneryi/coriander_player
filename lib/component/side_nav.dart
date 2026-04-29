import 'dart:ui' show lerpDouble;

import 'package:qisheng_player/app_paths.dart' as app_paths;
import 'package:qisheng_player/component/responsive_builder.dart';
import 'package:qisheng_player/component/ui/app_surface.dart';
import 'package:qisheng_player/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

const _sideNavTransitionDuration = Duration(milliseconds: 280);
const _sideNavTransitionCurve = Curves.easeInOutCubic;

class DestinationDesc {
  const DestinationDesc(this.icon, this.label, this.desPath);

  final IconData icon;
  final String label;
  final String desPath;
}

const destinations = <DestinationDesc>[
  DestinationDesc(Symbols.library_music, '音乐', app_paths.AUDIOS_PAGE),
  DestinationDesc(Symbols.artist, '艺术家', app_paths.ARTISTS_PAGE),
  DestinationDesc(Symbols.album, '专辑', app_paths.ALBUMS_PAGE),
  DestinationDesc(Symbols.folder, '文件夹', app_paths.FOLDERS_PAGE),
  DestinationDesc(Symbols.list, '歌单', app_paths.PLAYLISTS_PAGE),
  DestinationDesc(Symbols.settings, '设置', app_paths.SETTINGS_PAGE),
];

class SideNav extends StatelessWidget {
  const SideNav({
    super.key,
    this.collapsed = false,
    this.onToggleCollapsed,
  });

  final bool collapsed;
  final ValueChanged<bool>? onToggleCollapsed;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selected = destinations.indexWhere(
      (desc) => location.startsWith(desc.desPath),
    );

    void onDestinationSelected(int value) {
      if (value == selected) return;

      context.go(destinations[value].desPath);

      final scaffold = Scaffold.maybeOf(context);
      if (scaffold?.hasDrawer ?? false) {
        scaffold?.closeDrawer();
      }
    }

    return ResponsiveBuilder(
      builder: (context, screenType) {
        switch (screenType) {
          case ScreenType.small:
            return Drawer(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _SideNavShell(
                    collapsed: false,
                    selected: selected,
                    onDestinationSelected: onDestinationSelected,
                    onToggleCollapsed: null,
                  ),
                ),
              ),
            );
          case ScreenType.medium:
            return SizedBox(
              key: const ValueKey('side-nav-large'),
              width: context.chrome.sideNavCollapsedWidth,
              child: _SideNavShell(
                collapsed: true,
                selected: selected,
                onDestinationSelected: onDestinationSelected,
                onToggleCollapsed: null,
              ),
            );
          case ScreenType.large:
            return AnimatedContainer(
              key: const ValueKey('side-nav-large'),
              duration: _sideNavTransitionDuration,
              curve: _sideNavTransitionCurve,
              width: collapsed
                  ? context.chrome.sideNavCollapsedWidth
                  : context.chrome.sideNavExpandedWidth,
              child: _SideNavShell(
                collapsed: collapsed,
                selected: selected,
                onDestinationSelected: onDestinationSelected,
                onToggleCollapsed: onToggleCollapsed,
              ),
            );
        }
      },
    );
  }
}

class _SideNavShell extends StatelessWidget {
  const _SideNavShell({
    required this.collapsed,
    required this.selected,
    required this.onDestinationSelected,
    required this.onToggleCollapsed,
  });

  final bool collapsed;
  final int selected;
  final ValueChanged<int> onDestinationSelected;
  final ValueChanged<bool>? onToggleCollapsed;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      variant: AppSurfaceVariant.glass,
      glassDensity: AppSurfaceGlassDensity.low,
      radius: 28,
      child: AnimatedPadding(
        duration: _sideNavTransitionDuration,
        curve: _sideNavTransitionCurve,
        padding: EdgeInsets.fromLTRB(
          collapsed ? 8 : 12,
          12,
          collapsed ? 8 : 12,
          12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SideNavBrand(),
            SizedBox(height: collapsed ? 12 : 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int index = 0;
                        index < destinations.length;
                        index++) ...[
                      _SideNavItem(
                        collapsed: collapsed,
                        selected: index == selected,
                        destination: destinations[index],
                        onTap: () => onDestinationSelected(index),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
            if (onToggleCollapsed != null) ...[
              const SizedBox(height: 8),
              _SideNavItem(
                collapsed: true,
                selected: false,
                destination: DestinationDesc(
                  collapsed
                      ? Icons.keyboard_double_arrow_right_rounded
                      : Icons.keyboard_double_arrow_left_rounded,
                  collapsed ? '展开侧栏' : '收起侧栏',
                  '',
                ),
                onTap: () => onToggleCollapsed!(!collapsed),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SideNavBrand extends StatelessWidget {
  const _SideNavBrand();

  @override
  Widget build(BuildContext context) {
    final accents = context.accents;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.1),
                accents.accent.withValues(alpha: 0.08),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: accents.accentGlow.withValues(alpha: 0.16),
                blurRadius: 22,
                spreadRadius: -8,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accents.accent.withValues(alpha: 0.24),
                      Colors.white.withValues(alpha: 0.08),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accents.accentGlow.withValues(alpha: 0.28),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: const _MetalNavIcon(
                  icon: Symbols.graphic_eq,
                  selected: true,
                  size: 23,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetalNavIcon extends StatelessWidget {
  const _MetalNavIcon({
    required this.icon,
    required this.selected,
    this.size = 24,
  });

  final IconData icon;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accents = context.accents;
    final glowSize = size + 24;
    return SizedBox(
      width: glowSize,
      height: glowSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: selected ? 1 : 0,
            duration: context.motion.controlTransitionDuration,
            curve: context.motion.normal,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accents.accentGlow.withValues(alpha: 0.42),
                    accents.accent.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SizedBox.square(dimension: glowSize),
            ),
          ),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: selected
                    ? [
                        Colors.white,
                        accents.accent,
                        Color.lerp(accents.accent, Colors.white, 0.45)!,
                      ]
                    : [
                        scheme.onSurface.withValues(alpha: 0.78),
                        scheme.onSurface.withValues(alpha: 0.56),
                      ],
              ).createShader(bounds);
            },
            child: Icon(icon, size: size, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SideNavItem extends StatefulWidget {
  const _SideNavItem({
    required this.collapsed,
    required this.selected,
    required this.destination,
    required this.onTap,
  });

  final bool collapsed;
  final bool selected;
  final DestinationDesc destination;
  final VoidCallback onTap;

  @override
  State<_SideNavItem> createState() => _SideNavItemState();
}

class _SideNavItemState extends State<_SideNavItem> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accents = context.accents;
    final highlight = widget.selected
        ? accents.selectionTint
        : (_hovered || _focused)
            ? Colors.white.withValues(alpha: 0.055)
            : Colors.transparent;

    final tile = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: _sideNavTransitionDuration,
        curve: _sideNavTransitionCurve,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: highlight,
          gradient: widget.selected
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    accents.accent.withValues(alpha: 0.2),
                    accents.accent.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.02),
                  ],
                )
              : null,
          border: Border.all(
            color: widget.selected
                ? accents.accent.withValues(alpha: 0.28)
                : _focused
                    ? accents.accentFocusRing.withValues(alpha: 0.28)
                    : Colors.transparent,
          ),
          boxShadow: widget.selected
              ? [
                  BoxShadow(
                    color: accents.accentGlow.withValues(alpha: 0.26),
                    blurRadius: 26,
                    spreadRadius: -6,
                  ),
                ]
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: FocusableActionDetector(
            onShowFocusHighlight: (value) {
              if (_focused == value) return;
              setState(() => _focused = value);
            },
            child: InkWell(
              enableFeedback: false,
              borderRadius: BorderRadius.circular(20),
              onTap: widget.onTap,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: _sideNavTransitionDuration,
                    curve: _sideNavTransitionCurve,
                    left: 0,
                    top: widget.selected ? 16 : 28,
                    child: AnimatedContainer(
                      key: widget.selected
                          ? const ValueKey('side-nav-active-indicator')
                          : null,
                      duration: _sideNavTransitionDuration,
                      curve: _sideNavTransitionCurve,
                      width: 4,
                      height: widget.selected ? 24 : 0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.92),
                            accents.accent.withValues(alpha: 0.95),
                            accents.accent.withValues(alpha: 0.75),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accents.accentGlow.withValues(alpha: 0.5),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: _SideNavItemContent(
                      collapsed: widget.collapsed,
                      selected: widget.selected,
                      icon: widget.destination.icon,
                      label: widget.destination.label,
                      textColor: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (!widget.collapsed) return tile;
    return Tooltip(message: widget.destination.label, child: tile);
  }
}

class _SideNavItemContent extends StatelessWidget {
  const _SideNavItemContent({
    required this.collapsed,
    required this.selected,
    required this.icon,
    required this.label,
    required this.textColor,
  });

  final bool collapsed;
  final bool selected;
  final IconData icon;
  final String label;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: collapsed ? 0 : 1),
      duration: _sideNavTransitionDuration,
      curve: _sideNavTransitionCurve,
      builder: (context, progress, _) {
        final resolvedProgress = Curves.easeOutCubic.transform(progress);
        final horizontalPadding = lerpDouble(8, 14, progress) ?? 14;
        final labelSlide = 10 * (1 - resolvedProgress);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.lerp(
                      Alignment.center,
                      Alignment.centerLeft,
                      resolvedProgress,
                    ) ??
                    Alignment.centerLeft,
                child: _MetalNavIcon(
                  icon: icon,
                  selected: selected,
                ),
              ),
              IgnorePointer(
                ignoring: resolvedProgress < 0.98,
                child: ClipRect(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 42),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Transform.translate(
                        offset: Offset(labelSlide, 0),
                        child: Opacity(
                          opacity: resolvedProgress,
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
