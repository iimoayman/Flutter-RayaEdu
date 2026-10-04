import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'package:rayaedu/widgets/common/mainDrawer.dart';
import 'portal_screen.dart';


class PortalScaffold extends StatefulWidget {
  const PortalScaffold({super.key});

  static final GlobalKey<ScaffoldState> scaffoldKey =
  GlobalKey<ScaffoldState>();

  static ScaffoldState? of(BuildContext context) => scaffoldKey.currentState;

  @override
  State<PortalScaffold> createState() => _PortalScaffoldState();
}

class _PortalScaffoldState extends State<PortalScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: PortalScaffold.scaffoldKey,

      backgroundColor: AppColors.mainC,

      endDrawer: const MainDrawer(),

      body: const PortalScreen(),
    );
  }
}