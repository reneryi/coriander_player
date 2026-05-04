import 'package:qisheng_player/library/audio_library.dart';

const artistArtworkHeroTagPrefix = 'artist-artwork';

String? artistArtworkHeroTag(Artist artist) {
  if (artist.works.isEmpty) return null;

  final firstPath = artist.works.first.path;
  if (firstPath.isEmpty) return null;

  return '$artistArtworkHeroTagPrefix:${artist.name}:$firstPath';
}
