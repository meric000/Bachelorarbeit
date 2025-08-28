import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:showing_card/Buttonstyle.dart';

enum aspects { Vigilance, Heroism, Aggression, Cunning, Villainy, Command }

final List<bool> aspectIsSelected = <bool>[
  false,
  false,
  false,
  false,
  false,
  false,
];
final List<bool> rarityIsSelected = <bool>[
  false,
  false,
  false,
  false,
  false,
];

final List<bool> dispalyModeIsSelected = <bool>[
  false,
  false,
];




class AdvancedFilterScreen extends StatefulWidget {
  const AdvancedFilterScreen({super.key});

  @override
  State<AdvancedFilterScreen> createState() => _AdvancedFilterState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _AdvancedFilterState extends State<AdvancedFilterScreen> {

  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    arena.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );

  static final List<MenuEntry> categorieMenuEntries = UnmodifiableListView<
      MenuEntry>(
    categories.map<MenuEntry>((String name) =>
        MenuEntry(value: name, label: name)),
  );

  static final List<MenuEntry> typesMenuEntries = UnmodifiableListView<
      MenuEntry>(
    types.map<MenuEntry>((String name) =>
        MenuEntry(value: name, label: name)),
  );


  static List<String> inclusion = <String>[
    "Exactly these aspects",
    "Including these aspects",
    "At most these aspects",
  ];
  static List<String> stats = <String>[
    "Cost",
    "Hp",
    "Power",
  ];
  static List<String> statsmodifier = <String>[
    "=",
    "<",
    ">",
    "<=",
    ">=",
    "!= (not equal)"
  ];

  static List<String> arena = <String>[
    "",
    "Ground",
    "Space",
  ];

  static List<String> sortingOptions = <String>[
    "name",
    "type",
    "arenas",
    "aspects",
    "power",
    "hp",
    "cost",
    "traits",
    "rairty",
    "setnumber",
    "artist"
  ];

  static List<String> categories = [
    " ",
    "BOUNTY HUNTER",
    "CAPITAL SHIP",
    "CLONE",
    "CONDITION",
    "CREATURE",
    "DISASTER",
    "DROID",
    "EWOK",
    "FIGHTER",
    "FIRST ORDER",
    "FORCE",
    "FRINGE",
    "GAMBIT",
    "GUNGAN",
    "HUTT",
    "IMPERIAL",
    "INNATE",
    "INQUISITOR",
    "ITEM",
    "JAWA",
    "JEDI",
    "KAMINOAN",
    "LAW",
    "LEARNED",
    "LIGHTSABER",
    "MANDALORIAN",
    "MODIFICATION",
    "NABOO",
    "NEW REPUBLIC",
    "NIGHT",
    "NIHIL",
    "OFFICIAL",
    "PILOT",
    "PLAN",
    "REBEL",
    "REPUBLIC",
    "RESISTANCE",
    "SEPARATIST",
    "SITH",
    "SPECTRE",
    "SPEEDER",
    "SUPPLY",
    "TACTIC",
    "TANK",
    "TRANSPORT",
    "TRICK",
    "TROOPER",
    "TUSKEN",
    "TWI'LEK",
    "UNDEAD",
    "UNDERWORLD",
    "WALKER",
    "WEAPON",
    "WOOKIE",
  ];


  final List<String?> selectedCategories = [null];

  static List<String> types = [
    " ",
    "Base",
    "Event",
    "Leader",
    "Unit",
    "Upgrade"
  ];
  final List<String?> selectedTypes = [null];

  String inclusiondropdownValue = inclusion.first;
  String statsDropdownValue = stats.first;
  String statsModifierDropdownValue = statsmodifier.first;
  String sortOptionsModifierDropdownValue = sortingOptions.first;

  String arenadropdownValue = arena.first;

  final myControllerForCardname = TextEditingController();

  final myControllerForText = TextEditingController();

  final myControllerForStats = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Filter'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ///Textfield for the Cardnames
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

