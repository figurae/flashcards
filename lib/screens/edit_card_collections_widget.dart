import 'package:flashcards/db.dart';
import 'package:flashcards/screens/add_collection_widget.dart';
import 'package:flashcards/screens/card_list_widget.dart';
import 'package:flutter/material.dart';

class EditCardCollectionsWidget extends StatefulWidget {
  const EditCardCollectionsWidget({super.key});

  @override
  State<EditCardCollectionsWidget> createState() =>
      _EditCardCollectionsWidgetState();
}

class _EditCardCollectionsWidgetState extends State<EditCardCollectionsWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Zbiory fiszkełów'),
      ),
      body: Column(children: [
        ListView.builder(
          itemCount: flashCardCollections.length,
          shrinkWrap: true,
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
              trailing: IconButton(
                  onPressed: () =>
                      _deleteCollectionDialog(index: index, context: context),
                  icon: const Icon(Icons.delete)),
            );
          },
        ),
        ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddCollectionWidget())),
            child: const Text('Dodaj zbiór fiszkełów')),
      ]),
    );
  }

  Future<void> _deleteCollectionDialog(
      {required int index, required BuildContext context}) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Potwierdź wybór'),
            content: Text(
                'Czy na pewno chcesz usunąć zbiór ${flashCardCollections.getAt(index)?.name ?? 'Nieznany zbiór'}'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Nie')),
              TextButton(
                  onPressed: () {
                    _deleteCollection(index: index);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tak'))
            ],
          );
        });
  }

  Future<void> _deleteCollection({required int index}) async {
    final collection = flashCardCollections.getAt(index);
    if (collection != null) {
      await flashCardCollections.deleteAt(index);
      await flashCardCollections.flush();
    }

    // this should probably be rewritten using a notifier
    setState(() {});
  }
}
