// Renders app screens to PNG for visual comparison against the website.
// Run: flutter test --update-goldens test/screenshots_test.dart
// Output: test/goldens/*.png
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:catalogue/data/repository.dart';
import 'package:catalogue/screens/ai_assistant_screen.dart';
import 'package:catalogue/screens/auth_screen.dart';
import 'package:catalogue/screens/categories_screen.dart';
import 'package:catalogue/screens/contact_form_screen.dart';
import 'package:catalogue/screens/home_screen.dart';
import 'package:catalogue/screens/products_screen.dart';
import 'package:catalogue/screens/pump_form_screen.dart';
import 'package:catalogue/screens/tools_screen.dart';
import 'package:catalogue/theme.dart';
import 'package:catalogue/widgets/gf_scaffold.dart';

Future<void> _loadFonts() async {
  const fonts = {
    'Qiantao': [
      'assets/fonts/QiantaoTheSans-SemiLight.ttf',
      'assets/fonts/QiantaoTheSans-Regular.ttf',
      'assets/fonts/QiantaoTheSans-Bold.ttf',
    ],
    'Qiantao-Extd': ['assets/fonts/QiantaoTheSans-ExtdBold.ttf'],
  };
  for (final entry in fonts.entries) {
    final loader = FontLoader(entry.key);
    for (final path in entry.value) {
      loader.addFont(rootBundle.load(path));
    }
    await loader.load();
  }
}

Future<void> _precacheImages(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate().toList()) {
      final image = element.widget as Image;
      try {
        await precacheImage(image.image, element);
      } catch (_) {}
    }
    for (final element
        in find.byType(DecoratedBox).evaluate().toList()) {
      final decoration =
          (element.widget as DecoratedBox).decoration;
      if (decoration is BoxDecoration && decoration.image != null) {
        try {
          await precacheImage(decoration.image!.image, element);
        } catch (_) {}
      }
    }
  });
  await tester.pump();
}

Future<void> _shoot(
    WidgetTester tester, Widget screen, double height, String name) async {
  tester.view.physicalSize = Size(390 * 2, height * 2);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: qiantaoTheme(),
    home: screen,
  ));
  await tester.pump();
  await _precacheImages(tester);
  await tester.pump(const Duration(milliseconds: 50));
  // Precache again for lazily built list children that appeared after pumps.
  await _precacheImages(tester);
  await tester.pump(const Duration(milliseconds: 50));

  await expectLater(
      find.byType(MaterialApp), matchesGoldenFile('goldens/$name.png'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final binding = TestWidgetsFlutterBinding.instance;
    await binding.runAsync(_loadFonts);
    await binding.runAsync(CatalogueRepository.instance.load);
    await binding.runAsync(
        () => Session.instance.signIn('demo@qiantao.com', 'Alex Morgan'));
  });

  testWidgets('auth', (tester) async {
    await _shoot(tester, AuthScreen(onSignedIn: () {}), 1000, 'app_auth');
  });

  testWidgets('home', (tester) async {
    await _shoot(tester, const HomeScreen(), 4200, 'app_home');
  });

  testWidgets('product detail', (tester) async {
    final p = CatalogueRepository.instance.products
        .firstWhere((p) => p.typeCode == 'ALPFAM',
            orElse: () => CatalogueRepository.instance.products.first);
    await _shoot(tester, ProductFamilyScreen(product: p), 4400,
        'app_product_detail');
  });

  testWidgets('ai assistant', (tester) async {
    await _shoot(tester, const AiAssistantScreen(), 900, 'app_ai');
  });

  testWidgets('calculators', (tester) async {
    await _shoot(tester, const CalculatorsScreen(), 1600, 'app_calculators');
  });

  testWidgets('tool', (tester) async {
    await _shoot(tester, ToolScreen(tool: AppTool.registry.first), 1400,
        'app_tool');
  });

  testWidgets('categories', (tester) async {
    await _shoot(tester, const CategoriesScreen(), 3400, 'app_categories');
  });

  testWidgets('products', (tester) async {
    await _shoot(tester, const ProductsScreen(), 2600, 'app_products');
  });

  testWidgets('drawer', (tester) async {
    await _shoot(tester, const Scaffold(body: GfMenuDrawer()), 1400,
        'app_drawer');
  });

  testWidgets('pump form', (tester) async {
    await _shoot(tester, const PumpFormScreen(), 844, 'app_pump_form');
  });

  testWidgets('contact form', (tester) async {
    await _shoot(
        tester,
        const ContactFormScreen(initialTopic: 'Sales enquiry'),
        1100,
        'app_contact_form');
  });
}
