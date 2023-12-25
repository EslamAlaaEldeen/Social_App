import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_flutter/layout/social_app/cubit/cubit.dart';
import 'package:social_app_flutter/layout/social_app/cubit/state.dart';
import 'package:social_app_flutter/modules/social_app/post_screen/post_screen.dart';
import 'package:social_app_flutter/shared/components/components.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text(
              cubit.title[cubit.currentIndex],
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  color: Colors.white,
                  onPressed: () {},
                  icon: Icon(Icons.notifications_outlined)),
              IconButton(
                  color: Colors.white,
                  onPressed: () {},
                  icon: Icon(Icons.search_outlined))
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.teal,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.upload_file_outlined),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
