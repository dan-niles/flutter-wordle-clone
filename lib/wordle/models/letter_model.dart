import 'package:equatable/equatable.dart';
import 'package:wordle_clone/app/app_colors.dart';
import 'package:flutter/material.dart';

enum LetterStatus { initial, notInWord, inWord, correct }

class Letter extends Equatable {
  const Letter({
    required this.val,
    required LetterStatus status,
  });

  factory Letter.empty() => const Letter(val: '');
  final String val;
  final LetterStatus status;

  Color get backgroundColor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.white;
      case LetterStatus.notInWord:
        return notInWordColor;
      case LetterStatus.inWord:
        return inWordColor;
      case LetterStatus.correct:
        return correctColor;
    }
  }

  Color get borderColor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  Letter copyWith({
    String? val,
    LetterStatus? status,
  }) {
    return Letter(
      val: val ?? this.val,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [val, status]
}