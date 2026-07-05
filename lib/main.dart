import 'package:flutter/material.dart';

import 'data/repository.dart';
import 'screens/ai_assistant_screen.dart';
import 'screens/applications_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/contact_form_screen.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/sizing_screen.dart';
import 'screens/utility_screens.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CatalogueRepository.instance.load();
  await Session.instance.restore();
  runApp(const QiantaoProductCenterApp());
}

/// Qiantao Product Center — digital product catalogue
/// (copy of qiantao (catalogue source), extended into a proposal app).
class QiantaoProductCenterApp extends StatelessWidget {
  const QiantaoProductCenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qiantao Product Center',
      debugShowCheckedModeBanner: false,
      theme: qiantaoTheme(),
      home: const _Gate(),
      routes: {
        '/categories': (_) => const CategoriesScreen(),
        '/applications': (_) => const ApplicationsScreen(),
        '/products': (_) => const ProductsScreen(),
        '/advanced-selection': (_) => const AdvancedSelectionScreen(),
        '/search': (_) => const SearchScreen(),
        '/compare': (_) => const CompareScreen(),
        '/recently-viewed': (_) => const RecentlyViewedScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/contact': (_) => const ContactFormScreen(),
        '/assistant': (_) => const AiAssistantScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/sizing') {
          final args = (settings.arguments as Map?) ?? const {};
          return MaterialPageRoute(
            builder: (_) => SizingScreen(
              initialSizeBy: args['sizeBy'] as String?,
              initialArea: args['area'] as String?,
            ),
          );
        }
        return null;
      },
    );
  }
}

/// Shows the auth screen until a session exists, then the home screen.
class _Gate extends StatefulWidget {
  const _Gate();

  @override
  State<_Gate> createState() => _GateState();
}

class _GateState extends State<_Gate> {
  @override
  void initState() {
    super.initState();
    Session.instance.addListener(_onSession);
  }

  @override
  void dispose() {
    Session.instance.removeListener(_onSession);
    super.dispose();
  }

  void _onSession() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (!Session.instance.signedIn) {
      return AuthScreen(onSignedIn: () => setState(() {}));
    }
    return const HomeScreen();
  }
}
