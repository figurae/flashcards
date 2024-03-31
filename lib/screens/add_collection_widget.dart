import 'package:flashcards/db.dart';
import 'package:flashcards/screens/card_collections_widget.dart';
import 'package:flutter/material.dart';

class AddCollectionWidget extends StatefulWidget {
  const AddCollectionWidget({super.key});

  @override
  State<AddCollectionWidget> createState() => _AddCollectionWidgetState();
}

class _AddCollectionWidgetState extends State<AddCollectionWidget> {
  final _formKey = GlobalKey<FormState>();

  final collectionNameController = TextEditingController();

  @override
  void dispose() {
    collectionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Dodej zbiór fiszkełów'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: collectionNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nazwa zbioru fiszkełów nie może być pusta! :3';
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addFlashCardCollection(
                        name: collectionNameController.text);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CardCollectionsWidget(),
                        ));
                  }
                },
                child: const Text('add'))
          ],
        ),
      ),
    );
  }

  Future<void> _addFlashCardCollection({required String name}) async {
    // this would propably work better inside db.dart
    final List<FlashCard> cards = [];
    final FlashCardCollection newFlashCardCollection =
        FlashCardCollection(cards: cards, name: name);

    await flashCardCollections.add(newFlashCardCollection);
    await flashCardCollections.flush();
  }
}
