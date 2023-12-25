import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter/layout/social_app/cubit/cubit.dart';
import 'package:social_app_flutter/layout/social_app/cubit/state.dart';

class NewPostScreen extends StatelessWidget {
  var textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit.get(context).usermodel;
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
              'Create Post',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    var now = DateTime.now();
                    if (SocialCubit.get(context).Postimage == null) {
                      SocialCubit.get(context).createPost(
                          text: textcontroller.text, datetime: now.toString());
                    } else {
                      SocialCubit.get(context).UploadPostImage(
                          text: textcontroller.text, datetime: now.toString());
                    }
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is SocialCreatePostLoadingState)
                  LinearProgressIndicator(
                    color: Colors.teal,
                  ),
                if (state is SocialCreatePostLoadingState)
                  SizedBox(
                    height: 10,
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          '${SocialCubit.get(context).usermodel!.image}'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${SocialCubit.get(context).usermodel!.name}',
                                style: TextStyle(fontSize: 15, height: 1.3),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          Text(
                            'Public',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textcontroller,
                    decoration: InputDecoration(
                        hintText: 'What is on your mind .....',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (SocialCubit.get(context).Postimage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image:
                                FileImage(SocialCubit.get(context).Postimage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            SocialCubit.get(context).RemovePostImage();
                          },
                          icon: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.teal,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ))),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo,
                              color: Colors.teal,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'add photo',
                              style: TextStyle(color: Colors.teal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          '# tags',
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
