import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'searchScreen.dart';


Future<CardDeck> fetchCardById(String setCode, String number) async {
  final url = 'https://api.swu-db.com/cards/$setCode/$number';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Serverfehler: ${response.statusCode}');
  }

  final Map<String, dynamic> json = jsonDecode(response.body);
  return CardDeck.fromJson(json);
}

class CardDeck{

  final String cardId;
  final String name;
  final String image;

  const CardDeck({required this.cardId, required this.name, required this.image});

  factory CardDeck.fromJson(Map<String, dynamic> json) {
    // Kombiniere Set und Number zu einer ID
    final id = "${json['Set']}-${json['Number']}";
    // Setze Name und Subtitle zusammen
    final fullName = json['Subtitle'] != null
        ? "${json['Name']} – ${json['Subtitle']}"
        : json['Name'];

    return CardDeck(
      cardId: id,
      name: fullName,
      image: json['FrontArt'],      // genau wie im JSON
    );
  }
  
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  late Future<CardDeck> futureCardDeck;
  late final List<Widget> _screens;


  @override
  void initState() {
    super.initState();
    futureCardDeck = fetchCardById('TWI','148');
    _screens = [
      _buildCardScreen(),         // Der Hauptbildschirm
       SearchScreen(),       // Dein zweiter Screen
      const Center(child: Text('Collection')), // Placeholder für dritten Screen
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

  Widget _buildCardScreen(){
    return Center(
      child: FutureBuilder<CardDeck>(
        future: futureCardDeck,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Fehler: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final card = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(card.image, height: 500),
                const SizedBox(height: 16),
                Text(card.name, style: const TextStyle(fontSize: 20)),
                Text("ID: ${card.cardId}"),
              ],
            );
          } else {
            return const Text('Karte nicht gefunden.');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      title: 'Karte anzeigen',
      home: Scaffold(
        appBar: AppBar(title: const Text('Karte(n) anzeigen')),
          body: _screens[_selectedIndex],
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
          ),//NavBar unten im Screen
      ),
    );
  }
}


