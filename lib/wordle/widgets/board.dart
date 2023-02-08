import 'package:flutter/material.dart';
import 'package:wordle_clone/wordle/wordle.dart';

class Board extends StatefulWidget {
  const Board({Key? key, required this.board}) : super(key: key);
  final List<Word> board;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: board.map((word) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: word.letters.map(letter) => BoardTile(letter: letter)
      )
      ).toList(),
    );
  }
}