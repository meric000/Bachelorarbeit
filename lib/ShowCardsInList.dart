import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showing_card/SwUDecks.dart';
import 'CollectionScreen.dart';
import 'StarwarsUnlimitedCard.dart';


///This is a Helperclass to show a List of SWU-Cards on a Grid, this class only work with a List of SWU cards
class ShowCardsInList extends StatelessWidget {

  final List<StarWarsUnlimitedCard> userCards;
  const ShowCardsInList({super.key, required this.userCards});

  @override
  Widget build(BuildContext context) {
    SizedBox(height:15);
    if (userCards.isEmpty) {
      return const Center(
          child: Text("No Cards in Collection, add some if you want"));
    } else if (userCards.isNotEmpty) {
      return Expanded(child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of items in each row
          mainAxisSpacing: 9.0, // spacing between rows
          crossAxisSpacing: 5.0, // spacing between columns
        ),
        padding: EdgeInsets.all(9.0),
        // padding around the grid
        itemCount: userCards.length,
        itemBuilder: (BuildContext context, int index) {
          final swuCard = userCards[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FullscreenImagePage(
                            imageUrl: swuCard.image,  buildingDeck: false, currentCard: swuCard,),
                    ),
                  );
                },
                child: Hero(
                  /**cards are shown*/
                  tag: swuCard.image,
                  child: Image.network(
                    swuCard.image, height: 120,
                  ),
                ),
              ),
              /**the information from the cards*/
              const SizedBox(height: 9),
              Text(swuCard.name,
                  style: const TextStyle(fontSize: 10)),
              Text("ID: ${swuCard.cardId}"),
            ],
          );
        },));
    } else {
      return const Center(child: Text('Karte nicht gefunden.'));
    }
  }
}