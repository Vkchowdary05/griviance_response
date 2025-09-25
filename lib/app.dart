import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/route_constants.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/grievances/presentation/bloc/grievance_bloc.dart';
import 'features/grievances/presentation/pages/dashboard_page.dart';
import 'features/grievances/presentation/pages/create_grievance_page.dart';
import 'features/grievances/presentation/pages/grievance_list_page.dart';
import 'features/grievances/presentation/pages/grievance_detail_page.dart';
import 'injection_container.dart' as di;

class GrievanceApp extends StatelessWidget {
  const GrievanceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<GrievanceBloc>(
          create: (context) => di.sl<GrievanceBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Grievance System',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  static final GoRouter _router = GoRouter(
    initialLocation: RouteConstants.splash,
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteConstants.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteConstants.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: RouteConstants.createGrievance,
        name: 'create_grievance',
        builder: (context, state) => const CreateGrievancePage(),
      ),
      GoRoute(
        path: RouteConstants.grievanceList,
        name: 'grievance_list',
        builder: (context, state) => const GrievanceListPage(),
      ),
      GoRoute(
        path: RouteConstants.grievanceDetail,
        name: 'grievance_detail',
        builder: (context, state) {
          final grievanceId = state.pathParameters['id']!;
          return GrievanceDetailPage(grievanceId: grievanceId);
        },
      ),
    ],
    redirect: (context, state) {
      final authBloc = context.read<AuthBloc>();
      final isAuthenticated = authBloc.state is AuthenticatedState;
      final isLoading = authBloc.state is AuthLoadingState;
      
      // Show splash while loading
      if (isLoading && state.matchedLocation != RouteConstants.splash) {
        return RouteConstants.splash;
      }
      
      // Redirect to login if not authenticated
      if (!isAuthenticated && 
          state.matchedLocation != RouteConstants.login && 
          state.matchedLocation != RouteConstants.register &&
          state.matchedLocation != RouteConstants.splash) {
        return RouteConstants.login;
      }
      
      // Redirect to dashboard if authenticated and on auth pages
      if (isAuthenticated && 
          (state.matchedLocation == RouteConstants.login || 
           state.matchedLocation == RouteConstants.register ||
           state.matchedLocation == RouteConstants.splash)) {
        return RouteConstants.dashboard;
      }
      
      return null;
    },
  );
}
