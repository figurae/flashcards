import 'package:flashcards/db.dart';
import 'package:flashcards/screens/add_card_widget.dart';
import 'package:flashcards/screens/card_widget.dart';
import 'package:flutter/material.dart';

class CardListWidget extends StatelessWidget {
  const CardListWidget({super.key, required this.collectionKey});

  final int collectionKey;

  @override
  Widget build(BuildContext context) {
    final FlashCardCollection? currentCollection =
        flashCardCollections.get(collectionKey);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
            'Fiszkeły ze zbioru: ${currentCollection?.name ?? 'Nieznany zbiór'}'),
      ),
      body: Column(
        children: [
          ListView.builder(
            itemCount: currentCollection?.cards.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(currentCollection?.cards[index].sideAText ??
                    'Nieznany fiszkeł'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardWidget(
                      cardIndex: index,
                      collectionKey: collectionKey,
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
                          AddCardWidget(collectionKey: collectionKey))),
              child: const Text('Dodaj fiszkełe')),
        ],
      ),
    );
  }
}
