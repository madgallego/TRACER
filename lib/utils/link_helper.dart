import 'package:url_launcher/url_launcher.dart';

abstract class LinkHelper {
  static Future<void> openUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);

    // Safety check: verify the device can actually open the link
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }
}
