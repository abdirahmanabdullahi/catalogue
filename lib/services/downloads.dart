import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/repository.dart';
import '../theme.dart';
import 'downloads_stub.dart' if (dart.library.js_interop) 'downloads_web.dart'
    as impl;

/// Builds catalogue / spec documents from real product data and downloads
/// them (a genuine file on web; a temp file on desktop). Central to the
/// digital-catalogue proposal: replacing heavy printed catalogues.
class Downloads {
  static Future<void> productSpecSheet(
      BuildContext context, ProductFamily product) async {
    final repo = CatalogueRepository.instance;
    final group = repo.groupByTypeCode(product.typeCode) ??
        repo.groupByUrlname(product.urlName);
    final rows = StringBuffer();
    if (group != null) {
      for (final t in group.technicaldata) {
        rows.writeln(
            '<tr><td>${t.label}</td><td>${t.data} ${t.additionalData}</td></tr>');
      }
    }
    final html = _wrap('${product.title} — Product specifications', '''
      <h1>${product.title}</h1>
      <p class="code">Type code: ${product.typeCode}</p>
      <p>${product.description}</p>
      ${product.sizable ? '<span class="tag">Sizeable</span>' : ''}
      <h2>Technical data</h2>
      <table>${rows.isEmpty ? '<tr><td colspan="2">See Grundfos Product Center for full technical data.</td></tr>' : rows}</table>
    ''');
    await _run(context, '${_slug(product.title)}-specs.html', html,
        'Product specs downloaded');
  }

  static Future<void> productCatalogue(
      BuildContext context, ProductFamily product) async {
    final html = _wrap('${product.title} — Catalogue', '''
      <h1>${product.title}</h1>
      <p class="code">Grundfos digital catalogue extract</p>
      <p>${product.description}</p>
      <h2>Overview</h2>
      <p>This catalogue page is generated from the Grundfos Product Center
      digital catalogue — the modern replacement for printed product books.</p>
    ''');
    await _run(context, '${_slug(product.title)}-catalogue.html', html,
        'Catalogue downloaded');
  }

  static Future<void> fullCatalogue(BuildContext context) async {
    final repo = CatalogueRepository.instance;
    final items = StringBuffer();
    for (final p in repo.products) {
      items.writeln(
          '<tr><td>${p.title}</td><td>${p.typeCode}</td><td>${p.sizable ? 'Yes' : '—'}</td></tr>');
    }
    final html = _wrap('Grundfos Digital Catalogue', '''
      <h1>Grundfos Digital Catalogue</h1>
      <p>${repo.products.length} product families · ${repo.categories.length}
      categories · ${repo.applicationAreas.length} application areas</p>
      <h2>Products A–Z</h2>
      <table>
        <tr><th>Product</th><th>Type code</th><th>Sizeable</th></tr>
        $items
      </table>
    ''');
    await _run(context, 'grundfos-digital-catalogue.html', html,
        'Full catalogue downloaded');
  }

  static Future<void> _run(BuildContext context, String filename,
      String content, String successMsg) async {
    try {
      final where = await impl.downloadDocument(filename, content, 'text/html');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: GfColors.green,
        content: Text('$successMsg · $where'),
      ));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: GfColors.red,
        content: Text('Download failed: $e'),
      ));
    }
  }

  static String _slug(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'(^-+|-+$)'), '');

  static String _wrap(String title, String body) => '''<!doctype html>
<html><head><meta charset="utf-8"><title>$title</title>
<style>
  body{font-family:Arial,Helvetica,sans-serif;color:#0C1217;max-width:720px;
       margin:40px auto;padding:0 20px;line-height:1.5}
  h1{color:#11497B;font-size:28px;margin-bottom:4px}
  h2{color:#126AF3;font-size:18px;margin-top:28px}
  .code{color:#65717B;font-size:13px}
  .tag{display:inline-block;background:#F3F5F7;border:1px solid #DCE0E4;
       border-radius:12px;padding:2px 10px;font-size:12px}
  table{border-collapse:collapse;width:100%;margin-top:8px}
  td,th{border:1px solid #DCE0E4;padding:8px 10px;text-align:left;font-size:14px}
  th{background:#F3F5F7}
  header{border-bottom:2px solid #126AF3;padding-bottom:10px;margin-bottom:20px;
         font-weight:bold;color:#11497B}
</style></head><body>
<header>GRUNDFOS · Digital Catalogue</header>
$body
<p style="margin-top:40px;color:#9CA9B5;font-size:12px">
Generated from the Grundfos Product Center digital catalogue.</p>
</body></html>''';
}
