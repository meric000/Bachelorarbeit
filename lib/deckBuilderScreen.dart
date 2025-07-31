import 'package:flutter/material.dart';
import 'buttonstyle.dart';

void main() {}

class deckBuilderScreen extends StatefulWidget {
  @override
  State<deckBuilderScreen> createState() => _deckBuilderState();
}

class _deckBuilderState extends State<deckBuilderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deck Builder'),
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
                  // TODO: Karte hinzufügen
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
