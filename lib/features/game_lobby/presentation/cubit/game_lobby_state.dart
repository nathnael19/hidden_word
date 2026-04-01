import 'package:equatable/equatable.dart';

abstract class GameLobbyState extends Equatable {
  const GameLobbyState();

  @override
  List<Object> get props => [];
}

class GameLobbyInitial extends GameLobbyState {}
class GameLobbyScanning extends GameLobbyState {}
class GameLobbyHosting extends GameLobbyState {}

class GameLobbyReady extends GameLobbyState {
  final List<Map<String, String>> nearbyGames;
  const GameLobbyReady({this.nearbyGames = const []});

  @override
  List<Object> get props => [nearbyGames];
}
