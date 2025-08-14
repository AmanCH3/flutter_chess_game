import 'dart:math';

import 'package:flutter_chess_game/domain/entity/chess_entity.dart';

class ValidateMoveUseCase {
  bool call({
    required List<List<ChessEntity?>> board,
    required int fromRow,
    required int fromCol,
    required int toRow,
    required int toCol,
  }) {
    final piece = board[fromRow][fromCol];
    if (piece == null) {
      return false;
    }

    // A piece cannot capture a piece of the same color
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
        // A queen moves like a rook or a bishop
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

    // Standard 1-square move
    if (fromCol == toCol &&
        fromRow + direction == toRow &&
        board[toRow][toCol] == null) {
      return true;
    }

    // Initial 2-square move
    if (fromRow == startRow &&
        fromCol == toCol &&
        fromRow + 2 * direction == toRow &&
        board[toRow][toCol] == null &&
        board[fromRow + direction][fromCol] == null) {
      return true;
    }

    // Diagonal capture
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
    if (fromRow != toRow && fromCol != toCol) {
      return false; // Not a horizontal or vertical move
    }

    // Check for obstructions
    if (fromRow == toRow) {
      // Horizontal move
      final step = (toCol - fromCol).sign;
      for (int c = fromCol + step; c != toCol; c += step) {
        if (board[fromRow][c] != null) return false;
      }
    } else {
      // Vertical move
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
    if ((toRow - fromRow).abs() != (toCol - fromCol).abs()) {
      return false; // Not a diagonal move
    }

    // Check for obstructions
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
