import 'package:flutter/material.dart';
import 'package:rayaedu/theme/app_colors.dart';
import 'package:rayaedu/model/network/auth.dart';
import 'package:rayaedu/router/app_router.dart';
import 'package:go_router/go_router.dart';
class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _LoadingState();
}

class _LoadingState extends State<SignIn> {
  final TextEditingController userCodeController = TextEditingController();
  final TextEditingController nationalId = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isSignIn = false;

  @override
  void dispose() {
    userCodeController.dispose();
    nationalId.dispose();
    super.dispose();
  }

  void _showMessage({
    required String title,
    required String message,
    bool success = true,
  }) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error_outline,
              color: success ? AppColors.mainC : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 18),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'حسناً',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.mainC,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: SizedBox(
          width: 55,
          height: 55,
          child: CircularProgressIndicator(
            color: AppColors.mainC,
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }

  // ---------- Login flow ----------
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    final code = userCodeController.text.trim();
    final id = nationalId.text.trim();

    if (code.isEmpty || id.isEmpty) {
      _showMessage(
        title: 'تنبيه',
        message: 'من فضلك أدخل كود الطالب والرقم القومي',
        success: false,
      );
      return;
    }
    if (code.length != 7) {
      _showMessage(
        title: 'تنبيه',
        message: 'كود الطالب يجب أن يتكون من 7 أرقام',
        success: false,
      );
      return;
    }
    if (id.length != 14) {
      _showMessage(
        title: 'تنبيه',
        message: 'الرقم القومي يجب أن يتكون من 14 رقم',
        success: false,
      );
      return;
    }

    setState(() => _isSignIn = true);
    _showLoadingDialog();

    try {
      final result = await _authService.login(
        username: code,
        password: id,
      );

      if (!mounted) return;

      // close the loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      // ── show success, navigate AFTER the user taps "حسناً" ──
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: AppColors.mainC),
              SizedBox(width: 8),
              Text('تم بنجاح',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 18)),
            ],
          ),
          content: const Text(
            'سعداء بوجودك معنا 👋\nتم تسجيل الدخول بنجاح.',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();       // close dialog
                context.go('/portal');          // then navigate
              },
              child: const Text(
                'حسناً',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.mainC,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );

      debugPrint('Login response: $result');
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();   // close loader
      _showMessage(
        title: 'فشل تسجيل الدخول',
        message: e.toString().replaceFirst('Exception: ', ''),
        success: false,
      );
    } finally {
      if (mounted) setState(() => _isSignIn = false);
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005E39),
      body: Stack(
        children: [
          // ----- Header -----
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 230,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/imgs/logo_b.png',
                  width: 85,
                  height: 85,
                ),
                Container(
                  width: 1,
                  height: 85,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'رواد',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'التعليم الالكتروني',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ----- Form card -----
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'سعداء بوجودك معنا👋',
                      style: TextStyle(
                        color: AppColors.mainC,
                        fontSize: 23,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Container(
                      height: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      color: AppColors.mainC,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'كود الطالب :',
                      style: TextStyle(
                        color: AppColors.mainC,
                        fontSize: 16,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: userCodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 7,
                      enabled: !_isSignIn,
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'الرقم القومي',
                      style: TextStyle(
                        color: AppColors.mainC,
                        fontSize: 16,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: nationalId,
                      keyboardType: TextInputType.number,
                      maxLength: 14,
                      enabled: !_isSignIn,
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainC,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _isSignIn ? null : _handleLogin,
                        child: _isSignIn
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                            : const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Cairo',
                          ),
                          children: [
                            TextSpan(
                              text:
                              'بمجرد تسجيل دخولك فأنت توافق علي ',
                            ),
                            TextSpan(
                              text: 'الشروط والأحكام',
                              style: TextStyle(color: AppColors.mainC),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}