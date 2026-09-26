import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class RemoteAvatar extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double radius;

  const RemoteAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cacheDimension = (radius * 2 * MediaQuery.devicePixelRatioOf(context))
        .round();
    final initials = name.trim().isEmpty
        ? '?'
        : name
              .trim()
              .split(RegExp(r'\s+'))
              .map((part) => part[0])
              .take(2)
              .join()
              .toUpperCase();

    return Semantics(
      image: true,
      label: l10n.photoOf(name),
      child: CircleAvatar(
        radius: radius,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: radius * 2,
            height: radius * 2,
            memCacheWidth: cacheDimension,
            memCacheHeight: cacheDimension,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) => Center(
              child: Text(
                initials,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
