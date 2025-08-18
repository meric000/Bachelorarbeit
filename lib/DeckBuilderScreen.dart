import 'package:flutter/material.dart';
import 'package:showing_card/SearchScreen.dart';
import 'package:showing_card/ShowCardsInList.dart';
import 'package:showing_card/StarwarsUnlimitedCard.dart';

import 'Buttonstyle.dart';
import 'SwUDecks.dart';
import 'User.dart';

void main() {}

class DeckBuilderScreen extends StatefulWidget {
  final List<StarWarsUnlimitedCard> tempList;

  DeckBuilderScreen({Key? key, List<StarWarsUnlimitedCard>? tempList})
      : tempList = tempList ?? [],
        super(key: key);

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
                //Todo: Different Buttonstyle for this button
                style: raisedButtonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen(searchFromDeckbuildScreen: true)),
                  );
                },
                child: const Text('Add Card'),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Selected Cards:'),
            const SizedBox(height: 8),
            const Spacer(),
            Expanded(child: ShowCardsInList(userCards: widget.tempList)),
            Align(
              alignment: Alignment.bottomCenter,
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


class ChooseDeckPage extends StatelessWidget {

   ChooseDeckPage({required this.currentcard});

   final StarWarsUnlimitedCard currentcard;

  List<SWUDecks> userDecks = User.exampleUser.userDecks;

  @override
  Widget build(BuildContext context,) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Choose Deck to add Card"),
          leading:BackButton(onPressed: () => Navigator.pop(context) ,),
          backgroundColor: Colors.blueAccent,),

        body: Column(children: [
          SizedBox(height: 20),
          Expanded(
              child: ListView.builder(
                itemCount: userDecks.length,
                itemBuilder: (context, index) {
                  final item = userDecks[index];
                  return Card(
                    margin: EdgeInsets.all(5),
                    color: Colors.grey,
                    elevation: 3,
                    child: ListTile(
                      title: item.buildTitle(context, User.exampleUser, index),
                      subtitle: item.buildSubtitle(context),
                      onTap: () {userDecks[index].cardsInDeck.add(currentcard);}
                    ),
                  );
                },
              )),

        ],
        )
    );
  }
}



