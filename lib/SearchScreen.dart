import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showing_card/AdvancedFilterScreen.dart';

import 'CollectionScreen.dart';
import 'DBHelper.dart';
import 'StarwarsUnlimitedCard.dart';

void main() {
  runApp(const MyApp());
}

///This is the Search Screen from here you can lookup any card either by their name or by their card Id if needed
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This is the root widget
  // of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Screen',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SearchScreen(searchFromDeckbuildScreen: false,),
    );
  }
}

class SearchScreen extends StatefulWidget {
  ///This boolean is for checking from where the user is coming from, depenting on the Previous screen the cards in the Search Screen are customized
  final bool searchFromDeckbuildScreen;
  const SearchScreen({
    super.key,
    required this.searchFromDeckbuildScreen,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<StarWarsUnlimitedCard>>? futureCards;
  late SearchController _searchController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search for Cards:"),),
      body: Padding(padding: const EdgeInsets.all(8.0),
        child: SearchAnchor(
            searchController: _searchController,
            builder: (BuildContext context, SearchController controller) {
              return Column(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SearchBar(
                    controller: controller,
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    //searches the DB for the given String after pressing Enter
                    onSubmitted: (value) async {
                      // Tastatur schließen
                      FocusScope.of(context).unfocus();
                      List<StarWarsUnlimitedCard> CardList = await fetchbyName(
                          value);
                      setState(() {
                        futureCards = Future.value(CardList);
                      });
                    },
                      trailing: <Widget>[
                        Tooltip(message: "Advanced Filter",
                          child: IconButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdvancedFilterScreen(),
                                  ),
                                );
                                if (result != null && result is List<StarWarsUnlimitedCard>) {
                                  setState(() {
                                    futureCards = Future.value(result);
                                  });
                                }
                              },

                              icon: const Icon(Icons.analytics_outlined)
                          ),
                        ),
                      ]
                  ),
                  if (futureCards != null)
                    FutureBuilder<List<StarWarsUnlimitedCard>>(
                      future: futureCards,
                      builder: (context, snapshot) {
                        ///When the Cards are Being loaded
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Fehler: ${snapshot.error}');
                          ///When a result is found
                        } else if (snapshot.hasData) {
                          final cards = snapshot.data!;
                          return Expanded(
                            ///Building a Grid for the Cards to be Displayed
                              child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // number of items in each row
                              mainAxisSpacing: 9.0, // spacing between rows
                              crossAxisSpacing: 5.0, // spacing between columns
                            ),
                            padding: EdgeInsets.all(9.0),
                            // padding around the grid
                            itemCount: cards.length,
                            // total number of items
                            itemBuilder: (context, index) {
                              final swuCard = cards[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullscreenImagePage(
                                          imageUrl: swuCard.image,
                                          currentCard: swuCard,
                                          buildingDeck: widget.searchFromDeckbuildScreen,
                                        ),
                                      ),
                                    );

                                    if (result != null && widget.searchFromDeckbuildScreen) {
                                      Navigator.pop(context, result); // Ergebnis an A weiterreichen
                                    }
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
                            },
                          )
                          );
                        } else {
                          return const Text('Karte nicht gefunden.');
                        }
                      },
                    ),
                ],
              );
            },
            suggestionsBuilder: (BuildContext context,
                SearchController controller) {
              final List<String> searchTerms = [];
              final query = controller.text;
              final List<String> filtered = searchTerms.where((term) =>
                  term.toLowerCase().contains(query.toLowerCase())
              ).toList();

              //Anzeigen der Gesuchten Karten
              return List<Widget>.generate(filtered.length, (int index) {
                final result = filtered[index];
                return ListTile(
                  title: Text(result),
                  onTap: () async {
                    controller.closeView(result);
                    FocusScope.of(context).unfocus();
                    final card = await fetchCardIDFromTextfield(result);
                    setState(() {
                      futureCards = Future.value(
                          card as FutureOr<List<StarWarsUnlimitedCard>>?);
                    });
                    // setzt den Text und schließt das Suggestion Panel
                    // Optional: etwas mit result machen
                  },
                );
              });
            }
        ),),
    );
  }
}



