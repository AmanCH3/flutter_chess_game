import 'package:dartz/dartz.dart';
import 'package:flutter_chess_game/core/error/failure.dart';
import 'package:flutter_chess_game/core/error/usecase/usecase.dart';
import 'package:flutter_chess_game/domain/entity/chess_entity.dart';
import 'package:flutter_chess_game/domain/repostiory/chess_repository.dart';

class ValidateMoveUseCase
    implements UsecaseWithParams<bool, ValidateMoveParams> {
  final ChessRepository repository;

  ValidateMoveUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ValidateMoveParams params) {
    return repository.validateMove(
      board: params.board,
      fromRow: params.fromRow,
      fromCol: params.fromCol,
      toRow: params.toRow,
      toCol: params.toCol,
    );
  }
}

class ValidateMoveParams {
  final List<List<ChessEntity?>> board;
  final int fromRow;
  final int fromCol;
  final int toRow;
  final int toCol;

  ValidateMoveParams({
    required this.board,
    required this.fromRow,
    required this.fromCol,
    required this.toRow,
    required this.toCol,
  });
}
