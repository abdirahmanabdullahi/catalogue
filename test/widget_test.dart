import 'package:flutter_test/flutter_test.dart';

import 'package:catalogue/data/repository.dart';
import 'package:catalogue/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home screen renders the Qiantao Product Center content',
      (WidgetTester tester) async {
    await tester.runAsync(() => CatalogueRepository.instance.load());
    await tester.runAsync(() => Session.instance.signIn('demo@example.com', 'Demo'));
    await tester.pumpWidget(const QiantaoProductCenterApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Find a Qiantao product'), findsOneWidget);
    expect(find.text('One catalogue. Every pump. Always current.'),
        findsOneWidget);
  });
}
