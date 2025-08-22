import 'package:flutter/material.dart';
import 'package:showing_card/SearchScreen.dart';
import 'package:showing_card/ShowCardsInList.dart';
import 'package:showing_card/StarwarsUnlimitedCard.dart';

import 'Buttonstyle.dart';
import 'SwUDecks.dart';
import 'User.dart';

void main() {}

class DeckBuilderScreen extends StatefulWidget {
  final SWUDecks tempList;

  DeckBuilderScreen({Key? key, SWUDecks? tempList})
      : tempList = tempList ?? SWUDecks(deckname: "Neues Deck"),
        super(key: key);

  @override
  State<DeckBuilderScreen> createState() => _DeckBuilderState();
}

class _DeckBuilderState extends State<DeckBuilderScreen> {

  final myController = TextEditingController();
  
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
            SizedBox(height: 10),
            TextFormField(
              controller: myController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your Deckname',
              ),
            ),
            SizedBox(height: 30),

            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                style: strechedButtonStyle,
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen(searchFromDeckbuildScreen: true)),
                  );

                  ///Add the card to the Temporairy deck
                  if (result != null) {
                    setState(() {
                      widget.tempList.cardsInDeck.add(
                          result); // hier fügst du die Karte hinzu
                    });
                  }
                },
                child: const Text('Add Card'),
              ),
            ),

            ///The Currently Selected Cards are here displayed
            Expanded(
                child: ShowCardsInList(userCards: widget.tempList.cardsInDeck)),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () {
                  ///Creates the Card, when at Least one Card is added to the Deck
                  ///The Deck is either creates by a Custom name or as "Neues Deck"
                  ///Depending if the User entered a Deckname
                  if (widget.tempList.cardsInDeck.isNotEmpty) {
                    if (myController.text.isEmpty) {
                      User.exampleUser.userDecks.add(widget.tempList);
                      Navigator.pop(context);
                    }
                    else {
                      SWUDecks finalUserDeck = SWUDecks(
                          deckname: myController.text);
                      finalUserDeck.cardsInDeck = widget.tempList.cardsInDeck;
                      User.exampleUser.userDecks.add(finalUserDeck);
                      Navigator.pop(context);
                    }
                  }


                  ///Todo: Neue SWUDECK Liste mit namen aus einer Suchleiste erstellen
                  else {
                    final snackbar = SnackBar(
                      content: const Text(
                          'add at least one card to the Deck to save it'),
                      action: SnackBarAction(
                        label: 'Ok',
                        onPressed: () {},
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }


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

///In this calss you can add a Card into a Existing deck
///the Card will be added to that Deck
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
              )
          ),
        ],
        )
    );
  }
}



