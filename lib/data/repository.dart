import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Loads and indexes the catalogue data scraped from
/// qiantao (catalogue source) (assets/data/*.json).
///
/// The bundled catalogue is read-only; pumps the user adds, updates or
/// deletes are stored locally (shared_preferences) and merged on load.
class CatalogueRepository extends ChangeNotifier {
  CatalogueRepository._();
  static final CatalogueRepository instance = CatalogueRepository._();

  static const _prefsKey = 'pump_customizations';

  late final List<CategoryArea> categories;
  late final List<SubCategory> subcategories;
  late final List<ApplicationArea> applicationAreas;
  late final List<CatalogueApplication> catalogueApplications;
  late final List<ProductGroup> groups;
  late final List<SizingQuestion> sizingQuestions;

  late final List<ProductFamily> _baseProducts;
  final List<ProductFamily> _added = [];
  final Map<String, ProductFamily> _updated = {}; // original typeCode → new
  final Set<String> _deleted = {};

  late final Map<String, ProductGroup> _groupsByUrl;
  late final Map<String, ProductGroup> _groupsByTypeCode;

  bool _loaded = false;
  SharedPreferences? _prefs;

  /// Effective product list: bundled catalogue minus deletions, with
  /// updates applied, plus user-added pumps — sorted A-Z like the site.
  List<ProductFamily> get products {
    final list = <ProductFamily>[
      for (final p in _baseProducts)
        if (!_deleted.contains(p.typeCode)) _updated[p.typeCode] ?? p,
      ..._added.where((p) => !_deleted.contains(p.typeCode)),
    ];
    list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return list;
  }

  Future<void> load() async {
    if (_loaded) return;
    final cat = jsonDecode(await rootBundle.loadString('assets/data/catalogue.json'))
        as Map<String, dynamic>;
    categories = (cat['categories'] as List)
        .map((e) => CategoryArea.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    subcategories = (cat['subcategories'] as List)
        .map((e) => SubCategory.fromJson(e as Map<String, dynamic>))
        .toList();
    applicationAreas = (cat['applicationAreas'] as List)
        .map((e) => ApplicationArea.fromJson(e as Map<String, dynamic>))
        .toList();
    catalogueApplications = (cat['catalogueApplications'] as List)
        .map((e) => CatalogueApplication.fromJson(e as Map<String, dynamic>))
        .toList();
    _baseProducts = (cat['products'] as List)
        .map((e) => ProductFamily.fromJson(e as Map<String, dynamic>))
        .toList();
    groups = (cat['groups'] as List)
        .map((e) => ProductGroup.fromJson(e as Map<String, dynamic>))
        .toList();
    _groupsByUrl = {for (final g in groups) g.urlname: g};
    _groupsByTypeCode = {for (final g in groups) g.typecode: g};

    final qc = jsonDecode(await rootBundle.loadString('assets/data/sizing_qc.json'))
        as Map<String, dynamic>;
    sizingQuestions = (qc['groups'] as List)
        .expand((g) => (g['questions'] as List? ?? const []))
        .map((q) => SizingQuestion.fromJson(q as Map<String, dynamic>))
        .toList();

    try {
      _prefs = await SharedPreferences.getInstance();
      final raw = _prefs?.getString(_prefsKey);
      if (raw != null) {
        final c = jsonDecode(raw) as Map<String, dynamic>;
        _added.addAll((c['added'] as List? ?? const [])
            .map((e) => ProductFamily.fromJson(e as Map<String, dynamic>)));
        (c['updated'] as Map<String, dynamic>? ?? const {}).forEach((k, v) {
          _updated[k] = ProductFamily.fromJson(v as Map<String, dynamic>);
        });
        _deleted.addAll(List<String>.from(c['deleted'] ?? const []));
      }
    } catch (_) {
      // Corrupt or unavailable local storage — fall back to bundled data.
    }

    _loaded = true;
  }

  Future<void> _persist() async {
    final data = jsonEncode({
      'added': [for (final p in _added) p.toJson()],
      'updated': _updated.map((k, v) => MapEntry(k, v.toJson())),
      'deleted': _deleted.toList(),
    });
    await _prefs?.setString(_prefsKey, data);
  }

  ProductFamily? productByTypeCode(String typeCode) {
    if (_deleted.contains(typeCode)) return null;
    for (final p in products) {
      if (p.typeCode == typeCode) return p;
    }
    return null;
  }

  bool typeCodeExists(String typeCode) =>
      products.any((p) => p.typeCode == typeCode);

  /// True for pumps created in the app (as opposed to bundled ones).
  bool isUserAdded(String typeCode) =>
      _added.any((p) => p.typeCode == typeCode);

  Future<void> addPump(ProductFamily pump) async {
    _deleted.remove(pump.typeCode);
    _added.add(pump);
    await _persist();
    notifyListeners();
  }

  Future<void> updatePump(String originalTypeCode, ProductFamily pump) async {
    final i = _added.indexWhere((p) => p.typeCode == originalTypeCode);
    if (i >= 0) {
      _added[i] = pump;
    } else {
      _updated[originalTypeCode] = pump;
    }
    await _persist();
    notifyListeners();
  }

  Future<void> deletePump(String typeCode) async {
    _added.removeWhere((p) => p.typeCode == typeCode);
    _updated.remove(typeCode);
    _deleted.add(typeCode);
    RecentlyViewed.instance.removeByTypeCode(typeCode);
    CompareList.instance.removeByTypeCode(typeCode);
    await _persist();
    notifyListeners();
  }

  ProductGroup? groupByUrlname(String urlname) => _groupsByUrl[urlname];
  ProductGroup? groupByTypeCode(String typeCode) => _groupsByTypeCode[typeCode];

  List<SubCategory> subcategoriesForArea(String areaUrlName) => subcategories
      .where((s) => s.area == areaUrlName || s.urlname == areaUrlName)
      .toList()
    ..sort((a, b) => a.sortorder.compareTo(b.sortorder));

  List<ProductGroup> groupsForSubcategory(SubCategory sc) => sc.groups
      .map(groupByUrlname)
      .whereType<ProductGroup>()
      .toList()
    ..sort((a, b) => a.displayname.toLowerCase().compareTo(b.displayname.toLowerCase()));

  /// Letters that actually occur in the Products A-Z list, in order.
  List<String> get productLetters {
    final seen = <String>{};
    return [
      for (final p in products)
        if (seen.add(p.letter)) p.letter,
    ];
  }
}

/// User session for the app's front-door auth (demo — no backend).
class Session extends ChangeNotifier {
  Session._();
  static final Session instance = Session._();

