import 'package:firbase_auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/event_status.dart';
import '../helper/utils/utils.dart';
import 'commonwidgets/form_input_field.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  bool showPassword = false;
  bool isFormSubmitted = false;
  final TextEditingController _emailController = TextEditingController();
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
    StateStatus eventStatus = state.forgetPasswordStatus;
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
          title: const Text('Forget Password'),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listenWhen:  (previous, current) {
            return previous != current;
          },
          listener: _listener,
          builder: (context, state) {
            StateStatus eventStatus = state.forgetPasswordStatus;
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 80,),
                      const Text(
                        "FORGET PASSWORD",
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
                      const SizedBox(height: 20,),
                      ElevatedButton(
                          onPressed: (){
                            isFormSubmitted = true;
                            if(eventStatus is !StateLoading && _formKey.currentState!.validate()){
                              triggerAuthEvent(OnForgetPasswordEvent(
                                  email: _emailController.text
                              ));
                            }
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              alignment: Alignment.center,
                              child: eventStatus is StateLoading
                                  ? const CircularProgressIndicator(color: Colors.white,)
                                  :const Text("Sent email")))
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
