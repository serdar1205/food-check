import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_check/features/review_result/domain/review_result.dart';
import 'package:food_check/features/review_result/presentation/review_result_page.dart';

void main() {
  testWidgets('success shows acceptance headline and bonus', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ReviewResultPage(result: ReviewResultEntity.success(50)),
      ),
    );

    expect(find.text('Отзыв принят!'), findsOneWidget);
    expect(find.textContaining('50'), findsWidgets);
    expect(find.text('На главную'), findsOneWidget);
  });

  testWidgets('failure shows error title and reasons', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ReviewResultPage(
          result: ReviewResultEntity.failure('Custom reason'),
        ),
      ),
    );

    expect(find.text('Ошибка'), findsOneWidget);
    expect(find.text('Custom reason'), findsOneWidget);
    expect(find.text('ВОЗМОЖНЫЕ ПРИЧИНЫ'), findsOneWidget);
    expect(find.text('Попробовать снова'), findsOneWidget);
    expect(find.text('Вернуться'), findsOneWidget);
    expect(find.text('GOLDED'), findsOneWidget);
  });
}
