import 'package:firbase_auth/helper/constants/app_constants.dart';
import 'package:firbase_auth/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firbase_auth/injection_container.dart' as di;

import 'bloc/bloc_ovserver.dart';
import 'bloc/bloc_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool isLoggedIn = false;
globalInitializer() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final pref = await SharedPreferences.getInstance();
  isLoggedIn = pref.getBool(AppConstants.ISLOGGEDIN) ?? false;
  await Firebase.initializeApp();
}
void main() async {
  await globalInitializer();

  BlocOverrides.runZoned(() =>
      runApp(const MyApp()),
      blocObserver: CustomBlocOvserver()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CustomBlocProvider(
      child: MaterialApp(
          title: 'Firebase Authentication',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RoutesConst.generateRoute,
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.green,
          ),
        initialRoute: isLoggedIn ? RoutesConst.home : RoutesConst.login,
      ),
    );
  }
}
