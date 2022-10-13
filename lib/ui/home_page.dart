import 'package:firbase_auth/helper/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Navigation/CustomNavigator.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/event_status.dart';
import '../helper/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "User";
  void triggerAuthEvent(AuthEvent event) {
    context.read<AuthBloc>().add(event);
  }

  @override
  void initState() {
    triggerAuthEvent(AuthInitialEvent());
    super.initState();
  }

  void _listener(BuildContext context, AuthState state) async {
    StateStatus eventStatus = state.logoutStatus;
    final pref = await SharedPreferences.getInstance();
    userName = pref.getString(AppConstants.USERNAME) ?? "User";
    print("Listening");
    if(eventStatus is StateLoaded){
      showSnackBar(context, eventStatus.successMessage, Colors.green);
      CustomNavigator().navigateToLogin(context);
    }
    if(eventStatus is StateFailed){
      showSnackBar(context, eventStatus.errorMessage, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          leadingWidth: 0,
          leading: Container(),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listenWhen:  (previous, current) {
            return previous != current;
          },
          listener: _listener,
          builder: (context, state) {
            StateStatus eventStatus = state.logoutStatus;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    "Welcome $userName",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                      onPressed: (){
                        if(eventStatus is !StateLoading){
                          triggerAuthEvent(OnLogoutEvent());
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width/2,
                          alignment: Alignment.center,
                          child: eventStatus is StateLoading
                              ? const CircularProgressIndicator(color: Colors.white,)
                              :const Text("Logout")))
                ],
              ),
            );
          },
        )
    );
  }
}
