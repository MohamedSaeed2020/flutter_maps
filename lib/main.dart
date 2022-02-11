import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/shared/app_routes.dart';
import 'package:flutter_maps/shared/constants/strings.dart';


//variables
late String initialRoute;

void main() async {
  //initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Check if user logged or not
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      initialRoute = loginsScreen;
    } else {
      initialRoute = mapScreen;
    }
  });
  runApp(MyMapsApp(
    appRouter: AppRouter(),
  ));
}

class MyMapsApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyMapsApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoutes,
      initialRoute: initialRoute,
    );
  }
}
