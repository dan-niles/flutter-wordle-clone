import 'package:equatable/equatable.dart';
import 'package:wordle_clone/wordle/wordle.dart';

class Word extends Equatable {
  const Word({required this.letters});

  factory Word.fromString(String word) {
    Word(letters: word.split('').map((e) => Letter(val: e)).toList());
  }

  final List<Letter> letters;

  String get wordString => letters.map((e) => e.val).join();

  void addLetter(String val) {
    final curentindex = letters.indexWhere((e) => e.val.isEmpty);
    if (curentindex != -1) {
      letters[curentindex] = Letter(val: val);
    }
  }

  void removeLetter() {
    final recentLetterIndex = letters.lastIndexWhere((e) => e.val.isNotEmpty);
    if (recentLetterIndex != -1) {
      letters[recentLetterIndex] = Letter.empty();
    }
  }

  @override
  List<Object?> get props => [letters];
}
