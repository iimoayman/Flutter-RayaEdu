import 'package:flutter/material.dart';

import 'package:rayaedu/view/EduPortalPage.dart';
import 'package:rayaedu/view/EAdvisorPage.dart';
import 'package:rayaedu/view/OnlineSessionsPage.dart';

class PortalTabSpec {
  const PortalTabSpec({
    required this.title,
    required this.contentDescription,
    required this.builder,
  });

  final String title;
  final String contentDescription;
  final WidgetBuilder builder;
}

List<PortalTabSpec> buildPortalTabs(BuildContext context) => [
  PortalTabSpec(
    title: 'المنصة',
    contentDescription: 'Edu platform tab',
    builder: (_) => const EduPortalPage(),
  ),
  PortalTabSpec(
    title: 'المرشد الالكتروني',
    contentDescription: 'E-Advisor tab',
    builder: (_) => const EAdvisorPage(),
  ),
  PortalTabSpec(
    title: 'المحاضرات الاونلاين',
    contentDescription: 'Online sessions tab',
    builder: (_) => const OnlineSessionsPage(),
  ),
];