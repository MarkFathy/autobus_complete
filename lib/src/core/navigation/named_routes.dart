enum NamedRoutes {
  splash('/'),
  home('/home'),
  login('/login'),
  register('/register'),
  roomLobby('/roomLobby'),
  gameBoard('/gameBoard'),
  scoring('/scoring'),
  leaderboard('/leaderboard');
  
  final String routeName;

  const NamedRoutes(this.routeName);
}