            ///Textfield for the Cardtext
            TextFormField(
              controller: myControllerForText,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter a Buzzword to look search',
              ),
            ),
            SizedBox(height: 10),

            ///The Aspects for a Card
            Text(
              "Choose Aspect(s)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Wrap(
              children: [
                ToggleButtons(
                  isSelected: aspectIsSelected,
                  onPressed: (int index) {
                    setState(() {
                      aspectIsSelected[index] = !aspectIsSelected[index];
                    });
                  },
                  selectedColor: Colors.white,       // Farbe des Icons/Text beim Klick
                  fillColor: Colors.blueAccent,      // Hintergrundfarbe beim Klick
                  color: Colors.black,               // normale Farbe
                  borderRadius: BorderRadius.circular(8),
                  children: <Widget>[
                    Image.asset(
                      "assets/images/SWH_Aspects_Vigilance.png", width: 64,),
                    Image.asset(
                      "assets/images/SWH_Aspects_Heroism.png", width: 64,),
                    Image.asset(
                      "assets/images/SWH_Aspects_Aggression.png", width: 64,),
                    Image.asset(
                      "assets/images/SWH_Aspects_Cunning.png", width: 64,),
                    Image.asset(
                      "assets/images/SWH_Aspects_Villainy.png", width: 64,),
                    Image.asset(
                      "assets/images/SWH_Aspects_Command.png", width: 64,),
                  ],
                ),
                DropdownButton<String>(
                  value: inclusiondropdownValue,
                  elevation: 26,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      inclusiondropdownValue = value!;
                    });
                  },
                  items: inclusion.map<DropdownMenuItem<String>>((
                      String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 10),

            Text(
                "Choose Rarity",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ToggleButtons(
              isSelected: rarityIsSelected,
              onPressed: (int index) {
                setState(() {
                  rarityIsSelected[index] = !rarityIsSelected[index];
                });
              },
              selectedColor: Colors.white,
              // Farbe des Icons/Text beim Klick
              fillColor: Colors.blueAccent,
              // Hintergrundfarbe beim Klick
              color: Colors.black,
              // normale Farbe
              borderRadius: BorderRadius.circular(8),
              children: <Widget>[
                Text("Common"),
                Text("Uncommon"),
                Text("Rare"),
                Text("Legendary"),
                Text("Special")
              ],
            ),

            ///The Arenas a Card can have
            Text("Arena",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

            DropdownMenu<String>(
              initialSelection: arena.first,
              onSelected: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  arenadropdownValue = value!;
                });
              },
              dropdownMenuEntries: menuEntries,
            ),
            SizedBox(height: 5,),

            ///The Categories of a Card
            Text("Choose the Categories you like to Search for",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

            ///Generates a New DropdownMenu everytime a Categorie is selected
            ...List.generate(selectedCategories.length, (index) {
              return Padding(padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: DropdownMenu<String>(
                    initialSelection: selectedCategories[index],
                    width: 240,
                    textStyle: TextStyle(fontSize: 14),
                    onSelected: (String? value) {
                      setState(() {
                        selectedCategories[index] = value;
                        if (index == selectedCategories.length - 1 &&
                            value != null) {
                          selectedCategories.add(null);
                        }
                      });
                    },
                    dropdownMenuEntries: categorieMenuEntries,));
            }
            ),
            SizedBox(height: 10,),
            Text("Choose the Type of your Unit",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

            ...List.generate(selectedTypes.length, (index) {
              return Padding(padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: DropdownMenu<String>(
                    initialSelection: selectedTypes[index],
                    width: 240,
                    textStyle: TextStyle(fontSize: 14),
                    onSelected: (String? value) {
                      setState(() {
                        selectedTypes[index] = value;
                        if (index == selectedTypes.length - 1 &&
                            value != null) {
                          selectedTypes.add(null);
                        }
                      });
                    },
                    dropdownMenuEntries: typesMenuEntries,));
            }
            ),
            SizedBox(height: 5,),
            Text("Choose Stats",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Wrap(
              children: [
                DropdownButton<String>(
                  value: statsDropdownValue,
                  elevation: 26,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      statsDropdownValue = value!;
                    });
                  },
                  items: stats.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: statsModifierDropdownValue,
                  elevation: 26,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      statsModifierDropdownValue = value!;
                    });
                  },
                  items: statsmodifier.map<DropdownMenuItem<String>>((
                      String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                ),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: TextFormField(
                    controller: myControllerForStats,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'input Value',
                    ),
                  ),),

              ],
            ),

            ///How the Cards should be Displayed
            SizedBox(height: 5),
            Text("Sort for",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            DropdownButton<String>(
              value: sortOptionsModifierDropdownValue,
              elevation: 26,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  sortOptionsModifierDropdownValue = value!;
                });
              },
              items: sortingOptions.map<DropdownMenuItem<String>>((
                  String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
            ),

            SizedBox(height: 5),
            Text("Display order",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ToggleButtons(
              isSelected: dispalyModeIsSelected,
              onPressed: (int index) {
                setState(() {
                  ///Allows only one option to be selected at a time
                  for (int i = 0; i < dispalyModeIsSelected.length; i++) {
                    dispalyModeIsSelected[i] = i == index;
                  }
                });
              },
              selectedColor: Colors.white,
              // Farbe des Icons/Text beim Klick
              fillColor: Colors.blueAccent,
              // Hintergrundfarbe beim Klick
              color: Colors.black,
              // normale Farbe
              borderRadius: BorderRadius.circular(8),
              children: <Widget>[
                Text("asc"),
                Text("desc")
              ],
            ),
            SizedBox(height: 5),
            ElevatedButton(
                style: strechedButtonStyle,
                //Todo: Make a working Filter:
                onPressed: () {},
                child: Text("Search")),
            SizedBox(height: 25)
          ],
          ),

          )


      ),
    );
  }
}
