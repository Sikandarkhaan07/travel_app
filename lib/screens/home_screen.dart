import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    print('build running in homepage');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            print('logging out');
            Provider.of<Auth>(context,listen: false ).logout();
          },
          child:const Text('logout'),
        ),
      ),
    );
  }
}
