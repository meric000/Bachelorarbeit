import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:showing_card/SwUDecks.dart';
import 'StarwarsUnlimitedCard.dart';

class MyUser {

  final String name;
  final String eMail;
  List<StarWarsUnlimitedCard> collection = [];
  List<SWUDecks> userDecks = [];


  MyUser({
    required this.name,
    required this.eMail,
    List<StarWarsUnlimitedCard>? collection,
    List<SWUDecks>? userDecks,
  })  : collection = collection ?? [],
        userDecks = userDecks ?? [];


  factory MyUser.fromFirebase(firebase_auth.User fbUser) {
    return MyUser(
      name: fbUser.displayName ?? "Unbekannt",
      eMail: fbUser.email ?? "",
    );
  }

  // Firestore-Integration
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'eMail': eMail,
      'collection': collection.map((c) => c.toMap()).toList(),
      'userDecks': userDecks.map((d) => d.toMap()).toList(),
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      name: map['name'] ?? '',
      eMail: map['eMail'] ?? '',
      collection: (map['collection'] as List)
          .map((c) => StarWarsUnlimitedCard.fromMap(c))
          .toList(),
      userDecks: (map['userDecks'] as List)
          .map((d) => SWUDecks.fromMap(d))
          .toList(),
    );
  }


  static MyUser exampleUser = MyUser(name:"user", eMail:"eMail");

}