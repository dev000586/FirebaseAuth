import 'package:firbase_auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firbase_auth/injection_container.dart' as di;

class CustomBlocProvider extends StatelessWidget {
  final Widget child;
  const CustomBlocProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:[
          BlocProvider<AuthBloc>(create: (context)=> di.serviceLocator()),
        ],
        child: child
    );
  }
}
