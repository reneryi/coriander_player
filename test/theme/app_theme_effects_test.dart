import 'package:qisheng_player/app_settings.dart';
import 'package:qisheng_player/theme/app_theme.dart';
import 'package:qisheng_player/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ThemeData _buildTheme(
  UiEffectsLevel level, {
  UiVisualStyleMode visualStyleMode = UiVisualStyleMode.glass,
  WindowBackdropMode windowBackdropMode = WindowBackdropMode.auto,
}) {
  final baseScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF53A4FF),
    brightness: Brightness.dark,
  );
  return AppTheme.build(
    colorScheme: AppTheme.applyChromeSurfaces(
      baseScheme,
      visualStyleMode: visualStyleMode,
    ),
    effectsLevel: level,
    visualStyleMode: visualStyleMode,
    windowBackdropMode: windowBackdropMode,
  );
}

void main() {
  test('balanced effects profile uses adaptive blur defaults', () {
    final theme = _buildTheme(UiEffectsLevel.balanced);
    final surfaces = theme.extension<AppSurfaceTokens>();

    expect(surfaces, isNotNull);
    expect(surfaces!.effectsLevel, UiEffectsLevel.balanced);
    // balanced 妯″紡榛樿鍘嬩綆鐜荤拑妯＄硦鍜岄槾褰辨繁搴︼紝浼樺厛淇濊瘉娴佺晠搴︺€?    expect(surfaces.glassSigma, 20.0);
    expect(surfaces.shadowDepthScale, 0.86);
    expect(surfaces.backdropStrategy, AppBackdropStrategy.adaptive);
  });

  test('visual effects profile increases blur and depth', () {
    final theme = _buildTheme(UiEffectsLevel.visual);
    final surfaces = theme.extension<AppSurfaceTokens>();

    expect(surfaces, isNotNull);
    expect(surfaces!.effectsLevel, UiEffectsLevel.visual);
    // 鐜颁唬绠€绾︼細visual 妯″紡鐨?glassSigma 浠?30 澧炲埌 36
    expect(surfaces.glassSigma, 36.0);
    expect(surfaces.shadowDepthScale, 1.2);
    expect(surfaces.backdropStrategy, AppBackdropStrategy.forceBlur);
  });

  test('performance profile disables glass backdrop blur', () {
    final theme = _buildTheme(UiEffectsLevel.performance);
    final surfaces = theme.extension<AppSurfaceTokens>();

    expect(surfaces, isNotNull);
    expect(surfaces!.effectsLevel, UiEffectsLevel.performance);
    // 鐜颁唬绠€绾︼細performance 妯″紡鐨?glassSigma 浠?12 澧炲埌 16
    expect(surfaces.glassSigma, 16.0);
    expect(surfaces.shadowDepthScale, 0.72);
    expect(surfaces.backdropStrategy, AppBackdropStrategy.solid);
  });

  test('contrast visual mode exposes stronger contour tokens', () {
    final theme = _buildTheme(
      UiEffectsLevel.balanced,
      visualStyleMode: UiVisualStyleMode.contrast,
    );
    final surfaces = theme.extension<AppSurfaceTokens>();
    final visuals = theme.extension<AppVisualTokens>();

    expect(surfaces, isNotNull);
    expect(visuals, isNotNull);
    expect(visuals!.styleMode, UiVisualStyleMode.contrast);
    expect(visuals.buttonHoverGlowScale, greaterThan(1));
    expect(visuals.buttonPressedGlowScale, lessThan(1));
    expect(surfaces!.panelAlpha, greaterThanOrEqualTo(0.98));
    // 鐜颁唬绠€绾︼細contrast 妯″紡鐨?radiusXxl 浠?鈮?4 璋冩暣涓?鈮?8
    expect(surfaces.radiusXxl, lessThanOrEqualTo(28));
  });

  test('window backdrop mode changes glass token intensity', () {
    final acrylicTheme = _buildTheme(
      UiEffectsLevel.balanced,
      windowBackdropMode: WindowBackdropMode.acrylic,
    );
    final noneTheme = _buildTheme(
      UiEffectsLevel.balanced,
      windowBackdropMode: WindowBackdropMode.none,
    );

    final acrylicSurfaces = acrylicTheme.extension<AppSurfaceTokens>()!;
    final noneSurfaces = noneTheme.extension<AppSurfaceTokens>()!;
    final acrylicChrome = acrylicTheme.extension<AppChromeTokens>()!;
    final noneChrome = noneTheme.extension<AppChromeTokens>()!;

    expect(acrylicSurfaces.glassSigma, greaterThan(noneSurfaces.glassSigma));
    expect(acrylicSurfaces.glassAlpha, greaterThan(noneSurfaces.glassAlpha));
    expect(acrylicChrome.backdropBlurSigma,
        greaterThan(noneChrome.backdropBlurSigma));
  });
}
