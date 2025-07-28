import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


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
  late Future<CardDeck> futureCardDeck;

  @override
  void initState() {
    super.initState();
    futureCardDeck = fetchCardById('TWI','148');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Karte anzeigen',
      home: Scaffold(
        appBar: AppBar(title: const Text('Karten anzeigen')),
        body: Center(
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
                    Image.network(card.image, height: 250),
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
        ),
      ),
    );
  }
}


