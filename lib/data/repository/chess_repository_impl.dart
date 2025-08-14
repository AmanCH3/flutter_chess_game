import 'package:dartz/dartz.dart';
import 'package:flutter_chess_game/core/error/failure.dart';
import 'package:flutter_chess_game/domain/entity/chess_entity.dart';
import 'package:flutter_chess_game/domain/repostiory/chess_repository.dart';

class ChessRepositoryImpl implements ChessRepository {
  @override
  Future<Either<Failure, List<List<ChessEntity?>>>> initializeBoard() async {
    try {
      final board = List.generate(8, (_) => List<ChessEntity?>.filled(8, null));

      ChessEntity createPiece(ChessPieceType type, bool isWhite) {
        return ChessEntity(type: type, isWhite: isWhite);
      }

      for (int i = 0; i < 8; i++) {
        board[1][i] = createPiece(ChessPieceType.pawn, false); // black
        board[6][i] = createPiece(ChessPieceType.pawn, true); // white
      }

      //place rooks for black
      board[0][0] = createPiece(ChessPieceType.rook, false);
      board[0][7] = createPiece(ChessPieceType.rook, false);

      //place rooks for white
      board[7][0] = createPiece(ChessPieceType.rook, true);
      board[7][7] = createPiece(ChessPieceType.rook, true);

      // place knight for black

      board[0][1] = createPiece(ChessPieceType.knight, false);
      board[0][6] = createPiece(ChessPieceType.knight, false);

      board[7][1] = createPiece(ChessPieceType.knight, true);
      board[7][6] = createPiece(ChessPieceType.knight, true);

      board[0][2] = createPiece(ChessPieceType.bishop, false);
      board[0][5] = createPiece(ChessPieceType.bishop, false);

      board[7][2] = createPiece(ChessPieceType.bishop, true);
      board[7][5] = createPiece(ChessPieceType.bishop, true);

      board[0][3] = createPiece(ChessPieceType.queen, false);
      board[7][3] = createPiece(ChessPieceType.queen, true);

      board[0][4] = createPiece(ChessPieceType.king, false);
      board[7][4] = createPiece(ChessPieceType.king, true);

      return Right(board);

      //place kne
    } catch (e) {
      return Left(
        NetworkFailure(message: 'Failed to initalized  board ${e.toString()}'),
      );
    }
    // create an 8*8 board
  }
}
