import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Flutter extension for the [String] class, providing
/// additional functionalities
/// for working with strings, launching URLs, and rendering SVG images.
extension StringExtension on String {
  /// Launches a web link using the URL launcher. This extension parses the
  /// current string as a URL and attempts to launch it. Any errors during the
  /// launch process are caught and printed to the debug console.
  Future<void> launchLink() async {
    try {
      final url = Uri.parse(this);
      await launchUrl(url);
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  Future<void> openWp() async {
    const contact = '+905525356151';
    const androidUrl =
        'whatsapp://send?phone=$contact&text=Merhaba, yardıma ihtiyacım var.';
    final iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Merhaba, yardıma ihtiyacım var.')}";

    try{if (Platform.isIOS) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      await launchUrl(Uri.parse(androidUrl));
    }}catch(e){
      rethrow;
    }
  }


}
