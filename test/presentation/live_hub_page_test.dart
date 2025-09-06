import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football_livehub/features/football/presentation/live_hub_page.dart';
import 'package:football_livehub/features/football/presentation/providers.dart';
import 'package:football_livehub/features/football/domain/entities.dart';

void main() {
  testWidgets('renders Today & Table sections', (tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        fixturesFutureProvider.overrideWith((_) async => [
              Fixture(
                id: '1',
                homeTeam: 'St. George',
                awayTeam: 'Ethio Bunna',
                league: 'ETH',
                kickoff: DateTime.now().toUtc(),
                status: 'SCHEDULED',
                score: '',
              )
            ]),
        standingsFutureProvider.overrideWith((_) async => [
              Standing(position: 1, team: 'St. George', points: 3)
            ]),
      ],
      child: const MaterialApp(home: LiveHubPage()),
    ));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Table'), findsOneWidget);
    expect(find.text('St. George'), findsNWidgets(2));
  });
}
