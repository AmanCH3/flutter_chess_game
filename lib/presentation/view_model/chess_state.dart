import 'package:equatable/equatable.dart';
import 'package:flutter_chess_game/domain/entity/chess_entity.dart';

abstract class ChessState extends Equatable {
  const ChessState();
  @override
  List<Object?> get props => [];
}

class ChessInitial extends ChessState {}

class ChessLoading extends ChessState {}

class ChessLoaded extends ChessState {
  final List<List<ChessEntity?>> board;
  final bool isWhiteTurn;
  final int? selectedRow;
  final int? selectedCol;
  ChessLoaded({
    required this.board,
    this.isWhiteTurn = true,
    this.selectedCol,
    this.selectedRow,
  });

  ChessLoaded copyWith({
    List<List<ChessEntity?>>? board,
    bool? isWhiteTurn,
    int? selectedRow,
    int? selectedCol,
    bool clearSelection = false,
  }) {
    return ChessLoaded(
      board: board ?? this.board,
      isWhiteTurn: isWhiteTurn ?? this.isWhiteTurn,
      selectedCol: clearSelection ? null : selectedCol ?? this.selectedCol,
      selectedRow: clearSelection ? null : selectedRow ?? this.selectedRow,
    );
  }

  @override
  List<Object?> get props => [board, isWhiteTurn, selectedCol, selectedRow];
}

class ChessError extends ChessState {
  final String message;

  const ChessError(this.message);

  @override
  List<Object?> get props => [message];
}
