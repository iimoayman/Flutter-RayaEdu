import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Centralized safe URL launcher utility for Raya Higher Institute app.
/// Ensures all external web links (lectures, guides, resources) are launched
/// in the device's external default browser (Chrome on Android / Safari on iOS)
/// with robust error handling and fallback mechanisms.
class UrlLauncherHelper {
  /// Official Student Guide URL
  static const String studentGuideUrl = 'https://raya.edu.eg/ar/student-guide';

  /// Launches any external URL safely outside the app.
  /// Handles missing protocols, encoding, and graceful clipboard fallbacks.
  static Future<bool> launchExternalUrl(
    BuildContext? context,
    String urlString, {
    String? fallbackTitle,
  }) async {
    final cleanUrl = urlString.trim();
    if (cleanUrl.isEmpty) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'الرابط غير متوفر حالياً',
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      }
      return false;
    }

    // Ensure valid HTTP/HTTPS URI scheme
    String formattedUrl = cleanUrl;
    if (!formattedUrl.startsWith('http://') &&
        !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }

    try {
      final uri = Uri.parse(formattedUrl);

      // Force external application mode (Chrome / Safari)
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // Fallback check with canLaunchUrl
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return true;
        }

        // Secondary fallback: Copy to clipboard
        await Clipboard.setData(ClipboardData(text: formattedUrl));
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تعذر فتح الرابط في المتصفح الخارجي، تم نسخ الرابط إلى الحافظة',
                textDirection: TextDirection.rtl,
              ),
            ),
          );
        }
        return false;
      }
      return true;
    } catch (_) {
      // Safe fallback on invalid URL formatting or missing intent handler
      try {
        await Clipboard.setData(ClipboardData(text: formattedUrl));
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تم نسخ الرابط إلى الحافظة',
                textDirection: TextDirection.rtl,
              ),
            ),
          );
        }
      } catch (_) {}
      return false;
    }
  }

  /// Launch the unified official Student Guide URL
  static Future<bool> launchStudentGuide(BuildContext? context) async {
    return launchExternalUrl(
      context,
      studentGuideUrl,
      fallbackTitle: 'دليل الطالب',
    );
  }
}
