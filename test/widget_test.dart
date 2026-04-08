import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/app/app.dart';
import 'package:food_check/app/di.dart';

void main() {
  testWidgets('app starts on splash', (WidgetTester tester) async {
    final dependencies = AppDependencies(
      splashMinDisplayDuration: Duration.zero,
    );
    await tester.pumpWidget(FoodCheckApp(dependencies: dependencies));
    await tester.pump();

    expect(find.text('FoodCheck'), findsOneWidget);
  });
}
