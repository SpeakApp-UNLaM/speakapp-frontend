import 'package:flutter/material.dart';
import '../widgets/button_home_exercise.dart';
import '../widgets/button_home_messages.dart';
import '../widgets/button_home_turns.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home-principal';

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home principal'),
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonHomeExercise(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonHomeMessages(),
                SizedBox(width: 20),
                ButtonHomeTurns(),
              ],
            )
          ],
        ));
  }
}
