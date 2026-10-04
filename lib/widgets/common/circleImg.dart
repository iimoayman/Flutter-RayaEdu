import 'package:flutter/material.dart';


class CircleImage extends StatelessWidget {
  const CircleImage({
    super.key,
    required this.size,
    this.imageProvider,
    this.fallbackAsset,
    this.backgroundColor = Colors.white12,
  });

  final double size;
  final ImageProvider? imageProvider;


  final String? fallbackAsset;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageProvider == null
          ? _fallback()
          : Image(
        image: imageProvider!,
        fit: BoxFit.cover, // android:scaleType="centerCrop"
        errorBuilder: (_, __, ___) => _fallback(),
        loadingBuilder: (_, child, progress) =>
        progress == null ? child : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    if (fallbackAsset != null) {
      return Image.asset(fallbackAsset!, fit: BoxFit.cover);
    }
    return const Icon(Icons.person, color: Colors.white, size: 22);
  }
}