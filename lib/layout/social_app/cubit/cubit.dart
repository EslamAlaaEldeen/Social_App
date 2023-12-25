import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_flutter/models/social_app/message_model.dart';
import 'package:social_app_flutter/models/social_app/post_model.dart';
import 'package:social_app_flutter/models/social_app/social_user_model.dart';
import 'package:social_app_flutter/modules/social_app/chats/chat_screen.dart';
import 'package:social_app_flutter/modules/social_app/feeds/feeds_screen.dart';
import 'package:social_app_flutter/modules/social_app/post_screen/post_screen.dart';
import 'package:social_app_flutter/modules/social_app/settings/setting_screen.dart';
import 'package:social_app_flutter/modules/social_app/users/users_screen.dart';
import 'package:social_app_flutter/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'state.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());
  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? usermodel;
  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      //print(value.data());
      usermodel = SocialUserModel.fromjson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    feeds_screen(),
    Chat_screen(),
    NewPostScreen(),
    Users_screen(),
    Settings_screen(),
  ];
  List<String> title = [
    'Home',
    'Chat',
    'Post',
    'Users',
    'Settings',
  ];
  void changeBottomNav(int index) {
    if (index == 1) getUsers();
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeNavBarState());
    }
  }

  var picker = ImagePicker();
  File? Profileimage;
  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Profileimage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('no image selected');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? Coverimage;
  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Coverimage = File(pickedFile.path);
      emit(SocialCoverPickedSuccessState());
    } else {
      print('no image selected');
      emit(SocialCoverPickedErrorState());
    }
  }

  void uploadProfileImage({
    required String? name,
    required String? phone,
    required String? bio,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(Profileimage!.path).pathSegments.last}')
        .putFile(Profileimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadProfileImageSuccessstate());
        print(value);
        UpdateUser(name: name, phone: phone, bio: bio, profile: value);
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String? name,
    required String? phone,
    required String? bio,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(Coverimage!.path).pathSegments.last}')
        .putFile(Coverimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadCoverImageSuccessstate());
        print(value);
        UpdateUser(name: name, phone: phone, bio: bio, Cover: value);
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  /* void UpdateUserImages({
    required String? name,
    required String? phone,
    required String? bio,
  }) {
    emit(SocialUserUpdateLoadingstate());
    if (Coverimage != null) {
      uploadCoverImage();
    } else if (Profileimage != null) {
      uploadProfileImage();
    } else if (Profileimage != null && Coverimage != null) {
    } else {
      UpdateUser(name: name, phone: phone, bio: bio);
    }
  }*/

  void UpdateUser({
    required String? name,
    required String? phone,
    required String? bio,
    String? profile,
    String? Cover,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      bio: bio,
      phone: phone,
      email: usermodel!.email,
      uId: usermodel!.uId,
      cover: Cover ?? usermodel!.cover,
      image: profile ?? usermodel!.image,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(usermodel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? Postimage;
  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Postimage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('no image selected');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void RemovePostImage() {
    Postimage = null;
    emit(SocialRemovePostImageState());
  }

  void UploadPostImage({
    required String? text,
    required String? datetime,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(Postimage!.path).pathSegments.last}')
        .putFile(Postimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(text: text, datetime: datetime, postImage: value);
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String? text,
    required String? datetime,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name: usermodel!.name,
      uId: usermodel!.uId,
      image: usermodel!.image,
      text: text,
      datetime: datetime,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> comment = [];
  void getPosts() {
    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          posts.add(PostModel.fromjson(element.data()));
          postsId.add(element.id);
          likes.add(value.docs.length);
          comment.add(value.docs.length);
        }).catchError((error) {});
      });
      emit(SocialGetPostSuccessState());
    }).catchError((error) {
      emit(SocialGetPostErrorState(error.toString()));
    });
  }

  void likePosts(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(usermodel!.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void commentPosts(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(usermodel!.uId)
        .set({'comments': true}).then((value) {
      emit(SocialCommentPostSuccessState());
    }).catchError((error) {
      emit(SocialCommentPostErrorState(error.toString()));
    });
  }

  List<SocialUserModel> users = [];
  void getUsers() {
    if (users.length == 0) emit(SocialGetAllUserLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] != usermodel!.uId)
          users.add(SocialUserModel.fromjson(element.data()));
      });
      emit(SocialGetAllUserSuccessState());
    }).catchError((error) {
      emit(SocialGetAllUserErrorState(error.toString()));
      print(error);
    });
  }

  void sendMessage({
    required String receiverId,
    required String datetime,
    required String text,
  }) {
    MessageModel model = MessageModel(
      senderId: usermodel!.uId,
      receiverId: receiverId,
      datetime: datetime,
      text: text,
    );
    //sender chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(usermodel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
    //receiver chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(usermodel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
  void getMessage({
    required String receiverId,
  }) {
    messages = []; // foe duplicate
    FirebaseFirestore.instance
        .collection('users')
        .doc(usermodel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('datetime')
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        messages.add(MessageModel.fromjson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }
}
