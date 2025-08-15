import 'package:dartz/dartz.dart';
import 'package:flutter_chess_game/core/error/failure.dart';
import 'package:flutter_chess_game/domain/entity/chess_entity.dart';

abstract interface class ChessRepository {
  Future<Either<Failure, List<List<ChessEntity?>>>> initializeBoard();
  Future<Either<Failure, bool>> validateMove({
    required List<List<ChessEntity?>> board,
    required int fromRow,
    required int fromCol,
    required int toRow,
    required int toCol,
  });
}
