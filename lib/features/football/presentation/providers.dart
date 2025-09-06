import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football_livehub/core/http_client.dart';
import 'package:football_livehub/core/config.dart';
import '../data/football_api_client.dart';
import '../data/football_repository_impl.dart';
import '../domain/usecases.dart';
import '../domain/entities.dart';

final httpClientProvider = Provider((_) => HttpClient(Config.apiBaseUrl));
final apiProvider = Provider((ref) => FootballApiClient(ref.read(httpClientProvider)));
final repoProvider = Provider((ref) => FootballRepositoryImpl(ref.read(apiProvider)));

final getStandingsProvider = Provider((ref) => GetStandings(ref.read(repoProvider)));
final getFixturesProvider = Provider((ref) => GetFixtures(ref.read(repoProvider)));
final getLiveScoresProvider = Provider((ref) => GetLiveScores(ref.read(repoProvider)));

final selectedLeagueProvider = StateProvider<String>((_) => 'ETH');

final standingsFutureProvider = FutureProvider.autoDispose<List<Standing>>((ref) {
  final league = ref.watch(selectedLeagueProvider);
  return ref.read(getStandingsProvider).call(league);
});

final fixturesFutureProvider = FutureProvider.autoDispose<List<Fixture>>((ref) {
  final league = ref.watch(selectedLeagueProvider);
  return ref.read(getFixturesProvider).call(league: league);
});

final liveScoresFutureProvider = FutureProvider.autoDispose<List<LiveScore>>((ref) {
  return ref.read(getLiveScoresProvider).call();
});
