import 'package:hive_flutter/hive_flutter.dart';

const String hiveBoxName = 'flash_card_db';
late Box<FlashCardCollection> flashCardCollections;

Future<void> dbInit() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FlashCardAdapter());
  Hive.registerAdapter(FlashCardCollectionAdapter());

  flashCardCollections = await Hive.openBox(hiveBoxName);
}

class FlashCard {
  final String sideAText;
  final String sideBText;

  const FlashCard({required this.sideAText, required this.sideBText});

  @override
  String toString() {
    return 'FlashCard{sideAText: $sideAText, sideBText: $sideBText}';
  }
}

class FlashCardCollection {
  final String name;
  final List<FlashCard> cards;

  FlashCardCollection({required this.cards, required this.name});
}

class FlashCardAdapter extends TypeAdapter<FlashCard> {
  @override
  final int typeId = 0;

  @override
  FlashCard read(BinaryReader reader) {
    final sideAText = reader.readString();
    final sideBText = reader.readString();

    return FlashCard(sideAText: sideAText, sideBText: sideBText);
  }

  @override
  void write(BinaryWriter writer, FlashCard obj) {
    writer.writeString(obj.sideAText);
    writer.writeString(obj.sideBText);
  }
}

class FlashCardCollectionAdapter extends TypeAdapter<FlashCardCollection> {
  @override
  final int typeId = 1;

  @override
  FlashCardCollection read(BinaryReader reader) {
    final name = reader.readString();
    final cards = reader.readList().map((e) => e as FlashCard).toList();

    return FlashCardCollection(cards: cards, name: name);
  }

  @override
  void write(BinaryWriter writer, FlashCardCollection obj) {
    writer.writeString(obj.name);
    writer.writeList(obj.cards);
  }
}
