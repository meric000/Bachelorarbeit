import 'package:flutter/material.dart';

import 'Buttonstyle.dart';
import 'CollectionScreen.dart';
import 'DeckBuilderScreen.dart';
import 'DeckInfoScreen.dart';
import 'SearchScreen.dart';
import 'User.dart';

void main() => runApp(const MyApp());

const String deckname = "Deckname Placeholder";

///This is the Startscreen, where The user will get, after he is logged in.
///The User Decks are Displayed here can be edited from this screen
///The other Mainscreens(Search- and Collectionscreen) can be accessed from here
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Karte anzeigen',
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _buildScreens(BuildContext context) {
    return [
      _buildCardScreen(context),
      SearchScreen(searchFromDeckbuildScreen: false,),
      CollectionScreen(),
      DeckBuilderScreen(),
    ];
  }

  Widget _buildCardScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeckBuilderScreen()),
                );
              },
              child: const Text('Add Deck'),
            ),
          ),Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // number of items in each row
                mainAxisSpacing: 9.0, // spacing between rows
                childAspectRatio: 3.0,
              ),
              padding: EdgeInsets.all(19.0),
              itemCount: User.exampleUser.userDecks.length,
              itemBuilder: (BuildContext context, int index) {
                final deck = User.exampleUser.userDecks[index];
                return Hero(
                  tag: deck,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets
                              .zero, // Damit der Container das Layout bestimmt
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeckStatsScreen(deck: deck),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.deepPurple,
                      alignment: Alignment.center,
                      child: Text(
                        deck.deckname,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = _buildScreens(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SWU Cardfinder Pro Delux ++'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Decks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search for Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Collection',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[800],
        onTap: _onItemTapped,
      ),
    );
  }
}