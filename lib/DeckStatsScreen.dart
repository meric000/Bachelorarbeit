import 'package:flutter/material.dart';

void main() {}

class DeckStatsScreen extends StatelessWidget {
  const DeckStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Edit your own Deck",
      home: Scaffold(
        appBar: AppBar(title: Text("Your Deck statistics:"),
          leading:BackButton(onPressed: () => Navigator.pop(context) ,),
            backgroundColor: Colors.purple,),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Interesting stat 1'),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Interesting stat 2'),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Interesting stat 3'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
