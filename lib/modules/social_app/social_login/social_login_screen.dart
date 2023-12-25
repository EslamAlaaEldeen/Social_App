
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter/layout/social_app/social_layout.dart';
import 'package:social_app_flutter/modules/social_app/social_Register/social_register.dart';
import 'package:social_app_flutter/shared/components/components.dart';
import 'package:social_app_flutter/shared/network/local/cache_helper.dart';

import 'cubit/cubit.dart';
import 'cubit/state.dart';

class SocialLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            ShowToast(text: state.error, state: ToastState.ERROR);
          }
          if (state is SocialLoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigateAndFinish(context, SocialLayout());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 50),
                      ),
                      Text(
                        'Login now to communicate with friends',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      defaultFormField(
                          controller: emailcontroller,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          labeltext: 'email address',
                          prefex: Icons.email_outlined),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        controller: passwordcontroller,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'password is too short';
                          }
                        },
                        onsubmitted: (value) {},
                        labeltext: 'Password',
                        ispassword: SocialLoginCubit.get(context).ispassword,
                        suffixpressed: () {
                          SocialLoginCubit.get(context)
                              .ChangePasswordVisibilty();
                        },
                        prefex: Icons.lock_outline,
                        suffix: SocialLoginCubit.get(context).suffix,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ConditionalBuilder(
                        condition: state is! SocialLoginLoadingState,
                        builder: (context) => defaultbutton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                SocialLoginCubit.get(context).userlogin(
                                    email: emailcontroller.text,
                                    password: passwordcontroller.text);
                              }
                            },
                            text: 'Login',
                            radius: 15,
                            isUpperCase: true),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have acount?',
                            style: TextStyle(fontSize: 20),
                          ),
                          defaultTextButtom(
                              function: () {
                                navigateTo(context, SocialRegisterScreen());
                              },
                              text: 'Register here')
                        ],
                      ),
                    ],
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
