import 'package:flutter/material.dart';
import 'package:showing_card/DeckBuilderScreen.dart';
import 'package:showing_card/ShowCardsInList.dart';

import 'DBHelper.dart';
import 'StarwarsUnlimitedCard.dart';
import 'User.dart';



void main() {
  runApp(const MaterialApp(
    title: 'SWU Cardfinder',
    home: CollectionScreen(), // oder Scaffold mit BottomNav
  )
  );
}


class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  ///checks if a Card is in the CollectionList of a User
  bool checkIfCardIsInCollection(StarWarsUnlimitedCard card, User user) {
    if (user.collection.contains(card)) {
      return true;
    }
    return false;
  }

  late Future<StarWarsUnlimitedCard> futureCard;
  List<StarWarsUnlimitedCard> userCards = User.exampleUser.collection;


  @override
  Widget build(BuildContext context) {
    futureCard = fetchCardById('TWI', '147');
    return Center(
      child: FutureBuilder<StarWarsUnlimitedCard>(
        future: futureCard,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Karte nicht gefunden.'));
          } else {
            return Expanded(
              child: ShowCardsInList(userCards: userCards),
            );
          }
        },
      ),
    );
  }
}

class FullscreenImagePage extends StatelessWidget {
  final String imageUrl;
  final StarWarsUnlimitedCard currentCard;
  final bool buildingDeck;


  const FullscreenImagePage(
      {super.key, required this.imageUrl, required StarWarsUnlimitedCard this.currentCard, required this.buildingDeck});

  static const bool isCardinCollection = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Column(
          children: [
            Hero(
              tag: imageUrl,
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
            const Text(
              'Tap on Card to return', style: TextStyle(color: Colors.white),),

            ///Buttons are olny shown, when currently a deck isn´t beeing build
            if (!buildingDeck) ...[
              ElevatedButton(
                onPressed: () async {
                  if (_CollectionScreenState()
                      .checkIfCardIsInCollection(
                      currentCard, User.exampleUser)) {
                    User.exampleUser.collection.remove(currentCard);
                  } else {
                    User.exampleUser.collection.add(currentCard);
                  }
                },
                child: Text(
                  _CollectionScreenState().checkIfCardIsInCollection(
                      currentCard, User.exampleUser)
                      ? "remove Card from collection"
                      : "add card to collection",
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChooseDeckPage(currentcard: currentCard),
                    ),
                  );
                },
                child: const Text("Add card to Existing Decks"),
              ),
            ],
            if(buildingDeck)
              ElevatedButton(onPressed: () {
                Navigator.pop(context, currentCard); // Karte zurückgeben
              },
                  child: Text("Add this card to new Deck")),
          ],
        ),
      ),
    );
  }
}

