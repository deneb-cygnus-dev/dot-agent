# Flutter/Dart Testing Reference

## Framework

- `flutter_test` - Built-in testing
- `mockito` - Mocking
- `bloc_test` - BLoC testing
- `integration_test` - Integration/E2E

## File Organization

```text
lib/
├── src/features/
│   └── market/
│       ├── data/
│       │   └── market_repository.dart
│       ├── domain/
│       │   └── market_service.dart
│       └── presentation/
│           ├── market_screen.dart
│           └── widgets/market_card.dart
test/
├── unit/
│   └── market_service_test.dart
├── widget/
│   └── market_card_test.dart
└── integration/
    └── app_test.dart
integration_test/
└── market_flow_test.dart
```

## Unit Test Pattern

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([MarketRepository])
void main() {
  late MarketService service;
  late MockMarketRepository mockRepo;

  setUp(() {
    mockRepo = MockMarketRepository();
    service = MarketService(mockRepo);
  });

  group('searchMarkets', () {
    test('returns relevant markets', () async {
      when(mockRepo.search(any, any)).thenAnswer(
        (_) async => [Market(id: '1', name: 'Election 2024')],
      );

      final results = await service.search('election', limit: 10);

      expect(results, isNotEmpty);
      expect(results.first.name, contains('Election'));
      verify(mockRepo.search('election', 10)).called(1);
    });

    test('throws on empty query', () async {
      expect(
        () => service.search('', limit: 10),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
```

## Widget Test Pattern

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarketCard', () {
    testWidgets('displays market name', (tester) async {
      final market = Market(id: '1', name: 'Test Market');

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: MarketCard(market: market))),
      );

      expect(find.text('Test Market'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      Market? tapped;
      final market = Market(id: '1', name: 'Test');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarketCard(market: market, onTap: (m) => tapped = m),
          ),
        ),
      );

      await tester.tap(find.byType(MarketCard));
      expect(tapped, equals(market));
    });
  });
}
```

## Integration Test Pattern

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('user can search and view market', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Markets'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'election');
    await tester.pumpAndSettle();

    expect(find.textContaining('Election'), findsWidgets);

    await tester.tap(find.textContaining('Election').first);
    await tester.pumpAndSettle();

    expect(find.byType(MarketDetailScreen), findsOneWidget);
  });
}
```

## BLoC Test Pattern

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarketBloc', () {
    late MockMarketRepository mockRepo;

    setUp(() => mockRepo = MockMarketRepository());

    blocTest<MarketBloc, MarketState>(
      'emits [loading, loaded] when search succeeds',
      build: () {
        when(mockRepo.search(any, any)).thenAnswer(
          (_) async => [Market(id: '1', name: 'Test')],
        );
        return MarketBloc(mockRepo);
      },
      act: (bloc) => bloc.add(SearchMarkets('test')),
      expect: () => [
        MarketLoading(),
        MarketLoaded([Market(id: '1', name: 'Test')]),
      ],
    );

    blocTest<MarketBloc, MarketState>(
      'emits [loading, error] when search fails',
      build: () {
        when(mockRepo.search(any, any)).thenThrow(Exception('Failed'));
        return MarketBloc(mockRepo);
      },
      act: (bloc) => bloc.add(SearchMarkets('test')),
      expect: () => [MarketLoading(), MarketError('Failed to search')],
    );
  });
}
```

## Commands

```bash
# Run all tests
flutter test

# With coverage
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Run specific test
flutter test test/unit/market_service_test.dart

# Integration tests
flutter test integration_test/

# Run on device
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
```

## CI/CD

```yaml
- uses: subosito/flutter-action@v2
- run: flutter test --coverage
```
