
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter/layout/social_app/social_layout.dart';
import 'package:social_app_flutter/shared/components/components.dart';

import 'cubit/cubit.dart';
import 'cubit/state.dart';

class SocialRegisterScreen extends StatelessWidget {
  var namecontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var phonecontroller = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            navigateAndFinish(context, SocialLayout());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(fontSize: 40),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Register now to communicate with friends',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        defaultFormField(
                            controller: namecontroller,
                            type: TextInputType.name,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your name';
                              }
                            },
                            labeltext: 'UserName',
                            prefex: Icons.person_2_outlined),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            controller: emailcontroller,
                            type: TextInputType.emailAddress,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your email';
                              }
                            },
                            labeltext: 'Email Address',
                            prefex: Icons.email_outlined),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            controller: passwordcontroller,
                            type: TextInputType.visiblePassword,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'password is too short';
                              }
                            },
                            labeltext: 'Password',
                            ispassword:
                                SocialRegisterCubit.get(context).ispassword,
                            suffixpressed: SocialRegisterCubit.get(context)
                                .ChangePasswordVisibiltyRegister,
                            suffix: SocialRegisterCubit.get(context).suffix,
                            prefex: Icons.lock_outline),
                        SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            controller: phonecontroller,
                            type: TextInputType.phone,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your number';
                              }
                            },
                            labeltext: 'Phone',
                            prefex: Icons.phone_outlined),
                        SizedBox(
                          height: 15,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState,
                          builder: (context) => defaultbutton(
                              function: () {
                                if (formkey.currentState!.validate()) {
                                  SocialRegisterCubit.get(context).userRegister(
                                      name: namecontroller.text,
                                      email: emailcontroller.text,
                                      password: passwordcontroller.text,
                                      phone: phonecontroller.text);
                                }
                              },
                              text: 'Register',
                              radius: 15,
                              isUpperCase: true),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
