import 'package:flashcards/db.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  const CardWidget(
      {super.key, required this.cardIndex, required this.collectionKey});

  final int cardIndex;
  final int collectionKey;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool _showSideA = true;

  void _switchSide() {
    setState(() => _showSideA = !_showSideA);
  }

  @override
  Widget build(BuildContext context) {
    final FlashCardCollection? currentCollection =
        flashCardCollections.get(widget.collectionKey);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
              'Fiszka ${widget.cardIndex + 1} z ${currentCollection?.cards.length}'),
        ),
        body: Column(
          children: [
            FlashCardWidget(
                text: (_showSideA
                        ? currentCollection?.cards[widget.cardIndex].sideAText
                        : currentCollection
                            ?.cards[widget.cardIndex].sideBText) ??
                    'Brak tekstu'),
            ElevatedButton(onPressed: _switchSide, child: const Text('flip')),
          ],
        ));
  }
}

class FlashCardWidget extends StatelessWidget {
  const FlashCardWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }
}
