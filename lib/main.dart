import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/user_provider.dart';

import './screens/login_signup.dart';
import './screens/signup_screen.dart';
import './screens/login_screen.dart';
import './screens/home_screen.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build running...');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Travel App}',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.deepPurple,
            colorScheme: const ColorScheme.light(secondary: Colors.amberAccent),
          ),
          home: auth.isAuth
              ? MyHomePage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapShot) =>
                      snapShot.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : AuthScreen(),
                ),
          routes: {
            SignUpScreen.routeName: (ctx) => const SignUpScreen(),
            LoginScreen.routeName: (ctx) => const LoginScreen(),
            MyHomePage.routeName: (ctx) => MyHomePage(),
          },
        ),
      ),
    );
  }
}
