import 'package:showing_card/SwUDecks.dart';

import 'StarwarsUnlimitedCard.dart';

class User {

  final String name;
  final String password;
  final String eMail;
  List<StarWarsUnlimitedCard> collection = [];
  List<SWUDecks> userDecks = [SWUDecks.dummyDeck];

   User(this.name, this.password, this.eMail);


  static User exampleUser = User("user", "password", "eMail");

}



