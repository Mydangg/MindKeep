import 'package:flutter/material.dart';
import 'package:frontend/core/themes/theme.dart';
import 'package:frontend/routing/routes.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await authController.isLoginIn();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authController),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: lightMode,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
