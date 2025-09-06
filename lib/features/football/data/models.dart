class StandingDto {
  final int position;
  final String team;
  final int points;
  final int matchPlayed;
  final int wins;
  final int lose;
  final int draw;
  final int gd;

  StandingDto({
    required this.position, 
    required this.team, 
    required this.points,
    required this.matchPlayed,
    required this.wins,
    required this.lose,
    required this.draw,
    required this.gd,
  });

  factory StandingDto.fromJson(Map<String, dynamic> j) =>
      StandingDto(
        position: j['position'], 
        team: j['team'], 
        points: j['points'],
        matchPlayed: j['Match Played'] ?? j['matchPlayed'] ?? 0,
        wins: j['wins'] ?? 0,
        lose: j['lose'] ?? 0,
        draw: j['draw'] ?? 0,
        gd: j['GD'] ?? j['gd'] ?? 0,
      );
}

// Response wrapper for standings endpoint
class StandingsResponseDto {
  final String league;
  final List<StandingDto> standings;
  final FreshnessDto freshness;

  StandingsResponseDto({
    required this.league,
    required this.standings,
    required this.freshness,
  });

  factory StandingsResponseDto.fromJson(Map<String, dynamic> json) {
    return StandingsResponseDto(
      league: json['league'] ?? '',
      standings: (json['standings'] as List?)
          ?.map((item) => StandingDto.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      freshness: FreshnessDto.fromJson(json['freshness'] ?? {}),
    );
  }
}

class FixtureDto {
  final String id, homeTeam, awayTeam, league, status;
  final DateTime kickoff;
  final String? score;

  FixtureDto({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.league,
    required this.kickoff,
    required this.status,
    this.score,
  });

  factory FixtureDto.fromJson(Map<String, dynamic> j) => FixtureDto(
        id: j['id'],
        homeTeam: j['home_team'],
        awayTeam: j['away_team'],
        league: j['league'],
        kickoff: DateTime.parse(j['kickoff']),
        status: j['status'],
        score: j['score'],
      );
}

// Response wrapper for fixtures endpoint
class FixturesResponseDto {
  final List<FixtureDto> fixtures;
  final FreshnessDto freshness;

  FixturesResponseDto({
    required this.fixtures,
    required this.freshness,
  });

  factory FixturesResponseDto.fromJson(Map<String, dynamic> json) {
    return FixturesResponseDto(
      fixtures: (json['fixtures'] as List?)
          ?.map((item) => FixtureDto.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      freshness: FreshnessDto.fromJson(json['freshness'] ?? {}),
    );
  }
}

// Live scores response model
class LiveScoreDto {
  final String id, homeTeam, awayTeam, league, status, score;
  final DateTime kickoff;

  LiveScoreDto({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.league,
    required this.kickoff,
    required this.status,
    required this.score,
  });

  factory LiveScoreDto.fromJson(Map<String, dynamic> j) => LiveScoreDto(
        id: j['id'],
        homeTeam: j['home_team'],
        awayTeam: j['away_team'],
        league: j['league'],
        kickoff: DateTime.parse(j['kickoff']),
        status: j['status'],
        score: j['score'] ?? '',
      );
}

// Response wrapper for live scores endpoint
class LiveScoresResponseDto {
  final List<LiveScoreDto> liveScores;
  final FreshnessDto freshness;

  LiveScoresResponseDto({
    required this.liveScores,
    required this.freshness,
  });

  factory LiveScoresResponseDto.fromJson(Map<String, dynamic> json) {
    return LiveScoresResponseDto(
      liveScores: (json['liveScores'] as List?)
          ?.map((item) => LiveScoreDto.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      freshness: FreshnessDto.fromJson(json['freshness'] ?? {}),
    );
  }
}

class FreshnessDto {
  final String source;
  final DateTime retrieved;

  FreshnessDto({required this.source, required this.retrieved});

  factory FreshnessDto.fromJson(Map<String, dynamic> json) {
    return FreshnessDto(
      source: json['source'] ?? 'unknown',
      retrieved: DateTime.parse(json['retrieved'] ?? DateTime.now().toIso8601String()),
    );
  }
}

