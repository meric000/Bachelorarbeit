import 'package:flutter/material.dart';
import 'package:showing_card/searchScreen.dart';
import 'buttonstyle.dart';

void main() {}

class DeckBuilderScreen extends StatefulWidget {
  @override
  State<DeckBuilderScreen> createState() => _DeckBuilderState();
}

class _DeckBuilderState extends State<DeckBuilderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deck Builder'), backgroundColor: Colors.yellow,
      ),
      backgroundColor: Colors.white, // Hier explizit der weiße Hintergrund
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
                child: const Text('Add Card'),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Selected Cards:'),
            const SizedBox(height: 8),
            Container(
              color: Colors.green,
              width: 80.0,
              height: 180.0,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () {
                  // TODO: Deck erstellen
                },
                child: const Text('Build Deck'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
