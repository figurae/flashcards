import 'package:flashcards/db.dart';
import 'package:flashcards/screens/card_list_widget.dart';
import 'package:flutter/material.dart';

class CardCollectionsWidget extends StatelessWidget {
  const CardCollectionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Zbiory fiszkełów'),
      ),
      body: ListView.builder(
        itemCount: flashCardCollections.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(
                flashCardCollections.getAt(index)?.name ?? 'Nieznany zbiór'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardListWidget(
                    collectionKey: flashCardCollections.keyAt(index)),
              ),
            ),
          );
        },
      ),
    );
  }
}