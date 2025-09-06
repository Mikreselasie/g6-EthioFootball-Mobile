class Standing {
  final int position;
  final String team;
  final int points;
  final int matchPlayed;
  final int wins;
  final int lose;
  final int draw;
  final int gd;
  
  Standing({
    required this.position, 
    required this.team, 
    required this.points,
    required this.matchPlayed,
    required this.wins,
    required this.lose,
    required this.draw,
    required this.gd,
  });
}

class Fixture {
  final String id, homeTeam, awayTeam, league, status;
  final DateTime kickoff;
  final String? score;
  
  Fixture({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.league,
    required this.kickoff,
    required this.status,
    this.score,
  });
}

class LiveScore {
  final String id, homeTeam, awayTeam, league, status, score;
  final DateTime kickoff;
  
  LiveScore({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.league,
    required this.kickoff,
    required this.status,
    required this.score,
  });
}
