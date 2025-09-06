import 'entities.dart';

abstract class FootballRepository {
  Future<List<Standing>> standings(String league);
  Future<List<Fixture>> fixtures({required String league, String? team, DateTime? from, DateTime? to});
  Future<List<LiveScore>> liveScores();
}
