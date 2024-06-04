import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdaptiveImage extends StatelessWidget {
  AdaptiveImage.network(String url, {super.key}) {
    if (kIsWeb) {
      _url = Uri.parse(url)
          .replace(host: 'localhost', port: 8080, scheme: 'http')
          .toString();
    } else {
      _url = url;
    }
  }

  late final String _url;

  @override
  Widget build(BuildContext context) {
    return Image.network(_url);
  }
}

/**
 * This app uses the kIsWeb constant due to runtime platform differences. The other adaptable widget changes the app to work like other web pages. Browser users expect text to be selectable.
 */