import 'package:flutter_test/flutter_test.dart';
import 'package:sengoku_saihairoku/main.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const SengokuSaihairokuApp());
    expect(find.text('戦国采配録'), findsWidgets);
  });
}
