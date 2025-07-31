import 'package:flutter/material.dart';
import 'searchScreen.dart';
import 'collectionScreen.dart';
import 'deckBuilderScreen.dart';
import 'buttonstyle.dart';

void main() => runApp(const MyApp());

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
      deckBuilderScreen(),
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
                  MaterialPageRoute(builder: (context) => deckBuilderScreen()),
                );
              },
              child: const Text('Add Deck'),
            ),
          ),
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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