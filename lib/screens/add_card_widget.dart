import 'package:flashcards/db.dart';
import 'package:flutter/material.dart';

class AddCardWidget extends StatefulWidget {
  const AddCardWidget({super.key, required this.collectionKey});

  final int collectionKey;

  @override
  State<AddCardWidget> createState() => _AddCardWidgetState();
}

class _AddCardWidgetState extends State<AddCardWidget> {
  final _formKey = GlobalKey<FormState>();

  final sideAController = TextEditingController();
  final sideBController = TextEditingController();

  @override
  void dispose() {
    sideAController.dispose();
    sideBController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Dodej fiszkełe'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: sideAController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tekst fiszkeły nie może być pusty! :3';
                }
                return null;
              },
            ),
            TextFormField(
              controller: sideBController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tekst fiszkeły nie może być pusty! :3';
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addFlashCard(
                        sideAText: sideAController.text,
                        sideBText: sideBController.text,
                        collectionKey: widget.collectionKey);

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('add'))
          ],
        ),
      ),
    );
  }

  Future<void> _addFlashCard(
      {required String sideAText,
      required String sideBText,
      required int collectionKey}) async {
    // this would propably work better inside db.dart
    final FlashCard newFlashCard =
        FlashCard(sideAText: sideAText, sideBText: sideBText);
    final FlashCardCollection? currentCollection =
        flashCardCollections.get(widget.collectionKey);

    if (currentCollection != null) {
      currentCollection.cards.add(newFlashCard);
      await flashCardCollections.put(collectionKey, currentCollection);
      await flashCardCollections.flush();
    }
  }
}
