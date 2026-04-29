import 'package:qisheng_player/app_paths.dart' as app_paths;
import 'package:qisheng_player/navigation_state.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

bool isNowPlayingRoute(BuildContext context) {
  try {
    return GoRouterState.of(context).uri.toString() ==
        app_paths.NOW_PLAYING_PAGE;
  } on GoError {
    return false;
  }
}

bool openNowPlayingRoute(BuildContext context) {
  if (isNowPlayingRoute(context)) return false;
  AppNavigationState.instance.openNowPlaying(context);
  return true;
}
