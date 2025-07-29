import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:showing_card/searchScreen.dart';

Future<CardDeck> fetchCardById(String setCode, String number) async {
  final url = 'https://api.swu-db.com/cards/$setCode/$number';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Serverfehler: ${response.statusCode}');
  }

  final Map<String, dynamic> json = jsonDecode(response.body);
  return CardDeck.fromJson(json);
}

class CardDeck {
  final String cardId;
  final String name;
  final String image;

  const CardDeck({
    required this.cardId,
    required this.name,
    required this.image,
  });

  factory CardDeck.fromJson(Map<String, dynamic> json) {
    // Kombiniere Set und Number zu einer ID
    final id = "${json['Set']}-${json['Number']}";
    // Setze Name und Subtitle zusammen
    final fullName =
        json['Subtitle'] != null
            ? "${json['Name']} – ${json['Subtitle']}"
            : json['Name'];

    return CardDeck(
      cardId: id,
      name: fullName,
      image: json['FrontArt'], // genau wie im JSON
    );
  }
}

void main() {
  runApp(const MyApp());
}

class _MyApp extends StatelessWidget {
  const _MyApp({Key? key}) : super(key: key);

  // This is the root widget
  // of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'This is your Cards',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SearchScreen(),
    );
  }
}

class CollectionScreen extends StatefulWidget {
  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  late Future<CardDeck> futureCardDeck;

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
  Widget build(BuildContext context) {
    futureCardDeck = fetchCardById('TWI', '146');
    return Center(
      child: FutureBuilder<CardDeck>(
        future: futureCardDeck,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final card = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton(
                    style: raisedButtonStyle,
                    onPressed: () {
                      // Aktion hier
                    },
                    child: const Text('Add Card to Collection'),
                  ),
                ),

                Image.network(card.image, height: 580),
                const SizedBox(height: 16),
                Text(card.name, style: const TextStyle(fontSize: 20)),
                Text("ID: ${card.cardId}"),
              ],
            );
          } else {
            return const Center(child: Text('Karte nicht gefunden.'));
          }
        },
      ),
    );
  }
}
