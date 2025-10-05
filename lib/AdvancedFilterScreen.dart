import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:showing_card/Buttonstyle.dart';
import 'package:showing_card/DBHelper.dart';

enum aspects { Vigilance, Heroism, Aggression, Cunning, Villainy, Command }

final List<bool> aspectIsSelected = <bool>[
  false,
  false,
  false,
  false,
  false,
  false,
];

List<String> aspectName = <String>['b', 'w', 'r', 'y', 'k', 'g'];

List<String?> aspectConditionName = <String?>[null, "<", ">"];

String? aspectConditionValue = "";

///Builds the Aspect string correctly
String buildAspectString() {
  List<String> selectedAspects = [];

  for (int i = 0; i < aspectIsSelected.length; i++) {
    if (aspectIsSelected[i]) {
      selectedAspects.add(aspectName[i]);
    }
  }
  // Kombinieren, z.B. mit || als Trenner
  return selectedAspects.join();
}


final List<bool> rarityIsSelected = <bool>[
  false,
  false,
  false,
  false,
  false,
];

List<String> rarityName = <String>['Ac', 'Au', 'Ar', 'Al', 'As'];

String buildRarityString() {
  List<String> selectedAspects = [];

  for (int i = 0; i < rarityIsSelected.length; i++) {
    if (rarityIsSelected[i]) {
      selectedAspects.add(rarityName[i]);
    }
  }

  // Kombinieren, z.B. mit || als Trenner
  return selectedAspects.join("+OR+r%3");
}


final List<bool> dispalyModeIsSelected = <bool>[
  false,
  false,
];

List<String> displayModeName = <String>['asc', 'desc'];

String displayFilterValue = "";

String buildDMString() {
  String selectedAspects = displayModeName[0];

  for (int i = 0; i < dispalyModeIsSelected.length; i++) {
    if (dispalyModeIsSelected[i]) {
      selectedAspects = displayModeName[i];
    }
  }
  // Kombinieren, z.B. mit || als Trenner
  return selectedAspects;
}


///This is the Advanced Filter Class here is a complex filter, with which the user can
///Specify what kind of card he wants to lookup
class AdvancedFilterScreen extends StatefulWidget {
  const AdvancedFilterScreen({super.key});

  @override
  State<AdvancedFilterScreen> createState() => _AdvancedFilterState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _AdvancedFilterState extends State<AdvancedFilterScreen> {

  static final List<MenuEntry> menuEntries = UnmodifiableListView<
      MenuEntry>(
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
  static List<String> statsValue = <String>["c", "h", "p"];
  String statsFilterValue = "";

  static List<String> statsmodifier = <String>[
    "=",
    "<",
    ">",
    "<=",
    ">=",
    "!= (not equal)"
  ];
  static List<String> statsModifierValue = <String>[
    "%3D",
    "<",
    ">",
    "%21%3D",
    ">%3D",
    "<%3D"
  ];
  String statsModifierFilterValue = "";
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
    "\" \"",
    "\"BOUNTY HUNTER\"",
    "\"CAPITAL SHIP\"",
    "\"CLONE\"",
    "\"CONDITION\"",
    "\"CREATURE\"",
    "\"DISASTER\"",
    "\"DROID\"",
    "\"EWOK\"",
    "\"FIGHTER\"",
    "\"FIRST ORDER\"",
    "\"FORCE\"",
    "\"FRINGE\"",
    "\"GAMBIT\"",
    "\"GUNGAN\"",
    "\"HUTT\"",
    "\"IMPERIAL\"",
    "\"INNATE\"",
    "\"INQUISITOR\"",
    "\"ITEM\"",
    "\"JAWA\"",
    "\"JEDI\"",
    "\"KAMINOAN\"",
    "\"LAW\"",
    "\"LEARNED\"",
    "\"LIGHTSABER\"",
    "\"MANDALORIAN\"",
    "\"MODIFICATION\"",
    "\"NABOO\"",
    "\"NEW REPUBLIC\"",
    "\"NIGHT\"",
    "\"NIHIL\"",
    "\"OFFICIAL\"",
    "\"PILOT\"",
    "\"PLAN\"",
    "\"REBEL\"",
    "\"REPUBLIC\"",
    "\"RESISTANCE\"",
    "\"SEPARATIST\"",
    "\"SITH\"",
    "\"SPECTRE\"",
    "\"SPEEDER\"",
    "\"SUPPLY\"",
    "\"TACTIC\"",
    "\"TANK\"",
    "\"TRANSPORT\"",
    "\"TRICK\"",
    "\"TROOPER\"",
    "\"TUSKEN\"",
    "\"TWI'LEK\"",
    "\"UNDEAD\"",
    "\"UNDERWORLD\"",
    "\"WALKER\"",
    "\"WEAPON\"",
    "\"WOOKIE\"",
  ];
  final List<String?> selectedCategories = [null];

  String? buildCategoryString() {
    if (selectedCategories[0] == null) return null;

    String finalString = "";

    for (int i = 0; i < selectedCategories.length - 1; i++) {
      if (selectedCategories[i] != null) {
        String curStrig = selectedCategories[i]!.replaceAll(" ", "+");

        if (i < selectedCategories.length - 1 &&
            selectedCategories[i + 1] != null &&
            selectedCategories[i + 1]!.isNotEmpty) {
          finalString = "$finalString${curStrig}tr%3A";
        } else {
          finalString = finalString + curStrig;
        }
      }
    }

    return finalString;
  }

  static List<String> types = [
    " ",
    "Base",
    "Event",
    "Leader",
    "Unit",
    "Upgrade"
  ];

  final List<String?> selectedTypes = [null];

  String? buildTypeString() {
    if (selectedTypes[0] == null) return null;

    String finalString = "";

    for (int i = 0; i < selectedTypes.length - 1; i++) {
      if (selectedTypes[i] != null) {
        String curStrig = selectedTypes[i]!.replaceAll(" ", "+");

        if (i < selectedTypes.length - 1 &&
            selectedTypes[i + 1] != null &&
            selectedTypes[i + 1]!.isNotEmpty) {
          finalString = "$finalString${curStrig}tr%3A";
        } else {
          finalString = finalString + curStrig;
        }
      }
    }

    return finalString;
  }

  String inclusiondropdownValue = inclusion.first;
  String statsDropdownValue = stats.first;
  String statsModifierDropdownValue = statsmodifier.first;
  String sortOptionsModifierDropdownValue = sortingOptions.first;
  String arenadropdownValue = arena.first;

  final myControllerForCardname = TextEditingController();
  String? buildCardnameString(){
    if(myControllerForCardname.text.isEmpty){
      return null;
    }
    return myControllerForCardname.text;
  }

  final myControllerForText = TextEditingController();
  String? buildTextString(){
    if(myControllerForText.text.isEmpty){
      return null;
    }
  return myControllerForText.text;
  }

 final myControllerForStats = TextEditingController();
  String? buildStatsString(){
    if(myControllerForStats.text.isEmpty){
      return null;
    }
    return myControllerForStats.text;
  }

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
                    selectedColor: Colors.white,
                    // Farbe des Icons/Text beim Klick
                    fillColor: Colors.blueAccent,
                    // Hintergrundfarbe beim Klick
                    color: Colors.black,
                    // normale Farbe
                    borderRadius: BorderRadius.circular(8),
                    children: <Widget>[
                      Image.asset(
                        "assets/images/SWH_Aspects_Vigilance.png",
                        width: 64,),
                      Image.asset(
                        "assets/images/SWH_Aspects_Heroism.png",
                        width: 64,),
                      Image.asset(
                        "assets/images/SWH_Aspects_Aggression.png",
                        width: 64,),
                      Image.asset(
                        "assets/images/SWH_Aspects_Cunning.png",
                        width: 64,),
                      Image.asset(
                        "assets/images/SWH_Aspects_Villainy.png",
                        width: 64,),
                      Image.asset(
                        "assets/images/SWH_Aspects_Command.png",
                        width: 64,),
                    ],
                  ),


