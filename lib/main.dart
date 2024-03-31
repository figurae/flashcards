import 'package:flashcards/db.dart';
import 'package:flashcards/screens/card_collections_widget.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await dbInit();
  runApp(const FlashCardApp());
}

class FlashCardApp extends StatelessWidget {
  const FlashCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Duper Fiszkeły 3000 Turbo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const CardCollectionsWidget(),
    );
  }
}
