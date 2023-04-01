import 'package:chat_tutorial/Screen/chat_screen.dart';
import 'package:chat_tutorial/providers/getModel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ModelsProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(color: Color.fromRGBO(9, 9, 9, 1)),
            primarySwatch: Colors.blue),
        home: const ChatScreen(),
      ),
    );
  }
}
