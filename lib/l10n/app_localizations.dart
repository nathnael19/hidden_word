import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'THE HIDDEN WORD'**
  String get appTitle;

  /// No description provided for @appTitlePart1.
  ///
  /// In en, this message translates to:
  /// **'HIDDEN'**
  String get appTitlePart1;

  /// No description provided for @appTitlePart2.
  ///
  /// In en, this message translates to:
  /// **'WORD'**
  String get appTitlePart2;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the spy among you. Speak carefully, trust no one.'**
  String get appSubtitle;

  /// No description provided for @homeNav.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get homeNav;

  /// No description provided for @connectNav.
  ///
  /// In en, this message translates to:
  /// **'CONNECT'**
  String get connectNav;

  /// No description provided for @rulesNav.
  ///
  /// In en, this message translates to:
  /// **'RULES'**
  String get rulesNav;

  /// No description provided for @settingsNav.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsNav;

  /// No description provided for @timerLabel.
  ///
  /// In en, this message translates to:
  /// **'TIMER'**
  String get timerLabel;

  /// No description provided for @roundsLabel.
  ///
  /// In en, this message translates to:
  /// **'ROUNDS'**
  String get roundsLabel;

  /// No description provided for @wins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get wins;

  /// No description provided for @startMission.
  ///
  /// In en, this message translates to:
  /// **'START MISSION'**
  String get startMission;

  /// No description provided for @preparePokerFace.
  ///
  /// In en, this message translates to:
  /// **'PREPARE YOUR POKER FACE'**
  String get preparePokerFace;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @personalizeRitual.
  ///
  /// In en, this message translates to:
  /// **'PERSONALIZE YOUR RITUAL'**
  String get personalizeRitual;

  /// No description provided for @gameplayAccessibility.
  ///
  /// In en, this message translates to:
  /// **'GAMEPLAY & ACCESSIBILITY'**
  String get gameplayAccessibility;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @englishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mission Language (English)'**
  String get englishSubtitle;

  /// No description provided for @amharicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'ባህላዊ ቋንቋ (አማርኛ)'**
  String get amharicSubtitle;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffects;

  /// No description provided for @soundEffectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Immersive ritual sounds'**
  String get soundEffectsSubtitle;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get hapticFeedback;

  /// No description provided for @hapticFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tactile tension cues'**
  String get hapticFeedbackSubtitle;

  /// No description provided for @gameTimer.
  ///
  /// In en, this message translates to:
  /// **'Game Timer'**
  String get gameTimer;

  /// No description provided for @gameTimerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visible countdown during play'**
  String get gameTimerSubtitle;

  /// No description provided for @knowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'KNOWLEDGE BASE'**
  String get knowledgeBase;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @aboutDevelopers.
  ///
  /// In en, this message translates to:
  /// **'About the Developers'**
  String get aboutDevelopers;

  /// No description provided for @ritualContinues.
  ///
  /// In en, this message translates to:
  /// **'THE RITUAL CONTINUES'**
  String get ritualContinues;

  /// No description provided for @ritualContinuesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your progress is automatically saved to the Vault. Level up your rank to unlock exclusive traditional avatars and hidden word packs.'**
  String get ritualContinuesSubtitle;

  /// No description provided for @abortMission.
  ///
  /// In en, this message translates to:
  /// **'ABORT MISSION'**
  String get abortMission;

  /// No description provided for @agentProfile.
  ///
  /// In en, this message translates to:
  /// **'AGENT PROFILE'**
  String get agentProfile;

  /// No description provided for @codename.
  ///
  /// In en, this message translates to:
  /// **'CODENAME'**
  String get codename;

  /// No description provided for @identifyYourself.
  ///
  /// In en, this message translates to:
  /// **'IDENTIFY YOURSELF...'**
  String get identifyYourself;

  /// No description provided for @connectedHostWaiting.
  ///
  /// In en, this message translates to:
  /// **'Connected! Waiting for the host to start the game...'**
  String get connectedHostWaiting;

  /// No description provided for @connectivityInfo.
  ///
  /// In en, this message translates to:
  /// **'Ensure all players are connected to the same WiFi network or mobile hotspot to discover nearby games instantly.'**
  String get connectivityInfo;

  /// No description provided for @connectivityInfoPart1.
  ///
  /// In en, this message translates to:
  /// **'Ensure all players are connected to the '**
  String get connectivityInfoPart1;

  /// No description provided for @connectivityInfoPart2.
  ///
  /// In en, this message translates to:
  /// **'same WiFi network'**
  String get connectivityInfoPart2;

  /// No description provided for @connectivityInfoPart3.
  ///
  /// In en, this message translates to:
  /// **' or mobile hotspot to discover nearby games instantly.'**
  String get connectivityInfoPart3;

  /// No description provided for @playerIdLabel.
  ///
  /// In en, this message translates to:
  /// **'PLAYER ID'**
  String get playerIdLabel;

  /// No description provided for @secretWord.
  ///
  /// In en, this message translates to:
  /// **'SECRET WORD'**
  String get secretWord;

  /// No description provided for @secretWordReveal.
  ///
  /// In en, this message translates to:
  /// **'SECRET WORD REVEAL'**
  String get secretWordReveal;

  /// No description provided for @playerReadyStatus.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} players ready'**
  String playerReadyStatus(int count, int total);

  /// No description provided for @dontShowSecret.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show your secret word to anyone'**
  String get dontShowSecret;

  /// No description provided for @waitingForHost.
  ///
  /// In en, this message translates to:
  /// **'WAITING FOR HOST...'**
  String get waitingForHost;

  /// No description provided for @hostConfiguring.
  ///
  /// In en, this message translates to:
  /// **'The host is configuring the game settings.'**
  String get hostConfiguring;

  /// No description provided for @waitingForHostAm.
  ///
  /// In en, this message translates to:
  /// **'Waiting for host...'**
  String get waitingForHostAm;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get ready;

  /// No description provided for @pressToOpen.
  ///
  /// In en, this message translates to:
  /// **'TAP TO REVEAL'**
  String get pressToOpen;

  /// No description provided for @pressToOpenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the card to see your secret word. Make sure no one is watching.'**
  String get pressToOpenSubtitle;

  /// No description provided for @youAreSpy.
  ///
  /// In en, this message translates to:
  /// **'YOU ARE THE SPY!'**
  String get youAreSpy;

  /// No description provided for @secretWordLabel.
  ///
  /// In en, this message translates to:
  /// **'SECRET WORD'**
  String get secretWordLabel;

  /// No description provided for @defaultRoomName.
  ///
  /// In en, this message translates to:
  /// **'SECURE CHAMBER'**
  String get defaultRoomName;

  /// No description provided for @hostMission.
  ///
  /// In en, this message translates to:
  /// **'Host Mission'**
  String get hostMission;

  /// No description provided for @broadcastingFrequency.
  ///
  /// In en, this message translates to:
  /// **'Broadcasting mission frequency...'**
  String get broadcastingFrequency;

  /// No description provided for @initializeFrequency.
  ///
  /// In en, this message translates to:
  /// **'Initialize secure frequency for your agents.'**
  String get initializeFrequency;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'FAILED'**
  String get statusFailed;

  /// No description provided for @statusBroadcasting.
  ///
  /// In en, this message translates to:
  /// **'BROADCASTING'**
  String get statusBroadcasting;

  /// No description provided for @statusStarting.
  ///
  /// In en, this message translates to:
  /// **'STARTING...'**
  String get statusStarting;

  /// No description provided for @statusOffline.
  ///
  /// In en, this message translates to:
  /// **'OFFLINE'**
  String get statusOffline;

  /// No description provided for @statusReadying.
  ///
  /// In en, this message translates to:
  /// **'READYING...'**
  String get statusReadying;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get statusReady;

  /// No description provided for @statusJoined.
  ///
  /// In en, this message translates to:
  /// **'JOINED'**
  String get statusJoined;

  /// No description provided for @statusEncrypting.
  ///
  /// In en, this message translates to:
  /// **'ENCRYPTING...'**
  String get statusEncrypting;

  /// No description provided for @missionBriefing.
  ///
  /// In en, this message translates to:
  /// **'MISSION BRIEFING'**
  String get missionBriefing;

  /// No description provided for @roomIdentifier.
  ///
  /// In en, this message translates to:
  /// **'ROOM IDENTIFIER'**
  String get roomIdentifier;

  /// No description provided for @hostCodename.
  ///
  /// In en, this message translates to:
  /// **'HOST CODENAME'**
  String get hostCodename;

  /// No description provided for @updateMissionIdentity.
  ///
  /// In en, this message translates to:
  /// **'UPDATE MISSION IDENTITY'**
  String get updateMissionIdentity;

  /// No description provided for @initializeBroadcast.
  ///
  /// In en, this message translates to:
  /// **'INITIALIZE BROADCAST'**
  String get initializeBroadcast;

  /// No description provided for @missionParameters.
  ///
  /// In en, this message translates to:
  /// **'MISSION PARAMETERS'**
  String get missionParameters;

  /// No description provided for @numberOfSpies.
  ///
  /// In en, this message translates to:
  /// **'NUMBER OF SPIES'**
  String get numberOfSpies;

  /// No description provided for @spyCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Spy} other{{count} Spies}}'**
  String spyCountLabel(int count);

  /// No description provided for @wordCategories.
  ///
  /// In en, this message translates to:
  /// **'WORD CATEGORIES'**
  String get wordCategories;

  /// No description provided for @categoryTraditionalFood.
  ///
  /// In en, this message translates to:
  /// **'Traditional Food'**
  String get categoryTraditionalFood;

  /// No description provided for @categoryHeritageSites.
  ///
  /// In en, this message translates to:
  /// **'Heritage Sites'**
  String get categoryHeritageSites;

  /// No description provided for @categoryEthiopianCulture.
  ///
  /// In en, this message translates to:
  /// **'Ethiopian Culture'**
  String get categoryEthiopianCulture;

  /// No description provided for @categorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get categorySports;

  /// No description provided for @discussionTimer.
  ///
  /// In en, this message translates to:
  /// **'60s Discussion Timer'**
  String get discussionTimer;

  /// No description provided for @discussionTimerDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep the pressure high'**
  String get discussionTimerDesc;

  /// No description provided for @secureFrequency.
  ///
  /// In en, this message translates to:
  /// **'SECURE FREQUENCY'**
  String get secureFrequency;

  /// No description provided for @localNetworkBroadcastActive.
  ///
  /// In en, this message translates to:
  /// **'LOCAL NETWORK BROADCAST ACTIVE'**
  String get localNetworkBroadcastActive;

  /// No description provided for @agentRoster.
  ///
  /// In en, this message translates to:
  /// **'Agent Roster'**
  String get agentRoster;

  /// No description provided for @youHost.
  ///
  /// In en, this message translates to:
  /// **'You (Host)'**
  String get youHost;

  /// No description provided for @badgeHost.
  ///
  /// In en, this message translates to:
  /// **'HOST'**
  String get badgeHost;

  /// No description provided for @beginMission.
  ///
  /// In en, this message translates to:
  /// **'BEGIN MISSION'**
  String get beginMission;

  /// No description provided for @briefingRequirement.
  ///
  /// In en, this message translates to:
  /// **'ALL AGENTS MUST BE BRIEFED BEFORE DEPLOYMENT'**
  String get briefingRequirement;

  /// No description provided for @discussionPhase.
  ///
  /// In en, this message translates to:
  /// **'DISCUSSION PHASE'**
  String get discussionPhase;

  /// No description provided for @whoIsTheSpy.
  ///
  /// In en, this message translates to:
  /// **'Who is the Spy?'**
  String get whoIsTheSpy;

  /// No description provided for @liveSession.
  ///
  /// In en, this message translates to:
  /// **'LIVE SESSION'**
  String get liveSession;

  /// No description provided for @remainingTime.
  ///
  /// In en, this message translates to:
  /// **'REMAINING TIME'**
  String get remainingTime;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'PARTICIPANTS'**
  String get participants;

  /// No description provided for @onlineCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Online'**
  String onlineCount(int count);

  /// No description provided for @yourSecretWord.
  ///
  /// In en, this message translates to:
  /// **'Your secret word:'**
  String get yourSecretWord;

  /// No description provided for @tapToSeeWord.
  ///
  /// In en, this message translates to:
  /// **'TAP TO SEE WORD'**
  String get tapToSeeWord;

  /// No description provided for @waitingForOthers.
  ///
  /// In en, this message translates to:
  /// **'Waiting for others to finish...'**
  String get waitingForOthers;

  /// No description provided for @secretContinues.
  ///
  /// In en, this message translates to:
  /// **'The secret continues...'**
  String get secretContinues;

  /// No description provided for @trustNoOne.
  ///
  /// In en, this message translates to:
  /// **'Trust no one! Verify their loyalty.'**
  String get trustNoOne;

  /// No description provided for @votingStatus.
  ///
  /// In en, this message translates to:
  /// **'VOTING STATUS'**
  String get votingStatus;

  /// No description provided for @playersVoting.
  ///
  /// In en, this message translates to:
  /// **'Players are making their choices'**
  String get playersVoting;

  /// No description provided for @decisionInProgress.
  ///
  /// In en, this message translates to:
  /// **'Decision in progress'**
  String get decisionInProgress;

  /// No description provided for @votedSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get votedSelected;

  /// No description provided for @votedSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get votedSelect;

  /// No description provided for @missionComplete.
  ///
  /// In en, this message translates to:
  /// **'MISSION COMPLETE'**
  String get missionComplete;

  /// No description provided for @truthRevealed.
  ///
  /// In en, this message translates to:
  /// **'THE TRUTH IS KNOWN'**
  String get truthRevealed;

  /// No description provided for @spyLabel.
  ///
  /// In en, this message translates to:
  /// **'THE SPY!'**
  String get spyLabel;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @spyCaughtDesc.
  ///
  /// In en, this message translates to:
  /// **'The spy has been identified by the citizens. Citizens voted correctly for {names}.'**
  String spyCaughtDesc(String names);

  /// No description provided for @spyEscapedDesc.
  ///
  /// In en, this message translates to:
  /// **'The spy has escaped undetected. Citizens mistakenly voted for {name}.'**
  String spyEscapedDesc(String name);

  /// No description provided for @citizensWin.
  ///
  /// In en, this message translates to:
  /// **'CITIZENS WIN!'**
  String get citizensWin;

  /// No description provided for @spyWins.
  ///
  /// In en, this message translates to:
  /// **'SPY WINS!'**
  String get spyWins;

  /// No description provided for @justicePrevailed.
  ///
  /// In en, this message translates to:
  /// **'Justice has prevailed'**
  String get justicePrevailed;

  /// No description provided for @missionFailed.
  ///
  /// In en, this message translates to:
  /// **'Mission compromised'**
  String get missionFailed;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'PLAY AGAIN'**
  String get playAgain;

  /// No description provided for @mainMenu.
  ///
  /// In en, this message translates to:
  /// **'MAIN MENU'**
  String get mainMenu;

  /// No description provided for @nearbyGames.
  ///
  /// In en, this message translates to:
  /// **'Nearby Games'**
  String get nearbyGames;

  /// No description provided for @autoScanning.
  ///
  /// In en, this message translates to:
  /// **'Auto-scanning'**
  String get autoScanning;

  /// No description provided for @interceptingSignals.
  ///
  /// In en, this message translates to:
  /// **'INTERCEPTING SIGNALS...'**
  String get interceptingSignals;

  /// No description provided for @noRoomsLocated.
  ///
  /// In en, this message translates to:
  /// **'NO ROOMS LOCATED'**
  String get noRoomsLocated;

  /// No description provided for @ensureHostVisible.
  ///
  /// In en, this message translates to:
  /// **'Ensure the Host is visible on your\nnetwork or local hotspot.'**
  String get ensureHostVisible;

  /// No description provided for @readyToDeploy.
  ///
  /// In en, this message translates to:
  /// **'SIGNAL STABLE • READY TO DEPLOY'**
  String get readyToDeploy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
