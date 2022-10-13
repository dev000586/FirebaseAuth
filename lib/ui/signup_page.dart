import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Navigation/CustomNavigator.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/event_status.dart';
import '../helper/utils/utils.dart';
import 'commonwidgets/form_input_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool showPassword = false;
  bool isFormSubmitted = false;
  final TextEditingController _nameController = TextEditingController();
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
    StateStatus eventStatus = state.signupStatus;
    print("Listening");
    if(eventStatus is StateLoaded){
      showSnackBar(context, eventStatus.successMessage, Colors.green);
      Navigator.pop(context);
    }
    if(eventStatus is StateFailed){
      showSnackBar(context, eventStatus.errorMessage, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('Signup'),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listenWhen:  (previous, current) {
            return previous != current;
          },
          listener: _listener,
          builder: (context, state) {
            StateStatus eventStatus = state.signupStatus;
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 80,),
                      const Text(
                        "SIGNUP",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.green
                        ),
                      ),
                      const SizedBox(height: 20,),
                      CustomFormInputField(
                          label: "Name",
                          hintText: "Enter name",
                          textController: _nameController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter email.';
                            }else if(value.length < 3){
                              return 'Name should have atleast 3 characters.';
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
                          showPassword: showPassword,
                          textController: _passwordController,
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
                              triggerAuthEvent(OnSignUpEvent(
                                  name: _nameController.text,
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
                                  :const Text("Signup")))
                    ],
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}
