import 'package:flutter/material.dart';

import 'buttonstyle.dart';
import 'collectionScreen.dart';
import 'deckBuilderScreen.dart';
import 'searchScreen.dart';
import 'DeckStatsScreen.dart';

void main() => runApp(const MyApp());

const String deckname = "Deckname Placeholder";

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
      SearchScreen(),
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
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeckStatsScreen(),
              ),
            );},
            child: Container(
              color: Colors.grey,
              width: 380.0,
              height: 80.0,
              alignment: Alignment.center,
              child: Text(deckname,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.white)),

            ),
          ),

          const Spacer(),
          const SizedBox(height: 12),
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