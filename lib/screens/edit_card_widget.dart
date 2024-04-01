import 'package:flashcards/db.dart';
import 'package:flutter/material.dart';

class EditCardWidget extends StatefulWidget {
  const EditCardWidget({
    super.key,
    required this.collectionKey,
    this.cardIndex,
    this.card,
  });

  final int collectionKey;
  final int? cardIndex;
  final FlashCard? card;

  @override
  State<EditCardWidget> createState() => _EditCardWidgetState();
}

class _EditCardWidgetState extends State<EditCardWidget> {
  final _formKey = GlobalKey<FormState>();
  late bool _editMode;

  late TextEditingController _sideAController;
  late TextEditingController _sideBController;

  @override
  void initState() {
    super.initState();
    _editMode = widget.card != null && widget.cardIndex != null;
    _sideAController = TextEditingController(text: widget.card?.sideAText);
    _sideBController = TextEditingController(text: widget.card?.sideBText);
  }

  @override
  void dispose() {
    _sideAController.dispose();
    _sideBController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _editMode = widget.card != null && widget.cardIndex != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: _editMode
            ? const Text('Edytuj fiszkełę')
            : const Text('Dodej fiszkełę'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _sideAController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tekst fiszkeły nie może być pusty! :3';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _sideBController,
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
                    _saveFlashCard(
                      sideAText: _sideAController.text,
                      sideBText: _sideBController.text,
                      collectionKey: widget.collectionKey,
                      cardIndex: _editMode ? widget.cardIndex : null,
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Zapisz'))
          ],
        ),
      ),
    );
  }

  Future<void> _saveFlashCard({
    required String sideAText,
    required String sideBText,
    required int collectionKey,
    int? cardIndex,
  }) async {
    // this would propably work better inside db.dart
    final FlashCard newFlashCard =
        FlashCard(sideAText: sideAText, sideBText: sideBText);
    final FlashCardCollection? currentCollection =
        flashCardCollections.get(widget.collectionKey);

    if (currentCollection != null) {
      if (cardIndex != null) {
        currentCollection.cards[cardIndex] = newFlashCard;
      } else {
        currentCollection.cards.add(newFlashCard);
      }

      await flashCardCollections.put(collectionKey, currentCollection);
      await flashCardCollections.flush();
    }
  }
}
