class Club {
  final String id;
  final String name;
  final String short;
  final String crestUrl;
  final String bio;
  final League league;

  Club({
    required this.id,
    required this.name,
    required this.bio,
    required this.short,
    required this.crestUrl,
    required this.league,
  });
}

enum League { EPL, ETH }
