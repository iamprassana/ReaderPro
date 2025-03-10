// import 'package:firebase_remote_config/firebase_remote_config.dart';
//
// class GETAPI {
//   static final FirebaseRemoteConfig _remoteConfig =
//       FirebaseRemoteConfig.instance;
//
//   static Future<void> initialise() async {
//     await _remoteConfig.setConfigSettings(
//       RemoteConfigSettings(
//         fetchTimeout: const Duration(microseconds: 10),
//         minimumFetchInterval: const Duration(hours: 2),
//       ),
//     );
//     await _remoteConfig.fetchAndActivate();
//   }
//
//   static String apiKey() {
//     return _remoteConfig.getString('GEMINI_API_KEY');
//   }
// }
