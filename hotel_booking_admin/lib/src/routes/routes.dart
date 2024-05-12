import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_booking_admin/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:hotel_booking_admin/src/modules/create_hotel/blocs/upload_picture_bloc/upload_picture_bloc.dart';
import 'package:hotel_repository/hotel_repository.dart';
import '../modules/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/base/views/base_screen.dart';

import '../modules/create_hotel/blocs/create_hotel_bloc/create_hotel_bloc.dart';
import '../modules/create_hotel/views/create_hotel_screen.dart';
import '../modules/home/views/home_screen.dart';
import '../modules/splash/views/splash_screen.dart';

final _navKey = GlobalKey<NavigatorState>();
final _shellNavigationKey = GlobalKey<NavigatorState>();

GoRouter router (AuthenticationBloc authBloc) {
  return GoRouter(
    navigatorKey: _navKey,
    initialLocation: '/',
    redirect: (context, state) {
      if(authBloc.state.status == AuthenticationStatus.unknown) {
        return '/';
      }
    },
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigationKey,
        builder: (context, state, child) {
          if(state.fullPath == '/login' || state.fullPath == '/' ) {
            return child;
          } else {
            return BlocProvider<SignInBloc>(
              create: (context) => SignInBloc(
                context.read<AuthenticationBloc>().userRepository
              ),
              child: BaseScreen(child)
            );
          }
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => BlocProvider<AuthenticationBloc>.value(
              value: BlocProvider.of<AuthenticationBloc>(context),
              child: const SplashScreen(),
            )
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => BlocProvider<AuthenticationBloc>.value(
              value: BlocProvider.of<AuthenticationBloc>(context),
              child: BlocProvider<SignInBloc>(
                create: (context) => SignInBloc(
                  context.read<AuthenticationBloc>().userRepository
                ),
                child: const SignInScreen(),
              ),
            )
          ),
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/create',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => UploadPictureBloc(
                    FirebaseHotelRepo()
                  ),
                ),
                BlocProvider(
                  create: (context) => CreateHotelBloc(
                    FirebaseHotelRepo()
                  ),
                )
              ], 
              child: const CreateHotelScreen()),
            )
        ]
      )
    ]
  );
}