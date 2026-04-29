import 'package:qisheng_player/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

class AppComponentThemes {
  const AppComponentThemes._();

  static const Size _minInteractiveSize = Size(44, 44);

  static FilledButtonThemeData filledButtonTheme(
    ColorScheme scheme,
    AppSurfaceTokens surfaces,
    AppAccentTokens accents,
    AppVisualTokens visuals,
  ) {
    return FilledButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 200), // 丝滑动画
        minimumSize: const WidgetStatePropertyAll(_minInteractiveSize),
        enableFeedback: false,
        // 鐜颁唬绠€绾︼細鏇村鏉剧殑鎸夐挳鍐呰竟璺?
        padding: _pressablePadding(
          const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          visuals,
        ),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return 0;
          if (states.contains(WidgetState.pressed)) return 1.2;
          if (states.contains(WidgetState.hovered)) return 4.2;
          return 2.2;
        }),
        shadowColor: _resolveGlowShadow(accents, visuals),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.42);
          }
          return accents.onAccent;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.pressed)) {
            return accents.accent;
          }
          if (states.contains(WidgetState.hovered)) {
            return Color.lerp(accents.accentContainer, accents.accent, 0.2)!;
          }
          return accents.accentContainer;
        }),
        overlayColor: WidgetStatePropertyAll(accents.hoverTint),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(surfaces.radiusXxl),
          ),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(
              color: accents.accentFocusRing.withValues(
                alpha:
                    accents.accentFocusRing.a * visuals.buttonFocusRingOpacity,
              ),
              width: 1.5,
            );
          }
          return BorderSide(color: accents.accentSoft.withValues(alpha: 0.12));
        }),
      ),
    );
  }

  static TextButtonThemeData textButtonTheme(
    ColorScheme scheme,
    AppSurfaceTokens surfaces,
    AppAccentTokens accents,
    AppVisualTokens visuals,
  ) {
    return TextButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 200), // 丝滑动画
        minimumSize: const WidgetStatePropertyAll(_minInteractiveSize),
        enableFeedback: false,
        // 鐜颁唬绠€绾︼細鏇村鏉剧殑鏂囧瓧鎸夐挳
        padding: _pressablePadding(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          visuals,
        ),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.4);
          }
          if (states.contains(WidgetState.pressed)) {
            return accents.accent;
          }
          return scheme.onSurface;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.transparent;
          }
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return accents.accentSoft;
          }
          return Colors.transparent;
        }),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) return 2.0;
          if (states.contains(WidgetState.pressed)) return 0.8;
          return 0;
        }),
        shadowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return accents.accentGlow.withValues(
              alpha: accents.accentGlow.a * visuals.buttonGlowOpacity * 0.8,
            );
          }
          if (states.contains(WidgetState.pressed)) {
            return accents.accentGlow.withValues(
              alpha: accents.accentGlow.a * visuals.buttonGlowOpacity * 0.38,
            );
          }
          return Colors.transparent;
        }),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(surfaces.radiusXxl),
          ),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(
              color: accents.accentFocusRing.withValues(
                alpha:
                    accents.accentFocusRing.a * visuals.buttonFocusRingOpacity,
              ),
              width: 1.4,
            );
          }
          return const BorderSide(color: Colors.transparent);
        }),
      ),
    );
  }

  static OutlinedButtonThemeData outlinedButtonTheme(
    ColorScheme scheme,
    AppSurfaceTokens surfaces,
    AppAccentTokens accents,
    AppVisualTokens visuals,
  ) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 200), // 丝滑动画
        minimumSize: const WidgetStatePropertyAll(_minInteractiveSize),
        enableFeedback: false,
        // 鐜颁唬绠€绾︼細鏇村鏉剧殑杞粨鎸夐挳
        padding: _pressablePadding(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          visuals,
        ),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.4);
          }
          return scheme.onSurface;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return accents.accentSoft.withValues(alpha: 0.82);
          }
          if (states.contains(WidgetState.pressed)) {
            return accents.accentSoft.withValues(alpha: 0.58);
          }
          return surfaces.surfaceInset.withValues(alpha: surfaces.panelAlpha);
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
                color: surfaces.strokeSubtle.withValues(alpha: 0.42));
          }
          if (states.contains(WidgetState.focused)) {
            return BorderSide(
              color: accents.accentFocusRing.withValues(
                alpha:
                    accents.accentFocusRing.a * visuals.buttonFocusRingOpacity,
              ),
              width: 1.5,
            );
          }
          if (states.contains(WidgetState.hovered)) {
            return BorderSide(color: accents.accent.withValues(alpha: 0.76));
          }
          return BorderSide(
              color: surfaces.strokeStrong.withValues(alpha: 0.72));
        }),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) return 2.8;
          if (states.contains(WidgetState.pressed)) return 1;
          return 0.6;
        }),
        shadowColor: _resolveGlowShadow(accents, visuals),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(surfaces.radiusXxl),
          ),
        ),
      ),
    );
  }

  static ElevatedButtonThemeData elevatedButtonTheme(
    ColorScheme scheme,
    AppSurfaceTokens surfaces,
    AppAccentTokens accents,
    AppVisualTokens visuals,
  ) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 200), // 丝滑动画
        minimumSize: const WidgetStatePropertyAll(_minInteractiveSize),
        enableFeedback: false,
        // 鐜颁唬绠€绾︼細鏇村鏉剧殑娴捣鎸夐挳
        padding: _pressablePadding(
          const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          visuals,
        ),
        foregroundColor: WidgetStatePropertyAll(accents.onAccent),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.pressed)) {
            return accents.accent;
          }
          return accents.accentContainer;
        }),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return 0;
          if (states.contains(WidgetState.pressed)) return 1.1;
          if (states.contains(WidgetState.hovered)) return 4.4;
          return 2.4;
        }),
        shadowColor: _resolveGlowShadow(accents, visuals),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(surfaces.radiusXxl),
          ),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(
              color: accents.accentFocusRing.withValues(
                alpha:
                    accents.accentFocusRing.a * visuals.buttonFocusRingOpacity,
              ),
              width: 1.4,
            );
          }
          return BorderSide(color: accents.accentSoft.withValues(alpha: 0.12));
        }),
      ),
    );
  }

  static IconButtonThemeData iconButtonTheme(
    ColorScheme scheme,
    AppSurfaceTokens surfaces,
    AppAccentTokens accents,
    AppVisualTokens visuals,
  ) {
    return IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(_minInteractiveSize),
        fixedSize: const WidgetStatePropertyAll(_minInteractiveSize),
        enableFeedback: false,
        padding: _pressablePadding(const EdgeInsets.all(10), visuals),
        iconColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          return scheme.onSurface;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return accents.accentSoft.withValues(alpha: 0.58);
          }
          if (states.contains(WidgetState.hovered)) {
            return Colors.white.withValues(alpha: 0.14);
          }
          return Colors.white.withValues(alpha: 0.075);
        }),
        overlayColor: WidgetStatePropertyAll(
          scheme.onSurface.withValues(alpha: 0.08),
        ),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return 0.8;
          if (states.contains(WidgetState.hovered)) return 3.4;
          return 1.8;
        }),
        shadowColor: _resolveGlowShadow(accents, visuals),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(
              color: accents.accentFocusRing.withValues(
                alpha:
                    accents.accentFocusRing.a * visuals.buttonFocusRingOpacity,
              ),
              width: 1.4,
            );
          }
          return BorderSide(color: Colors.white.withValues(alpha: 0.12));
        }),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(surfaces.radiusXxl),
          ),
        ),
      ),
    );
  }

  static InputDecorationTheme inputDecorationTheme(
    ColorScheme scheme,
    AppSurfaceTokens surfaces,
  ) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(surfaces.radiusXxl),
      borderSide: BorderSide(color: surfaces.strokeSubtle),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: surfaces.surfaceInset.withValues(alpha: surfaces.panelAlpha),
      // Input padding.
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.58)),
      prefixIconColor: scheme.onSurface.withValues(alpha: 0.72),
      suffixIconColor: scheme.onSurface.withValues(alpha: 0.72),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: scheme.primary.withValues(alpha: 0.82)),
      ),
    );
  }

  // 鐜颁唬绠€绾︼細瀵硅瘽妗嗕娇鐢ㄦ洿澶у渾瑙掑拰鏌斿拰闃村奖
  static DialogThemeData dialogTheme(
    AppSurfaceTokens surfaces,
  ) {
    return DialogThemeData(
      backgroundColor: surfaces.surfaceRaised,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(surfaces.radiusXxl),
      ),
      shadowColor: surfaces.shadowColor,
      elevation: 12,
    );
  }

  static MenuThemeData menuTheme(
    AppSurfaceTokens surfaces,
  ) {
    return MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(surfaces.surfaceFloating),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(surfaces.radiusLg),
            side: BorderSide(color: surfaces.strokeSubtle),
          ),
        ),
      ),
    );
  }

  static TabBarThemeData tabBarTheme(
    ColorScheme scheme,
    AppAccentTokens accents,
  ) {
    // 鐜颁唬绠€绾︼細TabBar 鏈€変腑鏍囩绋嶅井鏇存贰
    return TabBarThemeData(
      dividerColor: Colors.transparent,
      indicatorColor: accents.accent,
      labelColor: scheme.onSurface,
      unselectedLabelColor: scheme.onSurface.withValues(alpha: 0.5),
      overlayColor: WidgetStatePropertyAll(accents.hoverTint),
    );
  }

  static SegmentedButtonThemeData segmentedButtonTheme(
    ColorScheme scheme,
    AppSurfaceTokens surfaces,
    AppAccentTokens accents,
    AppVisualTokens visuals,
  ) {
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 200), // 丝滑动画
        minimumSize: const WidgetStatePropertyAll(_minInteractiveSize),
        enableFeedback: false,
        // 鐜颁唬绠€绾︼細鍒嗘鎸夐挳鏇村鏉?
        padding: _pressablePadding(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          visuals,
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return accents.accentContainer;
          }
          if (states.contains(WidgetState.hovered)) {
            return surfaces.surfaceInset.withValues(alpha: 0.96);
          }
          return surfaces.surfaceInset.withValues(alpha: surfaces.panelAlpha);
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return accents.onAccent;
          }
          return scheme.onSurface;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(
              color: accents.accentFocusRing.withValues(
                alpha:
                    accents.accentFocusRing.a * visuals.buttonFocusRingOpacity,
              ),
              width: 1.4,
            );
          }
          if (states.contains(WidgetState.selected)) {
            return BorderSide(color: accents.accent.withValues(alpha: 0.52));
          }
          return BorderSide(color: surfaces.strokeSubtle);
        }),
        // 鐜颁唬绠€绾︼細鍒嗘鎸夐挳浣跨敤鏇村ぇ鍦嗚
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(surfaces.radiusXl),
          ),
        ),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected) &&
              states.contains(WidgetState.hovered)) {
            return 3;
          }
          if (states.contains(WidgetState.selected)) return 1.6;
          return 0;
        }),
        shadowColor: _resolveGlowShadow(accents, visuals),
      ),
    );
  }

  static WidgetStateProperty<EdgeInsetsGeometry> _pressablePadding(
    EdgeInsets base,
    AppVisualTokens visuals,
  ) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return EdgeInsets.fromLTRB(
          base.left,
          base.top + visuals.buttonPressOffset,
          base.right,
          base.bottom - visuals.buttonPressOffset,
        );
      }
      return base;
    });
  }

  static WidgetStateProperty<Color?> _resolveGlowShadow(
    AppAccentTokens accents,
    AppVisualTokens visuals,
  ) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return Colors.transparent;
      }
      if (states.contains(WidgetState.pressed)) {
        return accents.accentGlow.withValues(
          alpha: accents.accentGlow.a *
              visuals.buttonGlowOpacity *
              visuals.buttonPressedGlowScale,
        );
      }
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.focused)) {
        return accents.accentGlow.withValues(
          alpha: accents.accentGlow.a *
              visuals.buttonGlowOpacity *
              visuals.buttonHoverGlowScale,
        );
      }
      return accents.accentGlow.withValues(
        alpha: accents.accentGlow.a * visuals.buttonGlowOpacity,
      );
    });
  }
}
