import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kimsong_ui_testing/pages/outgame_pages/game_settings_page.dart';
import 'package:kimsong_ui_testing/pages/outgame_pages/home_page.dart';
import 'package:kimsong_ui_testing/pages/outgame_pages/profile_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Remove overlays for immersion
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersive
  );
  // Lock orientation to landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kimsong UI Testing',
      home: ProfilePage(),
    );
  }
}