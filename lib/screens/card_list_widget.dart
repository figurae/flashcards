import 'package:flashcards/db.dart';
import 'package:flashcards/screens/edit_card_widget.dart';
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
  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    final name = widget.collection.name;
    final cards = widget.collection.cards;
    final totalCards = cards.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Fiszkeły ze zbioru: $name'),
        actions: [
          IconButton(
            tooltip: !_editMode ? 'Edytuj fiszkeły' : 'Zakończ edycję',
            onPressed: () => setState(() {
              _editMode = !_editMode;
            }),
            icon: !_editMode
                ? const Icon(Icons.edit)
                : const Icon(Icons.edit_off),
          ),
          IconButton(
            tooltip: 'Dodej fiszkełę',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    EditCardWidget(collectionKey: widget.collectionKey),
              ),
            ).then((_) => setState(() {})),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: totalCards,
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
            trailing: _editMode
                ? _cardTileTrailingButtons(
                    cardIndex: index,
                    cardTitle: cards[index].sideAText,
                    card: cards[index],
                  )
                : null,
          );
        },
      ),
    );
  }

  // should this be lowerCamelCase?
  Widget _cardTileTrailingButtons({
    required int cardIndex,
    required String cardTitle,
    required FlashCard card,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditCardWidget(
                collectionKey: widget.collectionKey,
                cardIndex: cardIndex,
                card: card,
              ),
            ),
          ).then((_) => setState(() {})),
          icon: const Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () => _deleteCardDialog(
            cardIndex: cardIndex,
            collectionKey: widget.collectionKey,
            context: context,
            name: cardTitle,
          ),
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Future<void> _deleteCardDialog({
    required int cardIndex,
    required int collectionKey,
    required BuildContext context,
    required String name,
  }) async {
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
