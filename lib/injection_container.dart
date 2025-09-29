import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'core/network/network_info.dart';

// Services
import 'services/firebase_service.dart';
import 'services/supabase_service.dart';
import 'services/gemini_service.dart';
import 'services/location_service.dart';

// Auth Feature
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Grievances Feature
import 'features/grievances/data/datasources/grievance_remote_datasource.dart';
import 'features/grievances/data/repositories/grievance_repository_impl.dart';
import 'features/grievances/domain/repositories/grievance_repository.dart';
import 'features/grievances/domain/usecases/create_grievance_usecase.dart';
import 'features/grievances/domain/usecases/get_grievances_usecase.dart';
import 'features/grievances/domain/usecases/update_grievance_usecase.dart';
import 'features/grievances/presentation/bloc/grievance_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Services
  sl.registerLazySingleton(() => FirebaseService());
  sl.registerLazySingleton(() => SupabaseService());
  GeminiService.initialize();
  sl.registerLazySingleton(() => LocationService());

  // Auth Feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // Grievances Feature
  sl.registerLazySingleton<GrievanceRemoteDataSource>(
    () => GrievanceRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<GrievanceRepository>(
    () => GrievanceRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton(() => CreateGrievanceUseCase(sl()));
  sl.registerLazySingleton(() => GetGrievancesUseCase(sl()));
  sl.registerLazySingleton(() => UpdateGrievanceUseCase(sl()));

  sl.registerFactory(
    () => GrievanceBloc(
      createGrievanceUseCase: sl(),
      getGrievancesUseCase: sl(),
      updateGrievanceUseCase: sl(),
    ),
  );
}
