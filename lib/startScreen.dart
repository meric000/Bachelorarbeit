import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'searchScreen.dart';
import 'collectionScreen.dart';




void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;


  @override
  void initState() {
    super.initState();
    _screens = [
      _buildCardScreen(),         // Der Hauptbildschirm
      SearchScreen(),       // Dein zweiter Screen
      CollectionScreen(), // Placeholder für dritten Screen
    ];
  }

  //methode um aktuellen Screen auf der NavBar zu zeigen
  void _onItemTapped(int index) {
    setState(() {
      if(_selectedIndex > 2 || _selectedIndex < 0)
      {_selectedIndex = 0;}
      _selectedIndex = index;
    });
  }


  //shows one Card on the Screen
  Widget _buildCardScreen(){
    return Padding(padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
          Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            style: raisedButtonStyle,
            onPressed: () {
              // Aktion hier
            },
            child: const Text('Add Deck'),
          ),
        ),
            const SizedBox(height: 12),
          ],
        ),
    );
  }


  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black,
    backgroundColor: Colors.deepPurpleAccent,
    minimumSize: Size(58, 36),
    padding: EdgeInsets.symmetric(horizontal: 8),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      title: 'Karte anzeigen',
      home: Scaffold(
        appBar: AppBar(title: const Text('SWU Cardfinder Pro Delux ++')),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _screens[_selectedIndex],
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const<BottomNavigationBarItem>[
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
          ), //NavBar unten im Screen
      ),
    );
  }
}


