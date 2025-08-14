import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class ChessEvent extends Equatable {
  const ChessEvent();

  @override
  List<Object?> get props => [];
}

class InitializeBoardEvent extends ChessEvent {}

class SqaureTappedEvent extends ChessEvent {
  final int row;
  final int col;

  const SqaureTappedEvent({required this.row, required this.col});
  @override
  List<Object?> get props => [row, col];
}

class ResetGameEvent extends ChessEvent {}
