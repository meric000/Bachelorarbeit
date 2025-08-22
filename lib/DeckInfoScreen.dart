import 'package:flutter/material.dart';
import 'package:showing_card/SwUDecks.dart';

import 'ShowCardsInList.dart';

void main() {}

class DeckStatsScreen extends StatelessWidget {
  final SWUDecks deck;
  const DeckStatsScreen({super.key, required this.deck});


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
              Expanded(
                  child: ShowCardsInList(
                      userCards: deck.cardsInDeck)),
            ],
          ),
        ),
      ),
    );
  }
}
