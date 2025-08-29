import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class PaletteColors {
  final Color? dominant;
  final Color? vibrant;
  final Color? lightVibrant;
  final Color? darkVibrant;
  final Color? muted;
  final Color? lightMuted;
  final Color? darkMuted;
  final Color? brightest; // highest luminance from sampled colors
  final Color? darkest; // lowest luminance from sampled colors

  const PaletteColors({
    this.dominant,
    this.vibrant,
    this.lightVibrant,
    this.darkVibrant,
    this.muted,
    this.lightMuted,
    this.darkMuted,
    this.brightest,
    this.darkest,
  });
}

/// Global extractor you can call from anywhere:
class ColorPicker {
  ColorPicker._();
  static final ColorPicker instance = ColorPicker._();

  // simple cache keyed by string (use image url or a custom key)
  final Map<String, PaletteColors> _cache = {};

  /// Extract palette from an ImageProvider (or use fromUrl which caches by url).
  Future<PaletteColors> fromImageProvider(
    ImageProvider provider, {
    String? cacheKey,
    Size size = const Size(200, 100),
    int maximumColorCount = 20,
  }) async {
    final key = cacheKey ?? provider.hashCode.toString();
    if (_cache.containsKey(key)) return _cache[key]!;

    final palette = await PaletteGenerator.fromImageProvider(
      provider,
      size: size,
      maximumColorCount: maximumColorCount,
    );

    // choose brightest/darkest by computeLuminance over sampled colors
    Color? brightest;
    Color? darkest;
    final sampled = palette.colors.toList();
    if (sampled.isNotEmpty) {
      sampled.sort(
        (a, b) => a.computeLuminance().compareTo(b.computeLuminance()),
      );
      darkest = sampled.first;
      brightest = sampled.last;
    }

    final result = PaletteColors(
      dominant: palette.dominantColor?.color,
      vibrant: palette.vibrantColor?.color,
      lightVibrant: palette.lightVibrantColor?.color,
      darkVibrant: palette.darkVibrantColor?.color,
      muted: palette.mutedColor?.color,
      lightMuted: palette.lightMutedColor?.color,
      darkMuted: palette.darkMutedColor?.color,
      brightest: brightest,
      darkest: darkest,
    );

    _cache[key] = result;
    return result;
  }

  /// Convenience: extract from a network image URL (caches by URL)
  Future<PaletteColors> fromUrl(
    String url, {
    Size size = const Size(200, 100),
    int maximumColorCount = 20,
  }) => fromImageProvider(
    NetworkImage(url),
    cacheKey: url,
    size: size,
    maximumColorCount: maximumColorCount,
  );

  /// Clear cache (optional)
  void clearCache([String? key]) {
    if (key == null) {
      _cache.clear();
    } else {
      _cache.remove(key);
    }
  }
}
