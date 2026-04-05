// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'THE HIDDEN WORD';

  @override
  String get appTitlePart1 => 'HIDDEN';

  @override
  String get appTitlePart2 => 'WORD';

  @override
  String get appSubtitle =>
      'Find the spy among you. Speak carefully, trust no one.';

  @override
  String get homeNav => 'HOME';

  @override
  String get connectNav => 'CONNECT';

  @override
  String get rulesNav => 'RULES';

  @override
  String get settingsNav => 'SETTINGS';

  @override
  String get timerLabel => 'TIMER';

  @override
  String get roundsLabel => 'ROUNDS';

  @override
  String get wins => 'Wins';

  @override
  String get startMission => 'START MISSION';

  @override
  String get preparePokerFace => 'PREPARE YOUR POKER FACE';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get personalizeRitual => 'PERSONALIZE YOUR RITUAL';

  @override
  String get gameplayAccessibility => 'GAMEPLAY & ACCESSIBILITY';

  @override
  String get languageLabel => 'Language';

  @override
  String get englishSubtitle => 'Mission Language (English)';

  @override
  String get amharicSubtitle => 'ባህላዊ ቋንቋ (አማርኛ)';

  @override
  String get soundEffects => 'Sound Effects';

  @override
  String get soundEffectsSubtitle => 'Immersive ritual sounds';

  @override
  String get hapticFeedback => 'Haptic Feedback';

  @override
  String get hapticFeedbackSubtitle => 'Tactile tension cues';

  @override
  String get gameTimer => 'Game Timer';

  @override
  String get gameTimerSubtitle => 'Visible countdown during play';

  @override
  String get knowledgeBase => 'KNOWLEDGE BASE';

  @override
  String get credits => 'Credits';

  @override
  String get aboutDevelopers => 'About the Developers';

  @override
  String get ritualContinues => 'THE RITUAL CONTINUES';

  @override
  String get ritualContinuesSubtitle =>
      'Your progress is automatically saved to the Vault. Level up your rank to unlock exclusive traditional avatars and hidden word packs.';

  @override
  String get abortMission => 'ABORT MISSION';

  @override
  String get agentProfile => 'AGENT PROFILE';

  @override
  String get codename => 'CODENAME';

  @override
  String get identifyYourself => 'IDENTIFY YOURSELF...';

  @override
  String get connectedHostWaiting =>
      'Connected! Waiting for the host to start the game...';

  @override
  String get connectivityInfo =>
      'Ensure all players are connected to the same WiFi network or mobile hotspot to discover nearby games instantly.';

  @override
  String get connectivityInfoPart1 =>
      'Ensure all players are connected to the ';

  @override
  String get connectivityInfoPart2 => 'same WiFi network';

  @override
  String get connectivityInfoPart3 =>
      ' or mobile hotspot to discover nearby games instantly.';

  @override
  String get playerIdLabel => 'PLAYER ID';

  @override
  String get secretWord => 'SECRET WORD';

  @override
  String get secretWordReveal => 'SECRET WORD REVEAL';

  @override
  String playerReadyStatus(int count, int total) {
    return '$count of $total players ready';
  }

  @override
  String get dontShowSecret => 'Don\'t show your secret word to anyone';

  @override
  String get waitingForHost => 'WAITING FOR HOST...';

  @override
  String get hostConfiguring => 'The host is configuring the game settings.';

  @override
  String get waitingForHostAm => 'Waiting for host...';

  @override
  String get ready => 'READY';

  @override
  String get pressToOpen => 'TAP TO REVEAL';

  @override
  String get pressToOpenSubtitle =>
      'Tap the card to see your secret word. Make sure no one is watching.';

  @override
  String get youAreSpy => 'YOU ARE THE SPY!';

  @override
  String get secretWordLabel => 'SECRET WORD';

  @override
  String get defaultRoomName => 'SECURE CHAMBER';

  @override
  String get hostMission => 'Host Mission';

  @override
  String get broadcastingFrequency => 'Broadcasting mission frequency...';

  @override
  String get initializeFrequency =>
      'Initialize secure frequency for your agents.';

  @override
  String get statusFailed => 'FAILED';

  @override
  String get statusBroadcasting => 'BROADCASTING';

  @override
  String get statusStarting => 'STARTING...';

  @override
  String get statusOffline => 'OFFLINE';

  @override
  String get statusReadying => 'READYING...';

  @override
  String get statusReady => 'READY';

  @override
  String get statusJoined => 'JOINED';

  @override
  String get statusEncrypting => 'ENCRYPTING...';

  @override
  String get missionBriefing => 'MISSION BRIEFING';

  @override
  String get roomIdentifier => 'ROOM IDENTIFIER';

  @override
  String get hostCodename => 'HOST CODENAME';

  @override
  String get updateMissionIdentity => 'UPDATE MISSION IDENTITY';

  @override
  String get initializeBroadcast => 'INITIALIZE BROADCAST';

  @override
  String get missionParameters => 'MISSION PARAMETERS';

  @override
  String get numberOfSpies => 'NUMBER OF SPIES';

  @override
  String spyCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spies',
      one: '1 Spy',
    );
    return '$_temp0';
  }

  @override
  String get wordCategories => 'WORD CATEGORIES';

  @override
  String get categoryTraditionalFood => 'Traditional Food';

  @override
  String get categoryHeritageSites => 'Heritage Sites';

  @override
  String get categoryEthiopianCulture => 'Ethiopian Culture';

  @override
  String get categorySports => 'Sports';

  @override
  String get discussionTimer => '60s Discussion Timer';

  @override
  String get discussionTimerDesc => 'Keep the pressure high';

  @override
  String get secureFrequency => 'SECURE FREQUENCY';

  @override
  String get localNetworkBroadcastActive => 'LOCAL NETWORK BROADCAST ACTIVE';

  @override
  String get agentRoster => 'Agent Roster';

  @override
  String get youHost => 'You (Host)';

  @override
  String get badgeHost => 'HOST';

  @override
  String get beginMission => 'BEGIN MISSION';

  @override
  String get briefingRequirement =>
      'ALL AGENTS MUST BE BRIEFED BEFORE DEPLOYMENT';

  @override
  String get discussionPhase => 'DISCUSSION PHASE';

  @override
  String get whoIsTheSpy => 'Who is the Spy?';

  @override
  String get liveSession => 'LIVE SESSION';

  @override
  String get remainingTime => 'REMAINING TIME';

  @override
  String get participants => 'PARTICIPANTS';

  @override
  String onlineCount(int count) {
    return '$count Online';
  }

  @override
  String get yourSecretWord => 'Your secret word:';

  @override
  String get tapToSeeWord => 'TAP TO SEE WORD';

  @override
  String get waitingForOthers => 'Waiting for others to finish...';

  @override
  String get secretContinues => 'The secret continues...';

  @override
  String get trustNoOne => 'Trust no one! Verify their loyalty.';

  @override
  String get votingStatus => 'VOTING STATUS';

  @override
  String get playersVoting => 'Players are making their choices';

  @override
  String get decisionInProgress => 'Decision in progress';

  @override
  String get votedSelected => 'Selected';

  @override
  String get votedSelect => 'Select';

  @override
  String get missionComplete => 'MISSION COMPLETE';

  @override
  String get truthRevealed => 'THE TRUTH IS KNOWN';

  @override
  String get spyLabel => 'THE SPY!';

  @override
  String get unknown => 'Unknown';

  @override
  String spyCaughtDesc(String names) {
    return 'The spy has been identified by the citizens. Citizens voted correctly for $names.';
  }

  @override
  String spyEscapedDesc(String name) {
    return 'The spy has escaped undetected. Citizens mistakenly voted for $name.';
  }

  @override
  String get citizensWin => 'CITIZENS WIN!';

  @override
  String get spyWins => 'SPY WINS!';

  @override
  String get justicePrevailed => 'Justice has prevailed';

  @override
  String get missionFailed => 'Mission compromised';

  @override
  String get playAgain => 'PLAY AGAIN';

  @override
  String get mainMenu => 'MAIN MENU';

  @override
  String get nearbyGames => 'Nearby Games';

  @override
  String get autoScanning => 'Auto-scanning';

  @override
  String get interceptingSignals => 'INTERCEPTING SIGNALS...';

  @override
  String get noRoomsLocated => 'NO ROOMS LOCATED';

  @override
  String get ensureHostVisible =>
      'Ensure the Host is visible on your\nnetwork or local hotspot.';

  @override
  String get readyToDeploy => 'SIGNAL STABLE • READY TO DEPLOY';
}
