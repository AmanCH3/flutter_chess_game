import 'dart:math';
import 'package:flutter_chess_game/domain/entity/chess_entity.dart';

class ChessRulesService {
  List<List<ChessEntity?>> createInitialBoard() {
    final board = List.generate(8, (_) => List<ChessEntity?>.filled(8, null));

    ChessEntity createPiece(ChessPieceType type, bool isWhite) {
      return ChessEntity(type: type, isWhite: isWhite);
    }

    for (int i = 0; i < 8; i++) {
      board[1][i] = createPiece(ChessPieceType.pawn, false);
      board[6][i] = createPiece(ChessPieceType.pawn, true);
    }

    board[0][0] = createPiece(ChessPieceType.rook, false);
    board[0][7] = createPiece(ChessPieceType.rook, false);
    board[7][0] = createPiece(ChessPieceType.rook, true);
    board[7][7] = createPiece(ChessPieceType.rook, true);

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

    return board;
  }

  Point<int>? _findKing(List<List<ChessEntity?>> board, bool isWhite) {
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final piece = board[r][c];
        if (piece != null &&
            piece.type == ChessPieceType.king &&
            piece.isWhite == isWhite) {
          return Point(r, c);
        }
      }
    }
    return null;
  }

  bool isKingInCheck(List<List<ChessEntity?>> board, bool isWhite) {
    final kingPos = _findKing(board, isWhite);
    if (kingPos == null) return false;

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final piece = board[r][c];
        if (piece != null && piece.isWhite != isWhite) {
          if (_validateMoveUnchecked(board, r, c, kingPos.x, kingPos.y)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool isCheckmate(List<List<ChessEntity?>> board, bool isWhite) {
    if (!isKingInCheck(board, isWhite)) {
      return false;
    }

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final piece = board[r][c];
        if (piece != null && piece.isWhite == isWhite) {
          for (int toRow = 0; toRow < 8; toRow++) {
            for (int toCol = 0; toCol < 8; toCol++) {
              if (validateMove(
                board: board,
                fromRow: r,
                fromCol: c,
                toRow: toRow,
                toCol: toCol,
              )) {
                // If any valid move exists, it's not checkmate
                return false;
              }
            }
          }
        }
      }
    }

    return true; // No valid moves found
  }

  bool validateMove({
    required List<List<ChessEntity?>> board,
    required int fromRow,
    required int fromCol,
    required int toRow,
    required int toCol,
  }) {
    final piece = board[fromRow][fromCol];
    if (piece == null) return false;

    if (!_validateMoveUnchecked(board, fromRow, fromCol, toRow, toCol)) {
      return false;
    }

    final tempBoard = List.generate(
      8,
      (i) => List<ChessEntity?>.from(board[i]),
    );
    tempBoard[toRow][toCol] = piece;
    tempBoard[fromRow][fromCol] = null;

    return !isKingInCheck(tempBoard, piece.isWhite);
  }

  bool _validateMoveUnchecked(
    List<List<ChessEntity?>> board,
    int fromRow,
    int fromCol,
    int toRow,
    int toCol,
  ) {
    final piece = board[fromRow][fromCol];
    if (piece == null) return false;

    final destinationPiece = board[toRow][toCol];
    if (destinationPiece != null && destinationPiece.isWhite == piece.isWhite) {
      return false;
    }

    switch (piece.type) {
      case ChessPieceType.pawn:
        return _isPawnMoveValid(
          board,
          fromRow,
          fromCol,
          toRow,
          toCol,
          piece.isWhite,
        );
      case ChessPieceType.rook:
        return _isRookMoveValid(board, fromRow, fromCol, toRow, toCol);
      case ChessPieceType.knight:
        return _isKnightMoveValid(board, fromRow, fromCol, toRow, toCol);
      case ChessPieceType.bishop:
        return _isBishopMoveValid(board, fromRow, fromCol, toRow, toCol);
      case ChessPieceType.queen:
        return _isRookMoveValid(board, fromRow, fromCol, toRow, toCol) ||
            _isBishopMoveValid(board, fromRow, fromCol, toRow, toCol);
      case ChessPieceType.king:
        return _isKingMoveValid(board, fromRow, fromCol, toRow, toCol);
    }
  }

  bool _isPawnMoveValid(
    List<List<ChessEntity?>> board,
    int fromRow,
    int fromCol,
    int toRow,
    int toCol,
    bool isWhite,
  ) {
    final direction = isWhite ? -1 : 1;
    final startRow = isWhite ? 6 : 1;

    if (fromCol == toCol &&
        fromRow + direction == toRow &&
        board[toRow][toCol] == null) {
      return true;
    }

    if (fromRow == startRow &&
        fromCol == toCol &&
        fromRow + 2 * direction == toRow &&
        board[toRow][toCol] == null &&
        board[fromRow + direction][fromCol] == null) {
      return true;
    }

    if ((toCol == fromCol + 1 || toCol == fromCol - 1) &&
        toRow == fromRow + direction &&
        board[toRow][toCol] != null &&
        board[toRow][toCol]!.isWhite != isWhite) {
      return true;
    }

    return false;
  }

  bool _isRookMoveValid(
    List<List<ChessEntity?>> board,
    int fromRow,
    int fromCol,
    int toRow,
    int toCol,
  ) {
    if (fromRow != toRow && fromCol != toCol) return false;

    if (fromRow == toRow) {
      final step = (toCol - fromCol).sign;
      for (int c = fromCol + step; c != toCol; c += step) {
        if (board[fromRow][c] != null) return false;
      }
    } else {
      final step = (toRow - fromRow).sign;
      for (int r = fromRow + step; r != toRow; r += step) {
        if (board[r][fromCol] != null) return false;
      }
    }
    return true;
  }

  bool _isKnightMoveValid(
    List<List<ChessEntity?>> board,
    int fromRow,
    int fromCol,
    int toRow,
    int toCol,
  ) {
    final dRow = (toRow - fromRow).abs();
    final dCol = (toCol - fromCol).abs();
    return (dRow == 2 && dCol == 1) || (dRow == 1 && dCol == 2);
  }

  bool _isBishopMoveValid(
    List<List<ChessEntity?>> board,
    int fromRow,
    int fromCol,
    int toRow,
    int toCol,
  ) {
    if ((toRow - fromRow).abs() != (toCol - fromCol).abs()) return false;

    final rowStep = (toRow - fromRow).sign;
    final colStep = (toCol - fromCol).sign;
    int r = fromRow + rowStep;
    int c = fromCol + colStep;
    while (r != toRow) {
      if (board[r][c] != null) return false;
      r += rowStep;
      c += colStep;
    }
    return true;
  }

  bool _isKingMoveValid(
    List<List<ChessEntity?>> board,
    int fromRow,
    int fromCol,
    int toRow,
    int toCol,
  ) {
    final dRow = (toRow - fromRow).abs();
    final dCol = (toCol - fromCol).abs();
    return dRow <= 1 && dCol <= 1;
  }
}