                  DropdownButton<String>(
                    value: inclusiondropdownValue,
                    elevation: 26,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 16),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        inclusiondropdownValue = value!;
                        final index = inclusion.indexOf(value);

                        // aspectConditionValue auf denselben Index setzen
                        aspectConditionValue = aspectConditionName[index];
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),

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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),

              ///Generates a New DropdownMenu everytime a Categorie is selected
              ...List.generate(selectedCategories.length, (index) {
                return Padding(padding: const EdgeInsets.symmetric(
                    vertical: 4.0),
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),

              ...List.generate(selectedTypes.length, (index) {
                return Padding(padding: const EdgeInsets.symmetric(
                    vertical: 4.0),
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              Wrap(
                children: [
                  DropdownButton<String>(
                    value: statsDropdownValue,
                    elevation: 26,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 16),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        statsDropdownValue = value!;
                        final index = stats.indexOf(value);

                        // aspectConditionValue auf denselben Index setzen
                        statsFilterValue = statsValue[index];
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
                    style: const TextStyle(
                        color: Colors.black, fontSize: 16),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        statsModifierDropdownValue = value!;
                        final index = statsmodifier.indexOf(value);

                        // aspectConditionValue auf denselben Index setzen
                        statsModifierFilterValue =
                        statsModifierValue[index];
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              ToggleButtons(
                isSelected: dispalyModeIsSelected,
                onPressed: (int index) {
                  setState(() {
                    ///Allows only one option to be selected at a time
                    for (int i = 0; i < dispalyModeIsSelected.length; i++) {
                      dispalyModeIsSelected[i] = i == index;
                      displayFilterValue = displayModeName[i];
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
                onPressed: () async {
                  try {
                    final cards = await fetchbyComplexerFilter(
                      buildAspectString(),
                      aspectConditionValue,
                      buildRarityString(),
                      buildCardnameString(),
                      arenadropdownValue,
                      buildCategoryString(),
                      buildTypeString(),
                      buildTextString(),
                      statsFilterValue,
                      statsModifierFilterValue,
                      buildStatsString(),
                      sortOptionsModifierDropdownValue,
                      displayFilterValue,
                    );

                    Navigator.pop(context, cards); // nur wenn erfolgreich
                  } catch (e) {
                    // Fehler abfangen und User informieren
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Fehler beim Laden der Karten: $e')),
                    );
                  }
                },
                child: const Text("Search"),
              ),
              SizedBox(height: 25)
            ],
          ),
          )
      ),
    );
  }
}