  static const _key = 'session_user';

  String? email;
  String? name;
  bool get signedIn => email != null || _guest;
  bool _guest = false;
  bool get isGuest => _guest;

  String get displayName =>
      name ?? email?.split('@').first ?? (_guest ? 'Guest' : '');

  SharedPreferences? _prefs;

  Future<void> restore() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final raw = _prefs?.getString(_key);
      if (raw != null) {
        final m = jsonDecode(raw) as Map<String, dynamic>;
        email = m['email'] as String?;
        name = m['name'] as String?;
        _guest = (m['guest'] as bool?) ?? false;
      }
    } catch (_) {}
  }

  Future<void> signIn(String email, String? name) async {
    this.email = email;
    this.name = name;
    _guest = false;
    await _persist();
    notifyListeners();
  }

  void continueAsGuest() {
    _guest = true;
    email = null;
    name = null;
    _persist();
    notifyListeners();
  }

  Future<void> signOut() async {
    email = null;
    name = null;
    _guest = false;
    await _prefs?.remove(_key);
    notifyListeners();
  }

  Future<void> _persist() async {
    await _prefs?.setString(
        _key, jsonEncode({'email': email, 'name': name, 'guest': _guest}));
  }
}

/// "Recently viewed products" — mirrors the site's header touchpoint.
class RecentlyViewed extends ChangeNotifier {
  RecentlyViewed._();
  static final RecentlyViewed instance = RecentlyViewed._();

  final List<ProductFamily> items = [];

  void add(ProductFamily p) {
    items.removeWhere((e) => e.typeCode == p.typeCode);
    items.insert(0, p);
    if (items.length > 20) items.removeLast();
    notifyListeners();
  }

  void removeByTypeCode(String typeCode) {
    items.removeWhere((e) => e.typeCode == typeCode);
    notifyListeners();
  }
}

/// "Product Compare Variants" — mirrors the site's compare touchpoint.
class CompareList extends ChangeNotifier {
  CompareList._();
  static final CompareList instance = CompareList._();

  final List<ProductFamily> items = [];

  bool contains(ProductFamily p) => items.any((e) => e.typeCode == p.typeCode);

  void toggle(ProductFamily p) {
    if (contains(p)) {
      items.removeWhere((e) => e.typeCode == p.typeCode);
    } else {
      items.add(p);
    }
    notifyListeners();
  }

  void remove(ProductFamily p) {
    items.removeWhere((e) => e.typeCode == p.typeCode);
    notifyListeners();
  }

  void removeByTypeCode(String typeCode) {
    items.removeWhere((e) => e.typeCode == typeCode);
    notifyListeners();
  }
}
