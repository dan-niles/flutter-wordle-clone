import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordle_clone/wordle/wordle.dart';

enum GameStatus { playing, submitting, lost, won }

class WordleScreen extends StatefulWidget {
  const WordleScreen({Key? key}) : super(key: key);

  @override
  _WordleScreenState createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  GameStatus _gamestatus = GameStatus.playing;

  final List<Word> _board = List.generate(
      6, (_) => Word(letters: List.generate(5, (_) => Letter.empty())));

  int _currentWordIndex = 0;

  Word? get _currentWord =>
      _currentWordIndex < _board.length ? _board[_currentWordIndex] : null;

  Word _solution = Word.fromString(
    fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
  );

  final Set<Letter> _keyboardLetters = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Wordle',
          style: TextStyle(
            letterSpacing: 4,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Board(board: _board),
          const SizedBox(height: 80),
          keyboard(
              onKeyTapped: _onKeyTapped,
              onDeleteTapped: _onDeleteTapped,
              onEnterTapped: _onEnterTapped,
              letters: _keyboardLetters
            )
        ],
      ),
    );
  }

  void _onKeyTapped(String val) {
    if (_gamestatus == GameStatus.playing) {
      setState(() => _currentWord?.addLetter(val));
    }
  }

  void _onDeleteTapped() {
    if (_gamestatus == GameStatus.playing) {
      setState(() => _currentWord?.removeLetter());
    }
  }

  void _onEnterTapped() {
    if (_gamestatus == GameStatus.playing &&
        _currentWord != null &&
        !_currentWord!.letters.contains(Letter.empty())) {
      _gamestatus = GameStatus.submitting;

      for (var i = 0; i < _currentWord!.letters.length; i++) {
        final currentWordLetter = _currentWord!.letters[i];
        final currentSolutionLetter = _solution.letters[i];

        setState(() {
          if (currentWordLetter == currentSolutionLetter) {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.correct);
          } else if (_solution.letters.contains(currentWordLetter)) {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.inWord);
          } else {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.notInWord);
          }
        });
      }

      _checkIfWinOrLoss();
    }
  }

  void _checkIfWinOrLoss() {
    if (_currentWord!.wordString == _solution.wordString) {
      _gamestatus = GameStatus.won;
    } else if (_currentWordIndex + 1 >= _board.length) {
      _gamestatus = GameStatus.lost;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: Colors.redAccent[200],
          content: Text(
            'You lost! Solution ${_solution.wordString}',
            style: const TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
              onPressed: _restart,
              textColor: Colors.white,
              label: 'New Game')));
    } else {
      _gamestatus = GameStatus.playing;
    }
    _currentWordIndex += 1;
  }

  void _restart() {
    setState(() {
      _gamestatus = GameStatus.playing;
      _currentWordIndex = 0;
      _board
        ..clear()
        ..addAll(List.generate(
            6, (_) => Word(letters: List.generate(5, (_) => Letter.empty()))));
      _solution = Word.fromString(
        fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase();
      );
    });
  }
}