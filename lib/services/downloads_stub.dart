import 'dart:io';

/// Non-web: write the document to a temporary file and return its path.
Future<String> downloadDocument(
    String filename, String content, String mime) async {
  final dir = Directory.systemTemp;
  final file = File('${dir.path}/$filename');
  await file.writeAsString(content);
  return file.path;
}
