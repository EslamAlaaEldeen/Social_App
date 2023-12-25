
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter/layout/social_app/cubit/cubit.dart';
import 'package:social_app_flutter/layout/social_app/cubit/state.dart';
import 'package:social_app_flutter/models/social_app/message_model.dart';
import 'package:social_app_flutter/models/social_app/social_user_model.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel? userModel;
  ChatDetailsScreen({this.userModel});
  var messagecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessage(receiverId: userModel!.uId!);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, sate) {},
          builder: (context, sate) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.teal,
                  titleSpacing: 0,
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(userModel!.image!),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        userModel!.name!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                body: ConditionalBuilder(
                    condition: SocialCubit.get(context).messages.length > 0,
                    builder: (context) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var message = SocialCubit.get(context)
                                          .messages[index];
                                      if (SocialCubit.get(context)
                                              .usermodel!
                                              .uId ==
                                          message.senderId) {
                                        return buildMyMessage(message);
                                      }
                                      buildOtherMessage(message);
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height: 10,
                                        ),
                                    itemCount: SocialCubit.get(context)
                                        .messages
                                        .length),
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: messagecontroller,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                'type your message here ...'),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        SocialCubit.get(context).sendMessage(
                                            receiverId: userModel!.uId!,
                                            datetime: DateTime.now().toString(),
                                            text: messagecontroller.text);
                                      },
                                      minWidth: 1,
                                      child: Icon(
                                        Icons.send_rounded,
                                        color: Colors.teal,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    fallback: (context) => Center(
                            child: CircularProgressIndicator(
                          color: Colors.teal,
                        ))));
          },
        );
      },
    );
  }

  Widget buildOtherMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
                bottomEnd: Radius.circular(10),
              )),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            model.text!,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
  Widget buildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
                bottomStart: Radius.circular(10),
              )),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            model.text!,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      );
}
