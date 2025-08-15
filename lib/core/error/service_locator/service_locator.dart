import 'package:flutter_chess_game/data/repository/chess_repository_impl.dart';
import 'package:flutter_chess_game/domain/repostiory/chess_repository.dart';
import 'package:flutter_chess_game/domain/service/chess_rules_service.dart';
import 'package:flutter_chess_game/domain/usecase/initialize_board_usecase.dart';
import 'package:flutter_chess_game/domain/usecase/validate_move_usecase.dart';
import 'package:flutter_chess_game/presentation/view_model/chess_view_model.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerFactory(
    () => ChessBloc(
      initializeBoardUseCase: sl(),
      validateMoveUseCase: sl(),
      chessRulesService: sl(),
    ),
  );
  sl.registerLazySingleton(() => ChessRulesService()) ;
  sl.registerLazySingleton(() => GetInitialBoardUseCase(sl()));
  sl.registerLazySingleton(() => ValidateMoveUseCase(sl()));
  sl.registerLazySingleton<ChessRepository>(
    () => ChessRepositoryImpl(chessRulesService: ChessRulesService()),
  );
}
