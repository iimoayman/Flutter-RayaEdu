import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:rayaedu/model/data/myData.dart';
import 'package:rayaedu/model/network/auth.dart';
import 'package:rayaedu/theme/appSizes.dart';

class StudentAvatar extends StatelessWidget {
  const StudentAvatar({
    super.key,
    this.data,                                         // ← now nullable
    this.size = AppSizes.mainImgProfile,
    this.fallbackAsset = 'assets/imgs/profile.png',
    this.onTap,
  });

  final MyData? data;                                  // ← now nullable
  final double size;
  final String fallbackAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget fallback = Image.asset(
      fallbackAsset,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: size,
        height: size,
        color: Colors.white24,
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );

    // If we don't have student data yet → just show the fallback.
    final photoUrl = data?.photoUrl ?? '';
    if (photoUrl.isEmpty) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: size,
          height: size,
          child: ClipOval(child: fallback),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: FutureBuilder<String>(
            future: AuthService().buildCookieHeader(),
            builder: (context, snap) {
              if (!snap.hasData) return fallback;

              final cookieHeader = snap.data ?? '';
              final imageUrl = 'https://student.rayaedu.org$photoUrl';

              return Stack(
                fit: StackFit.expand,
                children: [
                  fallback,
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    httpHeaders: cookieHeader.isEmpty
                        ? const {}
                        : {'Cookie': cookieHeader},
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 200),
                    placeholder: (_, __) => const SizedBox.shrink(),
                    errorWidget: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}