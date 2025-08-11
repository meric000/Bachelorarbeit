import 'package:flutter/material.dart';
import 'package:showing_card/searchScreen.dart';
import 'DBHelper.dart';
import 'StarwarsUnlimitedCard.dart';
import 'buttonstyle.dart';



void main() {
  runApp(const MaterialApp(
    title: 'SWU Cardfinder',
    home: CollectionScreen(), // oder Scaffold mit BottomNav
  )
  );
}


class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {

  late Future<StarWarsUnlimitedCard> futureCard;


  @override
  Widget build(BuildContext context) {
    futureCard = fetchCardById('TWI', '147');
    return Center(
      child: FutureBuilder<StarWarsUnlimitedCard>(
        future: futureCard,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final swuCard = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullscreenImagePage(imageUrl: swuCard.image),
                      ),
                    );
                  },
                  child: Hero(
                    tag: swuCard.image,
                    child: Image.network(swuCard.image, height: 160, fit: BoxFit.cover),
                  ),
                ),
                //Abstand zwischen karte und Text
                const SizedBox(height: 10),
                Text(swuCard.name, style: const TextStyle(fontSize: 10)),
                Text("ID: ${swuCard.cardId}"),


                //Knopf zum Hinzufügen einer Karte in die Sammlung
                Expanded(
                  child:
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                      },
                      child: const Text('Add Card to Collection'),
                    ),
                  ),
                ),

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
class FullscreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullscreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Column(
          children: [
            Hero(
            tag: imageUrl,
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ), const Text('Tap on Card to return', style: TextStyle(color:Colors.white),),
          ],
        ),
      ),
    );
  }
}