import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter/layout/social_app/cubit/cubit.dart';
import 'package:social_app_flutter/layout/social_app/cubit/state.dart';
import 'package:social_app_flutter/models/social_app/post_model.dart';
import 'package:social_app_flutter/models/social_app/social_user_model.dart';

class feeds_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).posts.length > 0 &&
              SocialCubit.get(context).usermodel != null,
          builder: (context) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.all(8),
                  elevation: 10,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image(
                    image: NetworkImage(
                        'https://img.freepik.com/free-photo/company-young-people-playing-board-game_158595-4896.jpg?w=1060&t=st=1701715557~exp=1701716157~hmac=2054e434b51018d408a78a0b62c2530df9be4b2c7f1d9460c79168593812e2bc'),
                    fit: BoxFit.cover,
                    height: 150,
                    width: double.infinity,
                  ),
                ),
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => buildPostItem(
                          SocialCubit.get(context).posts[index],
                          context,
                          index,
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                    itemCount: SocialCubit.get(context).posts.length),
              ],
            ),
          ),
          fallback: (context) => Center(
              child: CircularProgressIndicator(
            color: Colors.teal,
          )),
        );
      },
    );
  }

  Widget buildPostItem(
    PostModel model,
    context,
    index,
  ) =>
      Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 8),
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('${model.image}'),
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
                            '${model.name}',
                            style: TextStyle(fontSize: 15, height: 1.3),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ),
                      Text(
                        '${model.datetime}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.more_horiz_outlined))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[400],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${model.text}',
                style: TextStyle(fontSize: 16, height: 1.1),
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: double.infinity,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 5),
                      child: Container(
                        height: 20,
                        child: MaterialButton(
                          onPressed: () {},
                          child: Text(
                            '#software',
                            style: TextStyle(color: Colors.blue),
                          ),
                          minWidth: 1,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 5),
                      child: Container(
                        height: 20,
                        child: MaterialButton(
                          onPressed: () {},
                          child: Text(
                            '#software',
                            style: TextStyle(color: Colors.blue),
                          ),
                          minWidth: 1,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
            if (model.postImage != '')
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('${model.postImage}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.heart,
                          color: Colors.red,
                          size: 20,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          '${SocialCubit.get(context).likes[index]}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    child: Row(
                      children: [
                        Icon(
                          Icons.comment,
                          color: Colors.amber,
                          size: 20,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          '${SocialCubit.get(context).comment[index]}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[400],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      SocialCubit.get(context).commentPosts(
                          SocialCubit.get(context).postsId[index]);
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              '${SocialCubit.get(context).usermodel!.image}'),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Write a Comment',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    SocialCubit.get(context)
                        .likePosts(SocialCubit.get(context).postsId[index]);
                  },
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.suit_heart,
                        size: 20,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        'Like',
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.ios_share_outlined,
                        size: 20,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        'Share',
                        style: TextStyle(fontSize: 14, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      );
}
