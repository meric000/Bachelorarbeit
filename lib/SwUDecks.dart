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

  buildTitle(BuildContext context, User currUser, int index) {
    return Text(
      currUser.userDecks[index].deckname,
      style: Theme
          .of(context)
          .textTheme
          .headlineSmall,
    );
  }

  buildSubtitle(BuildContext context) => const SizedBox.shrink();

  static SWUDecks dummyDeck = SWUDecks(deckname: "guterDeckname");

}
