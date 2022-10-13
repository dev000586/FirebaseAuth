import 'package:firbase_auth/Navigation/CustomNavigator.dart';
import 'package:firbase_auth/bloc/event_status.dart';
import 'package:firbase_auth/helper/utils/utils.dart';
import 'package:firbase_auth/ui/commonwidgets/form_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;
  bool isFormSubmitted = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void triggerAuthEvent(AuthEvent event) {
    context.read<AuthBloc>().add(event);
  }

  @override
  void initState() {
    triggerAuthEvent(AuthInitialEvent());
    super.initState();
  }

  void _listener(BuildContext context, AuthState state) {
    StateStatus eventStatus = state.loginStatus;
    print("Listening");
    if(eventStatus is StateLoaded){
      showSnackBar(context, eventStatus.successMessage, Colors.green);
      CustomNavigator().navigateToHome(context);
    }
    if(eventStatus is StateFailed){
      showSnackBar(context, eventStatus.errorMessage, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          leading: Container(),
          leadingWidth: 0,
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listenWhen:  (previous, current) {
            return previous != current;
          },
          listener: _listener,
          builder: (context, state) {
            StateStatus eventStatus = state.loginStatus;
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 80,),
                      const Text(
                          "LOGIN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.green
                        ),
                      ),
                      const SizedBox(height: 20,),
                      CustomFormInputField(
                          label: "Email",
                          hintText: "Enter email",
                          textController: _emailController,
                          validator: (value){
                            bool isValidEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
                            if(value.isEmpty){
                              return 'Please enter email.';
                            }else if(!isValidEmail){
                              return 'Invalid email.';
                            }
                            return null;
                          },
                          onChanged: (text){
                            if(isFormSubmitted) {
                              _formKey.currentState!.validate();
                            }
                          }
                      ),
                      const SizedBox(height: 10,),
                      CustomFormInputField(
                          label: "Password",
                          hintText: "Enter password",
                          isPassword: true,
                          textController: _passwordController,
                          showPassword: showPassword,
                          onShowPassword: (){
                            setState((){
                              showPassword = !showPassword;
                            });
                          },
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter password.';
                            }
                            return null;
                          },
                          onChanged: (text){
                            if(isFormSubmitted) {
                              _formKey.currentState!.validate();
                            }
                          }
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                          onPressed: (){
                            isFormSubmitted = true;
                            if(eventStatus is !StateLoading && _formKey.currentState!.validate()){
                              triggerAuthEvent(OnSignInEvent(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              );
                            }
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              alignment: Alignment.center,
                              child: eventStatus is StateLoading
                                  ? const CircularProgressIndicator(color: Colors.white,)
                                  :const Text("Login"),
                          ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(onPressed: (){CustomNavigator().navigateToSignup(context);}, child: const Text("Signup")),
                          TextButton(onPressed: (){CustomNavigator().navigateToForgetPassword(context);}, child: const Text("Forget Password?"))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ),
    );
  }
}
