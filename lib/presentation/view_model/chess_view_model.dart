import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chess_game/domain/entity/chess_entity.dart';
import 'package:flutter_chess_game/domain/service/chess_rules_service.dart';
import 'package:flutter_chess_game/domain/usecase/initialize_board_usecase.dart';
import 'package:flutter_chess_game/domain/usecase/validate_move_usecase.dart';
import 'package:flutter_chess_game/presentation/view_model/chess_event.dart';
import 'package:flutter_chess_game/presentation/view_model/chess_state.dart';

class ChessBloc extends Bloc<ChessEvent, ChessState> {
  final GetInitialBoardUseCase initializeBoardUseCase;
  final ValidateMoveUseCase validateMoveUseCase;
  final ChessRulesService chessRulesService;

  ChessBloc({
    required this.initializeBoardUseCase,
    required this.validateMoveUseCase,
    required this.chessRulesService,
  }) : super(ChessInitial()) {
    on<InitializeBoardEvent>(_onInitializeBoard);
    on<ResetGameEvent>(_onInitializeBoard);
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

  void _onSquareTapped(
    SqaureTappedEvent event,
    Emitter<ChessState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChessLoaded) return;

    final int row = event.row;
    final int col = event.col;
    final ChessEntity? tappedPiece = currentState.board[row][col];

    final newBoard = List<List<ChessEntity?>>.from(
      currentState.board.map((row) => List<ChessEntity?>.from(row)),
    );

    if (currentState.selectedRow != null) {
      final result = await validateMoveUseCase(
        ValidateMoveParams(
          board: currentState.board,
          fromRow: currentState.selectedRow!,
          fromCol: currentState.selectedCol!,
          toRow: row,
          toCol: col,
        ),
      );

      // Extract boolean from Either
      final isValid = result.fold((failure) => false, (success) => success);

      if (isValid) {
        _movePiece(emit, currentState, newBoard, row, col);
      } else {
        emit(currentState.copyWith(clearSelection: true));
      }
    } else if (tappedPiece != null &&
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

    newBoard[targetRow][targetCol] = selectedPiece;
    newBoard[currentState.selectedRow!][currentState.selectedCol!] = null;
    final opponentIsWhite = !currentState.isWhiteTurn;

    if (chessRulesService.isCheckmate(newBoard, opponentIsWhite)) {
      emit(ChessGameOver(winner: currentState.isWhiteTurn ? 'White' : 'Black'));
    } else {
      emit(
        currentState.copyWith(
          board: newBoard,
          isWhiteTurn: !currentState.isWhiteTurn,
          clearSelection: true,
        ),
      );
    }
  }
}
