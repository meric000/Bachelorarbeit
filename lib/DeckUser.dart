import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory MyUser.fromFirebaseDoc(String uid, Map<String, dynamic> map) {
    return MyUser(
      name: map['name'] ?? '',
      eMail: map['eMail'] ?? '',
    );
  }

  static Future<MyUser> loadUser(String uid) async {
    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!userDoc.exists) {
      throw Exception("User not found");
    }

    final user = MyUser.fromFirebaseDoc(uid, userDoc.data()!);

    final deckSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('decks')
        .get();

    if (deckSnapshots.docs.isNotEmpty) {
      user.userDecks =
          deckSnapshots.docs.map((doc) => SWUDecks.fromMap(doc.data())).toList();
    } else {
      final data = userDoc.data();
      if (data != null && data['userDecks'] != null) {
        user.userDecks = (data['userDecks'] as List)
            .map((d) => SWUDecks.fromMap(Map<String, dynamic>.from(d)))
            .toList();
      }
    }

    final collectionSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('collection')
        .get();

    if (collectionSnapshots.docs.isNotEmpty) {
      user.collection = collectionSnapshots.docs
          .map((doc) => StarWarsUnlimitedCard.fromMap(doc.data()))
          .toList();
    } else {
      // Fallback: Collection aus User-Dokument
      final data = userDoc.data();
      if (data != null && data['collection'] != null) {
        user.collection = (data['collection'] as List)
            .map((c) =>
            StarWarsUnlimitedCard.fromMap(Map<String, dynamic>.from(c)))
            .toList();
      }
    }

    return user;

    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'eMail': eMail,

    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      name: map['name'] ?? '',
      eMail: map['eMail'] ?? '',
    );
  }




  static MyUser currentUser = MyUser(name:"user", eMail:"eMail");

}