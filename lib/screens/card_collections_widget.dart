import 'package:flashcards/db.dart';
import 'package:flashcards/screens/add_collection_widget.dart';
import 'package:flashcards/screens/card_list_widget.dart';
import 'package:flashcards/screens/edit_card_collections_widget.dart';
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
      body: Column(
        children: [
          ListView.builder(
            itemCount: flashCardCollections.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              final collectionKey = flashCardCollections.keyAt(index);
              final collection = flashCardCollections.get(collectionKey);

              if (collection == null) {
                return const ListTile(title: Text('Nieznany zbiór'));
              }

              return ListTile(
                title: Text(flashCardCollections.getAt(index)?.name ??
                    'Nieznany zbiór'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardListWidget(
                        collection: collection,
                        collectionKey: collectionKey,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddCollectionWidget())),
              child: const Text('Dodaj zbiór fiszkełów')),
          ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditCardCollectionsWidget())),
              child: const Text('Edytuj zbiory fiszkełów')),
        ],
      ),
    );
  }
}
