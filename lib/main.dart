import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesture_coordination_task/configs/enum/font_options.dart';
import 'package:gesture_coordination_task/providers/auth_provider.dart';
import 'package:gesture_coordination_task/providers/products_provider.dart';
import 'package:gesture_coordination_task/view/login/login_view.dart';
import 'package:provider/provider.dart';

import 'configs/theme/app_theme_data.dart';

void main(){
 runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [

      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ProductsProvider()),
    ],child: MaterialApp(
      theme: AppThemeData.lightThemeData(FontOptions.noToSerif),
      home: LoginView(),

    ),);
  }
}
