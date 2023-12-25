import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'firebase_options.dart';
import 'layout/social_app/cubit/cubit.dart';
import 'layout/social_app/social_layout.dart';
import 'modules/social_app/social_login/social_login_screen.dart';
import 'shared/components/bloc_observer.dart';
import 'shared/components/components.dart';
import 'shared/components/constants.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  var token = await FirebaseMessaging.instance.getToken();
  print(token);

  FirebaseMessaging.onMessage.listen((event) {
    print('on message');
    print(event.data.toString());
    ShowToast(text: 'on message', state: ToastState.SUCCESS);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message opened app');
    print(event.data.toString());
    ShowToast(text: 'on message opened app', state: ToastState.SUCCESS);
  });

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isdark = CacheHelper.getData(key: 'isdark');
  Widget widget;
  uId = CacheHelper.getData(key: 'uId');

  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }

  runApp(MyApp(
    isdark: isdark,
    startWidget: widget,
  ));
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on background message');
  print(message.data.toString());
  ShowToast(text: 'on message opened app', state: ToastState.SUCCESS);
}

class MyApp extends StatelessWidget {
  final bool? isdark;
  final Widget? startWidget;

  MyApp({this.isdark, this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              AppCubit()..changeAppMode(fromshared: isdark),
        ),
        BlocProvider(
          create: (BuildContext context) => SocialCubit()
            ..getUserData()
            ..getPosts(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              //themeMode: AppCubit.get(context).isdark
              //  ? ThemeMode.dark
              //: ThemeMode.light,
              themeMode: ThemeMode.light,
              home: startWidget);
        },
      ),
    );
  }
}
