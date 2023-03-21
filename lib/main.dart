import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:pet_charity/common/global.dart';

import 'package:pet_charity/states/color_schemes.g.dart';
import 'package:pet_charity/states/theme.dart';
import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((value) => runApp(const MyApp()));
  Application.router = FluroRouter();
  Routes.configureRoutes(Application.router);
  if (Platform.isAndroid) {
    // 透明状态栏
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1290, 2796),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            // ListenableProvider<UserModel>(create: (_) => UserModel()),
            ChangeNotifierProvider<UserModel>(create: (_) => UserModel()),
            ChangeNotifierProvider<ThemeModel>(create: (_) => ThemeModel()),
          ],
          child: Consumer<ThemeModel>(builder: (c, ThemeModel themeModel, _) {
            return MaterialApp(
              localizationsDelegates: const [
                // 本地化的代理类
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('zh', 'CN'), // 中文简体
                Locale('en', 'US'), // 美国英语
              ],
              builder: BotToastInit(),
              // 1.调用BotToastInit
              navigatorObservers: [BotToastNavigatorObserver()],
              debugShowCheckedModeBanner: false,
              themeMode: themeModel.theme,
              theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
              darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
              home: child,
              // onGenerateRoute: Application.router.generator,
            );
          }),
        );
      },
      child: const MainPage(),
    );
  }
}
