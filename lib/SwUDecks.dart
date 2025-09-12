import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:showing_card/StarwarsUnlimitedCard.dart';
import 'package:showing_card/User.dart';
import 'package:uuid/uuid.dart';


class SWUDecks{
  List<StarWarsUnlimitedCard> cardsInDeck=[];
  final String deckname;
  int get decksize => cardsInDeck.length;
  var id = Uuid().v4();

  SWUDecks({required this.deckname});

  buildTitle(BuildContext context, MyUser currUser, int index) {
    return Text(
      currUser.userDecks[index].deckname,
      style: Theme
          .of(context)
          .textTheme
          .headlineSmall,
    );
  }

  /// Baut eine Map für Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deckname': deckname,
      'cardsInDeck': cardsInDeck.map((c) => c.toMap()).toList(),
    };
  }

  /// Baut aus Firestore-Daten wieder ein Deck
  factory SWUDecks.fromMap(Map<String, dynamic> map) {
    final deck = SWUDecks(deckname: map['deckname'] ?? '');
    deck.cardsInDeck = (map['cardsInDeck'] as List? ?? [])
        .map((c) => StarWarsUnlimitedCard.fromMap(c))
        .toList();
    // ID setzen, falls vorhanden
    if (map['id'] != null) {
      deck.id = map['id'];
    }
    return deck;
  }


  buildSubtitle(BuildContext context) => const SizedBox.shrink();

  static SWUDecks dummyDeck = SWUDecks(deckname: "guterDeckname");

}
