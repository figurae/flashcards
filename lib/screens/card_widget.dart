import 'package:flashcards/db.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({
    super.key,
    required this.card,
    required this.cardIndex,
    required this.totalCards,
  });

  final FlashCard card;
  final int cardIndex;
  final int totalCards;

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title:
              Text('Fiszkeła ${widget.cardIndex + 1} z ${widget.totalCards}'),
        ),
        body: Column(
          children: [
            FlashCardWidget(
                text: (_showSideA
                    ? widget.card.sideAText
                    : widget.card.sideBText)),
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
