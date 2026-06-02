import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens example app and navigates to package demos', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ResponsiveFlexList Demo'), findsWidgets);
    expect(find.text('Children Example'), findsOneWidget);
    expect(find.text('Builder Example'), findsOneWidget);
    expect(find.text('Separator Example'), findsOneWidget);
    expect(find.text('Masonry Example'), findsOneWidget);

    await tester.tap(find.text('Children Example'));
    await tester.pumpAndSettle();
    expect(find.text('Basic ResponsiveFlexList'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Builder Example'));
    await tester.pumpAndSettle();
    expect(find.text('Builder Pattern'), findsOneWidget);
  });
}
