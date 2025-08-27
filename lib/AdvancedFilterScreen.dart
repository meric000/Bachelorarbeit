import 'package:flutter/material.dart';

enum aspects { Vigilance, Heroism, Aggression, Cunning, Villainy, Command }

class AdvancedFilterScreen extends StatefulWidget {
  const AdvancedFilterScreen({super.key});

  @override
  State<AdvancedFilterScreen> createState() => _AdvancedFilterState();
}

class _AdvancedFilterState extends State<AdvancedFilterScreen> {
  static const List<Widget> inclusion = <Widget>[
    Text("Exactly these aspects"),
    Text("Including these aspects"),
    Text("At most these aspects"),
  ];

  final myControllerForCardname = TextEditingController();
  final myControllerForText = TextEditingController();
  Set<aspects> _segmentButtonSelection = <aspects>{aspects.Aggression};
  final List<bool> isSelected = <bool>[
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Filter'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextFormField(
              controller: myControllerForCardname,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter the Name of the Card(s) you are looking for',
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Card Text",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextFormField(
              controller: myControllerForText,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter a Buzzword to look search',
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              children: [
                ToggleButtons(
                  isSelected: isSelected,
                  onPressed: (int index) {
                    setState(() {
                      isSelected[index] = !isSelected[index];
                    });
                  },
                  selectedColor: Colors.white,       // Farbe des Icons/Text beim Klick
                  fillColor: Colors.blueAccent,      // Hintergrundfarbe beim Klick
                  color: Colors.black,               // normale Farbe
                  borderRadius: BorderRadius.circular(8),
                  children: <Widget>[
                    Image.asset("assets/images/SWH_Aspects_Aggression.png",width: 50,),
                    Image.asset("assets/images/SWH_Aspects_Command.png",width: 50,),
                    Image.asset("assets/images/SWH_Aspects_Cunning.png",width: 50,),
                    Image.asset("assets/images/SWH_Aspects_Heroism.png",width: 50,),
                    Image.asset("assets/images/SWH_Aspects_Vigilance.png",width: 50,),
                    Image.asset("assets/images/SWH_Aspects_Villainy.png",width: 50,),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
