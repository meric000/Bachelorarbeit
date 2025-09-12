import 'package:flutter/material.dart';
import 'package:showing_card/DeckBuilderScreen.dart';
import 'package:showing_card/ShowCardsInList.dart';
import 'package:showing_card/SwUDecks.dart';

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

///This is the CollectionScreen, where the Collection of the User can be seen and edited
class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  ///checks if a Card is in the CollectionList of a User
  bool checkIfCardIsInCollection(StarWarsUnlimitedCard card, MyUser user) {
    if (user.collection.contains(card)) {
      return true;
    }
    return false;
  }

  late Future<StarWarsUnlimitedCard> futureCard;
  List<StarWarsUnlimitedCard> userCards = MyUser.exampleUser.collection;


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
              child: ShowCardsInList(
                userCards: userCards, fromEditScreen: false,),
            );
          }
        },
      ),
    );
  }
}

///This Class has the Purpose to show a SWU-Card on the full screen
///The Buttons are show depending from which screen the user is coming from
class FullscreenImagePage extends StatelessWidget {
  final String imageUrl;
  final StarWarsUnlimitedCard currentCard;
  final bool buildingDeck;
  final SWUDecks? currentUserDeck;


  const FullscreenImagePage(
      {super.key, required this.imageUrl, required StarWarsUnlimitedCard this.currentCard, required this.buildingDeck, this.currentUserDeck});

  static const bool isCardinCollection = true;


  @override
  Widget build(BuildContext context) {
    ///transforms the cards Attributes to a List of Strings
    final Map<String, dynamic> details = {
      "Name": currentCard.name,
      "Arena": currentCard.arena,
      "Type": currentCard.type,
      "Aspects": currentCard.aspects.join(", "),
      "Traits": currentCard.traits.join(", "),
      "Cost": currentCard.cost,
      "Power": currentCard.power,
      "HP": currentCard.hp,
      "Rarity": currentCard.rarity,
      "Unique": currentCard.unique ? "Yes" : "No",
      "Artist": currentCard.artist,
      "Variant Type": currentCard.variantType,
      "Market Price": "${currentCard.marktPrice}€",
      "Foil Price": "${currentCard.foilPrice}€",
    };
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
          child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(height: 15,),
            Text("Cardname" + currentCard.name,
                style: TextStyle(color: Colors.white)),
            Hero(
                tag: imageUrl,
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),

            if(currentCard.backArt.length > 21)...[
              Text("Backart:",
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
              Hero(tag: currentCard.backArt,
                  child: Image.network(
                      currentCard.backArt, fit: BoxFit.contain)),

            ],
            ...details.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "${entry.key}: ${entry.value}",
                  style: const TextStyle(color: Colors.white, fontSize: 16,),textAlign: TextAlign.left,
                ),
              );
            }).toList(),

            ///Buttons are only shown, when currently a deck isn´t  build or edited
            if (!buildingDeck) ...[
              ElevatedButton(
                onPressed: () async {
                  if (_CollectionScreenState()
                      .checkIfCardIsInCollection(
                      currentCard, MyUser.exampleUser)) {
                    MyUser.exampleUser.collection.remove(currentCard);

                    ///Todo: Change buttontext on press
                  } else {
                    MyUser.exampleUser.collection.add(currentCard);
                  }
                },
                child: Text(
                  _CollectionScreenState().checkIfCardIsInCollection(
                      currentCard, MyUser.exampleUser)
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
                child: const Text("Add Card to Existing Decks"),
              ),
            ],

            if(buildingDeck)
              if(!MyUser.exampleUser.userDecks.contains(currentUserDeck))
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, currentCard); // Karte zurückgeben
                    },
                    child: Text("Add this card to new Deck")),

            if(MyUser.exampleUser.userDecks.contains(currentUserDeck))
              ElevatedButton(
                  onPressed: () {
                    currentUserDeck?.cardsInDeck.remove(currentCard);
                    Navigator.pop(context, currentCard); // Karte zurückgeben
                  },
                  child: Text("Remove this card From the Deck")),
          ],
          ),)


      ),
    );
  }
}

