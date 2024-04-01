import 'package:flashcards/db.dart';
import 'package:flashcards/screens/add_card_widget.dart';
import 'package:flashcards/screens/card_widget.dart';
import 'package:flutter/material.dart';

class EditCardListWidget extends StatefulWidget {
  const EditCardListWidget(
      {super.key, required this.collection, required this.collectionKey});

  final FlashCardCollection collection;
  final int collectionKey;

  @override
  State<EditCardListWidget> createState() => _EditCardListWidgetState();
}

class _EditCardListWidgetState extends State<EditCardListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Fiszkeły ze zbioru: ${widget.collection.name}'),
      ),
      body: Column(
        children: [
          ListView.builder(
            itemCount: widget.collection.cards.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              final card = widget.collection.cards[index];
              final totalCards = widget.collection.cards.length;

              return ListTile(
                title: Text(card.sideAText),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardWidget(
                      card: card,
                      cardIndex: index,
                      totalCards: totalCards,
                    ),
                  ),
                ),
                trailing: IconButton(
                    onPressed: () => _deleteCardDialog(
                          cardIndex: index,
                          collectionKey: widget.collectionKey,
                          context: context,
                          name: card.sideAText,
                        ),
                    icon: const Icon(Icons.delete)),
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
                  ),
              child: const Text('Dodaj fiszkełe')),
        ],
      ),
    );
  }

  Future<void> _deleteCardDialog(
      {required int cardIndex,
      required int collectionKey,
      required BuildContext context,
      required String name}) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Potwierdź wybór'),
          content: Text('Czy na pewno chcesz usunąć fiszkełę: $name?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Nie')),
            TextButton(
                onPressed: () {
                  _deleteCard(
                    cardIndex: cardIndex,
                    collectionKey: collectionKey,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Tak'))
          ],
        );
      },
    );
  }

  Future<void> _deleteCard({
    required int cardIndex,
    required int collectionKey,
  }) async {
    // this looks like a job for db.dart
    final collection = flashCardCollections.get(collectionKey);
    final cards = collection?.cards;

    if (cards != null && cards.length > cardIndex) {
      cards.removeAt(cardIndex);
      final editedCollection =
          FlashCardCollection(cards: cards, name: collection!.name);

      await flashCardCollections.put(collectionKey, editedCollection);
      await flashCardCollections.flush();
    }

    // this should probably be rewritten using a notifier
    setState(() {});
  }
}
