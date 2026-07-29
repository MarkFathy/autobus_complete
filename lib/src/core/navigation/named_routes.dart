enum NamedRoutes {
  splash('/'),
  home('/home'),
  login('/login'),
  register('/register'),
  roomLobby('/roomLobby'),
  countdown('/countdown'),
  gameBoard('/gameBoard'),
  scoring('/scoring'),
  leaderboard('/leaderboard'),
  settings('/settings'),
  profile('/profile');
  
  final String routeName;

  const NamedRoutes(this.routeName);
}
