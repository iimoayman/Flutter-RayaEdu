import 'package:flutter/material.dart';
import 'package:rayaedu/model/data/myData.dart';
import 'package:rayaedu/widgets/common/portalTabLayout.dart';
import 'package:rayaedu/widgets/common/portalTopBar.dart';
import 'portalScafold.dart';
import 'package:rayaedu/model/network/studentService.dart';
class PortalScreen extends StatefulWidget {
  const PortalScreen({super.key});

  @override
  State<PortalScreen> createState() => _PortalScreenState();
}

class _PortalScreenState extends State<PortalScreen> {
  MyData? _student;
  int _unread = 3;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    try {
      final data = await StudentService().fetch();
      if (!mounted) return;
      setState(() => _student = data);
    } catch (e) {
      debugPrint('Student load error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PortalTopBar(
              onOpenDrawer: () =>
                  PortalScaffold.of(context)?.openEndDrawer(),
              onProfileTap: () {/* /digitalId */},
              onNotificationTap: () {/* /notifications */},
              student: _student,            // ← was profileImage
              unreadCount: _unread,
            ),

            const SizedBox(height: 10),

            const Expanded(child: PortalTabLayout()),
          ],
        ),
      ),
    );
  }
}