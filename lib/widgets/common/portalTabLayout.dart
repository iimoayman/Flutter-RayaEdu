import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'package:rayaedu/theme/app_colors.dart';
import 'package:rayaedu/widgets/common/portalPager.dart';

class PortalTabLayout extends StatefulWidget {
  const PortalTabLayout({super.key});

  @override
  State<PortalTabLayout> createState() => _PortalTabLayoutState();
}

class _PortalTabLayoutState extends State<PortalTabLayout>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  late final PageController _pageController;
  late List<PortalTabSpec> _tabs;

  // One key per tab to read its rendered rect for the pill.
  final List<GlobalKey> _tabKeys = [];

  // Key on the Stack to convert tab rects to Stack-local coords.
  final GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    _pageController = PageController();
    _tabs = [];
    _tabKeys
      ..clear()
      ..addAll(List.generate(3, (_) => GlobalKey()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabs = buildPortalTabs(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /// Returns the on-screen rect of tab [i], relative to the Stack.
  Rect? _tabRect(int i) {
    final stackCtx = _stackKey.currentContext;
    final tabCtx = _tabKeys[i].currentContext;
    if (stackCtx == null || tabCtx == null) return null;

    final stackBox = stackCtx.findRenderObject() as RenderBox?;
    final tabBox = tabCtx.findRenderObject() as RenderBox?;
    if (stackBox == null || tabBox == null) return null;
    if (!stackBox.hasSize || !tabBox.hasSize) return null;

    final topLeft = tabBox.localToGlobal(Offset.zero, ancestor: stackBox);
    return topLeft & tabBox.size;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── TabBar + custom sliding pill indicator ─────────────
          SizedBox(
            height: 42,
            child: Stack(
              key: _stackKey,
              children: [
                // 1) TabBar — scrollable so long Arabic fits
                Positioned.fill(
                  child: TabBar(
                    controller: _controller,

                    // ── content-sized tabs + horizontal scroll ──
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,

                    indicatorColor: Colors.transparent,
                    dividerColor: AppColors.mainC.withOpacity(0.15),
                    overlayColor: WidgetStateProperty.all(
                      AppColors.mainC.withOpacity(0.06),
                    ),

                    // ── FONT SIZE lives here ────────────────────
                    labelColor: AppColors.mainC,
                    unselectedLabelColor: AppColors.mainC,
                    labelStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,          // ← selected tab size
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,          // ← unselected tab size
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                    ),

                    tabs: [
                      for (int i = 0; i < _tabs.length; i++)
                        Tab(
                          key: _tabKeys[i],
                          height: 42,
                          child: Padding(
                            // room for long Arabic text
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                            child: Center(
                              child: Text(
                                _tabs[i].title,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                    ],

                    onTap: (i) {
                      _pageController.animateToPage(
                        i,
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                      );
                    },
                  ),
                ),

                // 2) Custom pill — reads real tab positions (RTL-safe)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _controller.animation!,
                      builder: (context, _) {
                        final pos = _controller.animation!.value;

                        final fromIndex =
                        pos.floor().clamp(0, _tabs.length - 1);
                        final toIndex =
                        (fromIndex + 1).clamp(0, _tabs.length - 1);
                        final t = (pos - fromIndex).clamp(0.0, 1.0);

                        final fromRect = _tabRect(fromIndex);
                        final toRect = _tabRect(toIndex);
                        if (fromRect == null || toRect == null) {
                          return const SizedBox.shrink();
                        }

                        // interpolate between the two real tab rects
                        final left = lerpDouble(
                          fromRect.left,
                          toRect.left,
                          t,
                        ) ??
                            0;
                        final width = lerpDouble(
                          fromRect.width,
                          toRect.width,
                          t,
                        ) ??
                            0;

                        // stretch mid-swipe
                        final distance =
                        (pos - pos.roundToDouble()).abs();
                        final stretch = 1.0 + distance * 0.4;

                        final pillWidth = width * 0.7 * stretch;
                        final pillLeft = left + (width - pillWidth) / 2;

                        return Stack(
                          children: [
                            Positioned(
                              left: pillLeft,
                              bottom: 0,
                              width: pillWidth,
                              height: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.orange,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Page content ───────────────────────────────────────
          Expanded(
            child: Container(
              color: AppColors.white,
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => _controller.animateTo(i),
                children: [
                  for (final spec in _tabs) spec.builder(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}