import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chess_game/domain/entity/chess_entity.dart';
import 'package:flutter_chess_game/domain/usecase/initialize_board_usecase.dart';
import 'package:flutter_chess_game/presentation/view_model/chess_event.dart';
import 'package:flutter_chess_game/presentation/view_model/chess_state.dart';

class ChessBloc extends Bloc<ChessEvent, ChessState> {
  final GetInitialBoardUseCase initializeBoardUseCase;

  ChessBloc({required this.initializeBoardUseCase}) : super(ChessInitial()) {
    on<InitializeBoardEvent>(_onInitializeBoard);
    on<ResetGameEvent>(_onInitializeBoard); // Resetting is same as initializing
    on<SqaureTappedEvent>(_onSquareTapped);
  }

  void _onInitializeBoard(ChessEvent event, Emitter<ChessState> emit) async {
    emit(ChessLoading());
    final result = await initializeBoardUseCase();
    result.fold(
      (failure) => emit(ChessError(failure.message)),
      (boardData) => emit(ChessLoaded(board: boardData)),
    );
  }

  void _onSquareTapped(SqaureTappedEvent event, Emitter<ChessState> emit) {
    final currentState = state;
    if (currentState is! ChessLoaded) return; // Ignore taps if not loaded

    final int row = event.row;
    final int col = event.col;
    final ChessEntity? tappedPiece = currentState.board[row][col];

    // Create a mutable copy of the board for this operation
    final newBoard = List<List<ChessEntity?>>.from(
      currentState.board.map((row) => List<ChessEntity?>.from(row)),
    );

    // Case 1: A piece is already selected
    if (currentState.selectedRow != null) {
      // Logic for moving the piece
      // IMPORTANT: Add your move validation logic here!
      _movePiece(emit, currentState, newBoard, row, col);
    }
    // Case 2: No piece is selected, and user taps a piece of their color
    else if (tappedPiece != null &&
        tappedPiece.isWhite == currentState.isWhiteTurn) {
      emit(currentState.copyWith(selectedRow: row, selectedCol: col));
    }
  }

  void _movePiece(
    Emitter<ChessState> emit,
    ChessLoaded currentState,
    List<List<ChessEntity?>> newBoard,
    int targetRow,
    int targetCol,
  ) {
    final selectedPiece =
        newBoard[currentState.selectedRow!][currentState.selectedCol!];

    // Simple validation: move to an empty square or capture an opponent's piece
    if (newBoard[targetRow][targetCol]?.isWhite != currentState.isWhiteTurn) {
      newBoard[targetRow][targetCol] = selectedPiece;
      newBoard[currentState.selectedRow!][currentState.selectedCol!] = null;

      emit(
        currentState.copyWith(
          board: newBoard,
          isWhiteTurn: !currentState.isWhiteTurn,
          clearSelection: true,
        ),
      );
    } else {
      // If the move is invalid (e.g., tapping another of your own pieces),
      // just clear the selection.
      emit(currentState.copyWith(clearSelection: true));
    }
  }
}
