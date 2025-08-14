import 'package:dartz/dartz.dart';
import 'package:flutter_chess_game/core/error/failure.dart';
import 'package:flutter_chess_game/core/error/usecase/usecase.dart';
import 'package:flutter_chess_game/domain/entity/chess_entity.dart';
import 'package:flutter_chess_game/domain/repostiory/chess_repository.dart';

class GetInitialBoardUseCase
    implements UsecaseWithoutParams<List<List<ChessEntity?>>> {
  final ChessRepository repository;
  GetInitialBoardUseCase(this.repository);

  @override
  Future<Either<Failure, List<List<ChessEntity?>>>> call() async {
    return repository.initializeBoard();
  }
}
