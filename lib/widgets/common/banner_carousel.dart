import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:rayaedu/model/data/order.dart';

/// Mirrors the `NewsVp` ViewPager2 + the auto-scroll logic in EduPortal.kt.
///
/// Behaviour:
///   • Auto-advances every [interval] (default: 4 s, matching Kotlin).
///   • User can swipe manually (isUserInputEnabled = true).
///   • Tapping a banner calls [onTap].
///   • Loading / error placeholders mirror the placeholder banners in Kotlin.
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    required this.banners,
    required this.onTap,
    this.height = 100,
    this.interval = const Duration(seconds: 4),
  });

  final List<Order> banners;
  final ValueChanged<Order> onTap;
  final double height;
  final Duration interval;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _controller = PageController();
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _restartAutoScroll();
  }

  @override
  void didUpdateWidget(covariant BannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Mirror `setupBannerViewPagerWithOrders()` being called again after a
    // refresh — restart the timer whenever the banner list changes.
    if (oldWidget.banners.length != widget.banners.length) {
      _restartAutoScroll();
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Mirrors Kotlin's `startAutoScroll(viewPager, size)`.
  void _restartAutoScroll() {
    _autoScrollTimer?.cancel();
    _currentPage = 0;

    if (widget.banners.length <= 1) return;

    _autoScrollTimer = Timer.periodic(widget.interval, (_) {
      if (!mounted) return;
      _currentPage = (_currentPage + 1) % widget.banners.length;

      if (_controller.hasClients) {
        // Mirrors `viewPager.setCurrentItem(page, true)` (smooth scroll).
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mirrors the empty / placeholder case in `getPlaceholderOrders()`.
    if (widget.banners.isEmpty) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: ClipRRect(
        // Mirrors `android:clipToOutline="true"` + `vp_bg` rounding.
        borderRadius: BorderRadius.circular(12),
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.banners.length,
          physics: const BouncingScrollPhysics(),
          // Mirrors `isUserInputEnabled = true`.
          onPageChanged: (i) => _currentPage = i,
          itemBuilder: (context, i) {
            final order = widget.banners[i];

            return GestureDetector(
              onTap: () => widget.onTap(order),
              child: Container(
                color: Colors.black12,
                child: _buildBannerImage(order),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBannerImage(Order order) {
    // Kotlin's placeholder banners use `img = "null"` — mirror that.
    final img = order.img.trim();
    if (img.isEmpty || img == 'null') {
      return const Center(
        child: Icon(
          Icons.image_outlined,
          color: Colors.white54,
          size: 40,
        ),
      );
    }

    final url = img.startsWith('http')
        ? img
        : 'https://student.rayaedu.org${img.startsWith('/') ? '' : '/'}$img';

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) => const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white70,
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (_, __, ___) => const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.white54,
          size: 40,
        ),
      ),
    );
  }
}