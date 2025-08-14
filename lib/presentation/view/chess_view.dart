import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chess_game/domain/entity/chess_entity.dart'; // <-- IMPORT THIS
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import '../../core/error/service_locator/service_locator.dart';
import '../view_model/chess_event.dart';
import '../view_model/chess_state.dart';
import '../view_model/chess_view_model.dart';

class ChessBoardView extends StatelessWidget {
  const ChessBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChessBloc>()..add(InitializeBoardEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chess Game'),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.refresh, size: 30),
                  onPressed: () =>
                      context.read<ChessBloc>().add(ResetGameEvent()),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: BlocBuilder<ChessBloc, ChessState>(
            builder: (context, state) {
              if (state is ChessLoading || state is ChessInitial) {
                return const CircularProgressIndicator();
              }
              if (state is ChessError) {
                return Text('Error: ${state.message}');
              }
              if (state is ChessLoaded) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${state.isWhiteTurn ? "White's" : "Black's"} Turn',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                              ),
                          itemCount: 64,
                          itemBuilder: (context, index) {
                            final row = index ~/ 8;
                            final col = index % 8;
                            final piece = state.board[row][col];
                            final isLightSquare = (row + col) % 2 == 0;
                            final isSelected =
                                state.selectedRow == row &&
                                state.selectedCol == col;

                            return GestureDetector(
                              onTap: () => context.read<ChessBloc>().add(
                                // Assuming your event is named SquareTappedEvent
                                SqaureTappedEvent(row: row, col: col),
                              ),
                              child: Container(
                                color: isLightSquare
                                    ? Colors.brown[200]
                                    : Colors.brown[600],
                                child: Stack(
                                  alignment:
                                      Alignment.center, // Center the piece
                                  children: [
                                    if (piece != null)
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          // Pass the piece and the size to our helper
                                          return _getPieceWidget(
                                            piece,
                                            constraints.maxWidth,
                                          );
                                        },
                                      ),
                                    if (isSelected)
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 4,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Text('Something went wrong.');
            },
          ),
        ),
      ),
    );
  }

  /// Helper function to map our ChessEntity to a chess_vectors_flutter Widget.
  Widget _getPieceWidget(ChessEntity piece, double size) {
    switch (piece.type) {
      case ChessPieceType.pawn:
        return piece.isWhite ? WhitePawn(size: size) : BlackPawn(size: size);
      case ChessPieceType.rook:
        return piece.isWhite ? WhiteRook(size: size) : BlackRook(size: size);
      case ChessPieceType.knight:
        return piece.isWhite
            ? WhiteKnight(size: size)
            : BlackKnight(size: size);
      case ChessPieceType.bishop:
        return piece.isWhite
            ? WhiteBishop(size: size)
            : BlackBishop(size: size);
      case ChessPieceType.queen:
        return piece.isWhite ? WhiteQueen(size: size) : BlackQueen(size: size);
      case ChessPieceType.king:
        return piece.isWhite ? WhiteKing(size: size) : BlackKing(size: size);
    }
  }
}
