
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter/layout/social_app/cubit/cubit.dart';
import 'package:social_app_flutter/layout/social_app/cubit/state.dart';
import 'package:social_app_flutter/models/social_app/social_user_model.dart';
import 'package:social_app_flutter/modules/social_app/chat_details/chat_details_screen.dart';
import 'package:social_app_flutter/shared/components/components.dart';

class Chat_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.length > 0,
          builder: (context) => ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  buildChatItem(SocialCubit.get(context).users[index], context),
              separatorBuilder: (context, index) => MyDivider(),
              itemCount: SocialCubit.get(context).users.length),
          fallback: (context) => Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          ),
        );
      },
    );
  }

  Widget buildChatItem(SocialUserModel model, context) => InkWell(
        onTap: () {
          navigateTo(
              context,
              ChatDetailsScreen(
                userModel: model,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage('${model.image}'),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                '${model.name}  ',
                style: TextStyle(fontSize: 15, height: 1.3),
              ),
            ],
          ),
        ),
      );
}
