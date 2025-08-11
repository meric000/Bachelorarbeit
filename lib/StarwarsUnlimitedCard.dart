import 'dart:convert';

class StarWarsUnlimitedCard {
  final String cardId;
  final String name;
  final String image;
  final String arena;
  final String type;
  final List<String> aspects;
  final List<String> traits;
  final int cost;
  final int power;
  final int hp;
  final String backArt;
  final String backtext;
  final String rarity;
  final bool unique;
  final String artist;
  final String variantType;
  final double marktPrice;
  final double foilPrice;

  const StarWarsUnlimitedCard({
    required this.cost,
    required this.power,
    required this.hp,
    required this.backArt,
    required this.backtext,
    required this.rarity,
    required this.unique,
    required this.artist,
    required this.variantType,
    required this.marktPrice,
    required this.foilPrice,
    required this.arena,
    required this.type,
    required this.aspects,
    required this.traits,
    required this.cardId,
    required this.name,
    required this.image,

  });

  factory StarWarsUnlimitedCard.fromJson(Map<String, dynamic> json) {
    // Kombiniere Set und Number zu einer ID
    final id = "${json['Set']}-${json['Number']}";
    // Setze Name und Subtitle zusammen
    final fullName =
        json['Subtitle'] != null
            ? "${json['Name']} – ${json['Subtitle']}"
            : json['Name'];
    final cost = int.tryParse(json['Cost'].toString()) ?? 0;
    final power = int.tryParse(json['Power'].toString()) ?? 0;
    final hp = int.tryParse(json['HP'].toString()) ?? 0;
    bool doubleSided = json['DoubleSided'] as bool;
    final rarity = "${json['Rarity']}";
    final bool unique = json['Unique'] as bool;
    final artist = "${json['Artist']}";
    final variantType = "${json['VariantType']}";
    final marketPrice = double.tryParse(json['MarketPrice'].toString()) ?? 0.0;
    final foilPrice = double.tryParse(json['FoilPrice'].toString()) ?? 0.0;
    final arena = "${json['Arenas']}";
    final type = "${json['Type']}";
    final aspects =
        (json['Aspects'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
            [];
    final traits =
        (json['Traits'] as List?)?.map((e) => e.toString()).toList() ??
            [];
     String backArt = "";
     String backText = "";
    if (doubleSided) {
      backArt = "${json['BackArt']}";
      backText = "${json['BackText']}";
    }



    return StarWarsUnlimitedCard(
      cardId: id,
      name: fullName,
      image: json['FrontArt'],
      cost: cost,
      power: power,
      hp: hp,
      rarity: rarity,
      unique: unique,
      artist: artist,
      variantType: variantType,
      marktPrice: marketPrice,
      foilPrice: foilPrice,
      arena: arena,
      type: type,
      aspects: aspects,
      traits: traits,
      backArt: backArt,
      backtext: backText,
    );
  }
}
