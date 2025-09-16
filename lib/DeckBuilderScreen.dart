import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:showing_card/SearchScreen.dart';
import 'package:showing_card/ShowCardsInList.dart';
import 'package:showing_card/StarwarsUnlimitedCard.dart';

import 'Buttonstyle.dart';
import 'SwUDecks.dart';
import 'DeckUser.dart';

void main() {}

///In this class a new Deck is Created or an existing Deck is edited
///to create a Deck at least one card needs to be added to the Deck to save it
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
        padding: const EdgeInsets.all(10.0),
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

            ///The Currently Selected Cards are here displayed
            Expanded(
                child: ShowCardsInList(userCards: widget.tempList.cardsInDeck,fromEditScreen: true, userDeck:widget.tempList ,)),
            Align(
              alignment: Alignment.bottomCenter,
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
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () async {
                  ///Creates the Deck, when at Least one Card is added to the Deck
                  ///The Deck is either creates by a Custom name or as "Neues Deck"
                  ///Depending if the User entered a Deckname
                  if (widget.tempList.cardsInDeck.isNotEmpty) {
                    final fbUser = FirebaseAuth.instance.currentUser;

                    if (fbUser == null) return;

                    if (myController.text.isEmpty && !MyUser.currentUser.userDecks.contains(widget.tempList) ) {
                      MyUser.currentUser.userDecks.add(widget.tempList);
                      await widget.tempList.saveDeck(fbUser,widget.tempList);
                      Navigator.pop(context);
                    }
                    ///Ein extierendes deck bekommt keine namesänderung und wird aktualiesiert
                    if (myController.text.isEmpty && MyUser.currentUser.userDecks.contains(widget.tempList) ) {
                      await widget.tempList.saveDeck(fbUser,widget.tempList);
                      Navigator.pop(context);
                    }

                    ///Deck is created with a Custom name
                    else {
                      SWUDecks finalUserDeck = SWUDecks(
                          deckname: myController.text);
                      ///If-case, so if a exsisting deck is edited there will be only one deck and not 2 identical
                      if(MyUser.currentUser.userDecks.contains(widget.tempList)){
                        finalUserDeck.cardsInDeck = widget.tempList.cardsInDeck;
                        MyUser.currentUser.userDecks.add(finalUserDeck);
                        MyUser.currentUser.userDecks.remove(widget.tempList);
                        await finalUserDeck.saveDeck(fbUser,finalUserDeck);
                        Navigator.pop(context);
                      }
                      else{finalUserDeck.cardsInDeck = widget.tempList.cardsInDeck;
                      MyUser.currentUser.userDecks.add(finalUserDeck);
                      await finalUserDeck.saveDeck(fbUser,finalUserDeck);
                      Navigator.pop(context);
                      }

                    }
                  }

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
            SizedBox(height:10),
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

  List<SWUDecks> userDecks = MyUser.currentUser.userDecks;

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
                      title: item.buildTitle(context, MyUser.currentUser, index),
                      subtitle: item.buildSubtitle(context),
                      onTap: () async {
                        userDecks[index].cardsInDeck.add(currentcard);
                      final fbUser = FirebaseAuth.instance.currentUser;
                      if (fbUser != null) {
                        await userDecks[index].saveDeck(fbUser,userDecks[index]);
                      }
                      }
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



