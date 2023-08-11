import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> syllables = ['ma', 'ne', 'sa', 'to'];
  List<String> formedWord = [''];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego del Ahorcado'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 300),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: formedWord.asMap().entries.map((entry) {
              final int index = entry.key;
              return DragTarget<String>(
                onAccept: (value) {
                  setState(() {
                    formedWord.removeWhere((element) => element.isEmpty);
                    formedWord.add(value);
                    if (syllables.length > formedWord.length)
                      formedWord.add("");
                    currentIndex = formedWord.length;
                  });
                },
                builder: (context, acceptedItems, rejectedItems) {
                  return Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              formedWord[index],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10)
                    ],
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: syllables
                .where((syllable) => !formedWord.contains(syllable))
                .map((syllable) {
              return Draggable<String>(
                  data: syllable,
                  feedback: Container(
                    width: 50,
                    height: 50,
                    color: Colors.blue.withOpacity(0.7),
                    alignment: Alignment.center,
                    child: Text(
                      syllable,
                    ),
                  ),
                  childWhenDragging: Container(),
                  child: Container(
                    width: 33,
                    height: 33,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: Text(
                      syllable,
                    ),
                  ));
            }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                formedWord.clear();
                formedWord.add("");
                currentIndex = 0;
              });
            },
            child: const Text('Reinicar'),
          ),
        ],
      ),
    );
  }
}
