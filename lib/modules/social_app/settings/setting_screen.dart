import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter/layout/social_app/cubit/cubit.dart';
import 'package:social_app_flutter/layout/social_app/cubit/state.dart';
import 'package:social_app_flutter/modules/social_app/edit_profile/edit_profile_screen.dart';
import 'package:social_app_flutter/shared/components/components.dart';

class Settings_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var usermodel = SocialCubit.get(context).usermodel;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 170,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4)),
                          image: DecorationImage(
                            image: NetworkImage('${usermodel!.cover}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      alignment: Alignment.topCenter,
                    ),
                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      radius: 55,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('${usermodel.image}'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '${usermodel.name}',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                '${usermodel.bio}',
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Column(
                        children: [
                          Text(
                            '100',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'posts',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        children: [
                          Text(
                            '265',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'photos',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        children: [
                          Text(
                            '100k',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'followers',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        children: [
                          Text(
                            '459',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'following',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(
                                BorderSide(color: Colors.teal))),
                        onPressed: () {},
                        child: Text(
                          'add photo',
                          style: TextStyle(color: Colors.teal),
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: Colors.teal))),
                    onPressed: () {
                      navigateTo(context, EditProfile());
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
