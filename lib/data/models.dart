/// Data models mirroring the JSON scraped from qiantao (catalogue source).
library;

class CategoryArea {
  final String code, title, description, urlName;
  final int sortOrder;
  final String? image;

  CategoryArea.fromJson(Map<String, dynamic> j)
      : code = j['code'] as String,
        title = j['title'] as String,
        description = (j['description'] ?? '') as String,
        urlName = j['urlName'] as String,
        sortOrder = (j['sortOrder'] ?? 999) as int,
        image = j['image'] as String?;
}

class SubCategory {
  final String code, title, description, urlname;
  final int sortorder;
  final String? image;
  final String? area; // parent category area urlName; null = own top-level page
  final List<String> groups; // product group urlnames

  SubCategory.fromJson(Map<String, dynamic> j)
      : code = j['code'] as String,
        title = j['title'] as String,
        description = (j['description'] ?? '') as String,
        urlname = j['urlname'] as String,
        sortorder = (j['sortorder'] ?? 999) as int,
        image = j['image'] as String?,
        area = j['area'] as String?,
        groups = List<String>.from(j['groups'] ?? const []);
}

class SubApplication {
  final String typecode, name, urlname, description;
  final bool sizable;

  SubApplication.fromJson(Map<String, dynamic> j)
      : typecode = j['typecode'] as String,
        name = j['name'] as String,
        urlname = j['urlname'] as String,
        description = (j['description'] ?? '') as String,
        sizable = (j['sizable'] ?? false) as bool;
}

class ApplicationArea {
  final String typecode, name, urlname, description;
  final bool sizable;
  final String? image;
  final List<SubApplication> applications;

  ApplicationArea.fromJson(Map<String, dynamic> j)
      : typecode = j['typecode'] as String,
        name = j['name'] as String,
        urlname = j['urlname'] as String,
        description = (j['description'] ?? '') as String,
        sizable = (j['sizable'] ?? false) as bool,
        image = j['image'] as String?,
        applications = (j['applications'] as List? ?? const [])
            .map((e) => SubApplication.fromJson(e as Map<String, dynamic>))
            .toList();
}

class CatalogueApplication {
  final String typecode, name, urlname, description;
  final bool sizable;
  final String? icon;

  CatalogueApplication.fromJson(Map<String, dynamic> j)
      : typecode = j['typecode'] as String,
        name = j['name'] as String,
        urlname = j['urlname'] as String,
        description = (j['description'] ?? '') as String,
        sizable = (j['sizable'] ?? false) as bool,
        icon = j['icon'] as String?;
}

class ProductFamily {
  final String letter, title, urlName, typeCode, description;
  final bool sizable, isDiscontinued;
  final String? image;

  ProductFamily({
    required this.letter,
    required this.title,
    required this.urlName,
    required this.typeCode,
    required this.description,
    this.sizable = false,
    this.isDiscontinued = false,
    this.image,
  });

  Map<String, dynamic> toJson() => {
        'letter': letter,
        'title': title,
        'urlName': urlName,
        'typeCode': typeCode,
        'description': description,
        'sizable': sizable,
        'isDiscontinued': isDiscontinued,
        'image': image,
      };

  ProductFamily.fromJson(Map<String, dynamic> j)
      : letter = j['letter'] as String,
        title = j['title'] as String,
        urlName = j['urlName'] as String,
        typeCode = j['typeCode'] as String,
        description = (j['description'] ?? '') as String,
        sizable = (j['sizable'] ?? false) as bool,
        isDiscontinued = (j['isDiscontinued'] ?? false) as bool,
        image = j['image'] as String?;
}

class TechnicalDataEntry {
  final String label, data, additionalData;

  TechnicalDataEntry.fromJson(Map<String, dynamic> j)
      : label = (j['label'] ?? j['key'] ?? '') as String,
        data = (j['data'] ?? '') as String,
        additionalData = (j['additionaldata'] ?? '') as String;
}

class ProductGroup {
  final String typecode, displayname, urlname, description;
  final int productcount;
  final bool sizable, isleaf;
  final List<String> applications; // application urlnames
  final List<String> subcategories; // subcategory urlnames
  final List<TechnicalDataEntry> technicaldata;
  final String? image;

  ProductGroup.fromJson(Map<String, dynamic> j)
      : typecode = j['typecode'] as String,
        displayname = j['displayname'] as String,
        urlname = j['urlname'] as String,
        description = (j['description'] ?? '') as String,
        productcount = (j['productcount'] ?? 0) as int,
        sizable = (j['sizable'] ?? false) as bool,
        isleaf = (j['isleaf'] ?? false) as bool,
        applications = List<String>.from(j['applications'] ?? const []),
        subcategories = List<String>.from(j['subcategories'] ?? const []),
        technicaldata = (j['technicaldata'] as List? ?? const [])
            .map((e) => TechnicalDataEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        image = j['image'] as String?;
}

/// One question of the site's sizing quick-config (`.sizing-qc.json`).
class SizingQuestion {
  final String label, text;
  final List<String> options;

  SizingQuestion.fromJson(Map<String, dynamic> j)
      : label = j['label'] as String,
        text = (j['text'] ?? '') as String,
        options = (j['options'] as List? ?? const [])
            .map((o) => (o['value'] ?? '') as String)
            .where((v) => v.isNotEmpty)
            .toList();
}
