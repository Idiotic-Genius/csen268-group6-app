import 'package:csen268.f24.g6/firebase_options.dart';
<<<<<<< HEAD
import 'package:csen268.f24.g6/pages/splash_screen.dart';
=======
import 'package:csen268.f24.g6/pages/ingame_pages/daytime_page.dart';
import 'package:csen268.f24.g6/pages/ingame_pages/overlays/win_lose_screen.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/Authwrapper.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/game_settings_page.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/home_page.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/login_page.dart';
import 'package:csen268.f24.g6/pages/outgame_pages/profile_page.dart';
>>>>>>> b9bab03 (FLOW DONE)
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersive,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      home: const SplashScreen(),
=======
     home: const DaytimePage(numPlayers: 5, numKillers: 1,),
>>>>>>> 9249cf4 (added integration)
=======
     home: AuthWrapper(),
>>>>>>> b9bab03 (FLOW DONE)
=======
     home: DaytimePage(numPlayers: 5, numKillers: 1),
>>>>>>> 9b1ad18 (FLOW DONE with win screen)
=======
     home: AuthWrapper(),
>>>>>>> 17a01c3 (FLOW DONE with win screen)
    );
  }
}

