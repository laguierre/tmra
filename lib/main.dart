import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmra/pages/intro_page/intro_page.dart';
import 'package:tmra/provider/sensors_provider.dart';
import 'pages/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> SensorsProvider()),
      ],
      child: MaterialApp(
        title: 'TMRA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          /* dark theme settings */
        ),
        home: IntroPage(),
      ),
    );
  }
}
