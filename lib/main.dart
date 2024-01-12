import 'package:flutter/material.dart';
import 'package:git_hub_mobile_app/pages/home/home.page.dart';
import 'package:git_hub_mobile_app/pages/users/users.page.dart';

void main(){
  runApp(const MyApp());
  
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.deepOrange)
      ),
      routes:{
        "/":(context)=> HomePage(),
        "/users":(context)=> UsersPage(),
      },
      initialRoute: "/users",
    );
  }
}




  
  
