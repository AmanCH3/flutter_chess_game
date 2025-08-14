import 'package:equatable/equatable.dart';

enum ChessPieceType { pawn, rook, knight, bishop, queen, king }

class ChessEntity extends Equatable {
  final ChessPieceType type;
  final bool isWhite;

  const ChessEntity({required this.type, required this.isWhite});
  @override
  List<Object?> get props => [type, isWhite];
}
