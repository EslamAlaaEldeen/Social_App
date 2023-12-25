import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter/layout/social_app/cubit/cubit.dart';
import 'package:social_app_flutter/layout/social_app/cubit/state.dart';
import 'package:social_app_flutter/shared/components/components.dart';

class EditProfile extends StatelessWidget {
  var namecontroller = TextEditingController();
  var biocontroller = TextEditingController();
  var phonecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var usermodel = SocialCubit.get(context).usermodel;
        var Profileimage = SocialCubit.get(context).Profileimage;
        var Coverimage = SocialCubit.get(context).Coverimage;
        namecontroller.text = usermodel!.name!;
        biocontroller.text = usermodel.bio!;
        phonecontroller.text = usermodel.phone!;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            leading: IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                )),
            titleSpacing: 0,
            title: Text(
              'Edit profile',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    SocialCubit.get(context).UpdateUser(
                        name: namecontroller.text,
                        phone: phonecontroller.text,
                        bio: biocontroller.text);
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ))
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    LinearProgressIndicator(
                      color: Colors.teal,
                    ),
                  if (state is SocialUserUpdateLoadingState)
                    SizedBox(
                      height: 10,
                    ),
                  Container(
                    height: 160,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4)),
                                  image: DecorationImage(
                                    image: Coverimage == null
                                        ? NetworkImage('${usermodel.cover}')
                                            as ImageProvider<Object>
                                        : FileImage(Coverimage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                  icon: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.teal,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                      ))),
                            ],
                          ),
                          alignment: Alignment.topCenter,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              radius: 55,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: Profileimage == null
                                    ? NetworkImage('${usermodel.image}')
                                        as ImageProvider<Object>?
                                    : FileImage(Profileimage),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getProfileImage();
                                },
                                icon: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.teal,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (SocialCubit.get(context).Profileimage != null ||
                      SocialCubit.get(context).Coverimage != null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).Profileimage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultbutton(
                                    background: Colors.teal,
                                    function: () {
                                      SocialCubit.get(context)
                                          .uploadProfileImage(
                                              name: namecontroller.text,
                                              phone: phonecontroller.text,
                                              bio: biocontroller.text);
                                    },
                                    text: 'Upload Image'),
                                if (state is SocialUserUpdateLoadingState)
                                  SizedBox(
                                    height: 5,
                                  ),
                                if (state is SocialUserUpdateLoadingState)
                                  LinearProgressIndicator(
                                    color: Colors.teal,
                                  )
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 15,
                        ),
                        if (SocialCubit.get(context).Coverimage != null)
                          Expanded(
                              child: Column(
                            children: [
                              defaultbutton(
                                  background: Colors.teal,
                                  function: () {
                                    SocialCubit.get(context).uploadCoverImage(
                                        name: namecontroller.text,
                                        phone: phonecontroller.text,
                                        bio: biocontroller.text);
                                  },
                                  text: 'Upload Cover'),
                              if (state is SocialUserUpdateLoadingState)
                                SizedBox(
                                  height: 5,
                                ),
                              if (state is SocialUserUpdateLoadingState)
                                LinearProgressIndicator(
                                  color: Colors.teal,
                                )
                            ],
                          )),
                      ],
                    ),
                  if (SocialCubit.get(context).Profileimage != null ||
                      SocialCubit.get(context).Coverimage != null)
                    SizedBox(
                      height: 20,
                    ),
                  defaultFormField(
                      controller: namecontroller,
                      type: TextInputType.name,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'please enter your number';
                        }
                      },
                      labeltext: 'Name',
                      prefex: Icons.person_2_outlined),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                      controller: biocontroller,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'please enter the bio';
                        }
                      },
                      labeltext: 'Bio',
                      prefex: Icons.info_outline),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                      controller: phonecontroller,
                      type: TextInputType.phone,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'phone number must be entered';
                        }
                      },
                      labeltext: 'phone',
                      prefex: Icons.call),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
