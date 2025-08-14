import 'package:dartz/dartz.dart';
import 'package:flutter_chess_game/core/error/failure.dart';
import 'package:flutter_chess_game/domain/entity/chess_entity.dart';

abstract interface class ChessRepository {
  Future<Either<Failure, List<List<ChessEntity?>>>> initializeBoard();
  // In a real app, you might have:
  // Future<void> saveGame(List<List<ChessPiece?>> board);
  // Future<List<List<ChessPiece?>>> loadGame();
}
