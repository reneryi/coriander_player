import 'package:flutter/material.dart';

const nowPlayingArtworkHeroTag = 'now-playing-artwork';
const nowPlayingArtworkHeroRadius = 26.0;

Widget nowPlayingArtworkFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection direction,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final resolvedHero = (direction == HeroFlightDirection.push
      ? toHeroContext.widget
      : fromHeroContext.widget) as Hero;
  final curved = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  return FadeTransition(
    opacity: curved,
    child: resolvedHero.child,
  );
}

class NowPlayingArtworkHeroFrame extends StatelessWidget {
  const NowPlayingArtworkHeroFrame({
    super.key,
    required this.child,
    this.radius = nowPlayingArtworkHeroRadius,
  });

  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 26,
            spreadRadius: -6,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: child,
      ),
    );
  }
}
