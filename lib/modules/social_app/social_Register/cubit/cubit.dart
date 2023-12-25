
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter/models/social_app/social_user_model.dart';

import 'state.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());
  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);
      userCreate(
        uId: value.user!.uid,
        email: email,
        phone: phone,
        name: name,
      );
    }).catchError((error) {
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }) {
    SocialUserModel model = SocialUserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      image:
          'https://img.freepik.com/free-photo/analog-portrait-beautiful-woman-posing-artistically-indoors_23-2149630182.jpg?w=1060&t=st=1701955607~exp=1701956207~hmac=584ed4ce0a96bf3f6ac9b4086d78eb291de0f1ff7327b11c8be1fe1ca8eaef6c',
      cover:
          'https://img.freepik.com/free-photo/analog-portrait-beautiful-woman-posing-artistically-indoors_23-2149630182.jpg?w=1060&t=st=1701955607~exp=1701956207~hmac=584ed4ce0a96bf3f6ac9b4086d78eb291de0f1ff7327b11c8be1fe1ca8eaef6c',
      bio: 'what you bio',
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  bool ispassword = true;
  IconData suffix = Icons.visibility_outlined;
  void ChangePasswordVisibiltyRegister() {
    ispassword = !ispassword;
    suffix =
        ispassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(SocialRegisterChangePasswordVisibilityState());
  }
}
