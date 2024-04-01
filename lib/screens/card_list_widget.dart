import 'package:flashcards/db.dart';
import 'package:flashcards/screens/add_card_widget.dart';
import 'package:flashcards/screens/card_widget.dart';
import 'package:flutter/material.dart';

class CardListWidget extends StatefulWidget {
  const CardListWidget({
    super.key,
    required this.collection,
    required this.collectionKey,
  });

  final FlashCardCollection collection;
  final int collectionKey;

  @override
  State<CardListWidget> createState() => _CardListWidgetState();
}

class _CardListWidgetState extends State<CardListWidget> {
  @override
  Widget build(BuildContext context) {
    final name = widget.collection.name;
    final cards = widget.collection.cards;
    final totalCards = cards.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Fiszkeły ze zbioru: $name'),
      ),
      body: Column(
        children: [
          ListView.builder(
            itemCount: totalCards,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(cards[index].sideAText),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardWidget(
                      card: cards[index],
                      cardIndex: index,
                      totalCards: totalCards,
                    ),
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddCardWidget(collectionKey: widget.collectionKey),
              ),
            ).then((_) => setState(() {})),
            child: const Text('Dodaj fiszkełe'),
          ),
        ],
      ),
    );
  }
}
