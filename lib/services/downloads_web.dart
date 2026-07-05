import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web: trigger a real browser download via an object URL.
Future<String> downloadDocument(
    String filename, String content, String mime) async {
  final bytes = utf8.encode(content).toJS;
  final blob = web.Blob([bytes].toJS, web.BlobPropertyBag(type: mime));
  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..download = filename;
  anchor.click();
  web.URL.revokeObjectURL(url);
  return filename;
}
