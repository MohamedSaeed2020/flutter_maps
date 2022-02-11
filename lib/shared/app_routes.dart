import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubits/map_cubit/maps_cubit.dart';
import 'package:flutter_maps/business_logic/cubits/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:flutter_maps/data/repositories/place_suggestions_repositories.dart';
import 'package:flutter_maps/data/web_services/place_web_services.dart';
import 'package:flutter_maps/presentation/screens/login.dart';
import 'package:flutter_maps/presentation/screens/map.dart';
import 'package:flutter_maps/presentation/screens/otp.dart';
import 'package:flutter_maps/shared/constants/strings.dart';

class AppRouter {
  late PhoneAuthCubit _phoneAuthCubit;

  AppRouter() {
    _phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case loginsScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _phoneAuthCubit,
            child: LoginScreen(),
          ),
        );
      case otpScreen:
        final String phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _phoneAuthCubit,
            child: OtpScreen(
              phoneNumber: phoneNumber,
            ),
          ),
        );
      case mapScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<MapsCubit>(
              create: (context) =>
                  MapsCubit(PlaceSuggestionsRepositories(PlaceWebServices())),
              child: const MapScreen()),
        );
    }
  }
}
