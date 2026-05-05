import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github/github.dart';
import 'package:go_router/go_router.dart';
import 'package:qisheng_player/app_preference.dart';
import 'package:qisheng_player/page/settings_page/check_update.dart';
import 'package:qisheng_player/utils.dart';

void main() {
  testWidgets('StartupUpdatePrompt shows dialog from above router child', (
    tester,
  ) async {
    AppPreference.instance.ignoredUpdateTag = null;
    final router = GoRouter(
      navigatorKey: ROUTER_KEY,
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: Text('home'),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) => StartupUpdatePrompt(
          checkForRelease: () async => Release(
            tagName: 'v9.9.9',
            name: 'Qisheng Player v9.9.9',
            body: 'test release',
          ),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Qisheng Player v9.9.9'), findsOneWidget);
    expect(find.text('获取更新'), findsOneWidget);
  });
}
