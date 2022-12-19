// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, missing_return

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/select_role.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'Travel App',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1?.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = false;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var isSignUp = false;
  final passwordController = TextEditingController();

  Map<String, String> _authDataSignUp = {
    'userName': '',
    'email': '',
    'cnic': '',
    'age': '',
    'role': 'Passenger',
    'password': '',
  };
  String? _selectAge;
  AuthMode _authMode = AuthMode.Login;

  // AnimationController? _animationController;
  // Animation<Size>? _heightAnimation;
  // Animation<double>? _opacityAnimation;

  @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 400),
  //   );
  //   _heightAnimation = Tween<Size>(
  //       begin: const Size(double.infinity, 260),
  //       end: const Size(double.infinity, 320))
  //       .animate(CurvedAnimation(
  //       parent: _animationController!, curve: Curves.linear));
  //   // _heightAnimation.addListener(() => setState(() {}));
  //   _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
  //       CurvedAnimation(parent: _animationController!, curve: Curves.easeIn));
  // }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submitSignUp() async {
    final auth = Provider.of<Auth>(context, listen: false);
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      isSignUp = true;
    });
    try {
      await auth
          .signup(_authDataSignUp['email']!, _authDataSignUp['password']!)
          .then((_) async {
        await auth.addUserData(_authDataSignUp);
      });
    } catch (error) {
      _showErrorDialog(error.toString());
    }
    setState(() {
      isSignUp = false;
    });
  }

  void _pickedAge() {
    showDatePicker(
      context: context,
      initialDate: DateTime(1960),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    ).then((age) {
      if (age == null) {
        return;
      }
      setState(() {
        _selectAge = DateFormat.yMd().format(age);
        _authDataSignUp['age'] = _selectAge!;
      });
    });
  }

  Future<void> _submitLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLogin = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .login(_authData['email']!, _authData['password']!);
    } catch (error) {
      _showErrorDialog(error.toString());
    }
    setState(() {
      isLogin = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      // _animationController!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      // _animationController!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _authMode == AuthMode.Login
                  ? _loginFormFunction(context)
                  : _signUpFormFunction(),
              Container(
                height: 30,
                child: Center(
                  child: TextButton(
                    onPressed: _switchAuthMode,
                    child: const Text('Login/Signup'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Form _signUpFormFunction() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value == '') {
                return 'Please enter your name,';
              }
              return null;
            },
            decoration: const InputDecoration(
              label: Text('Username'),
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              setState(() {
                _authDataSignUp['userName'] = value!;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value!.endsWith('.com') && value.contains('@')) {
                return null;
              }
              return 'Enter valid email.';
            },
            decoration: const InputDecoration(
              label: Text('Email'),
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              setState(() {
                _authDataSignUp['email'] = value!;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value!.length != 15 || !value.contains('-')) {
                return 'Please enter correct CNIC eg 17302-7654398-9';
              }
              return null;
            },
            decoration: const InputDecoration(
              label: Text('CNIC'),
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              setState(() {
                _authDataSignUp['cnic'] = value!;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            height: 55,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  _authDataSignUp['age'] == null
                      ? 'No age chosen yet'
                      : 'Age: ${_authDataSignUp["age"]}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _pickedAge,
                  child: const Text('Select age'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SelectRole(_authDataSignUp['role']!),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.length < 7 || value.isEmpty) {
                return 'Please enter correct password';
              }
              return null;
            },
            decoration: const InputDecoration(
              label: Text('New Password'),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              if (value != passwordController.text) {
                return 'Password does not match.';
              } else if (value!.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
            decoration: const InputDecoration(
              label: Text('Confirm Password'),
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              setState(() {
                _authDataSignUp['password'] = value!;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          isSignUp == false
              ? ElevatedButton(
                  onPressed: _submitSignUp,
                  child: const Text('submit'),
                )
              : const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Form _loginFormFunction(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Email'),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (Provider.of<Auth>(context, listen: false)
                  .isValidEmail(value!)) {
                return null;
              } else {
                return 'Enter valid email.';
              }
            },
            onSaved: (value) {
              setState(() {
                _authData['email'] = value!;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Password'),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.length >= 7 && value.isNotEmpty) {
                return null;
              } else {
                return 'Enter valid email.';
              }
            },
            onSaved: (value) {
              setState(() {
                _authData['password'] = value!;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          isLogin == false
              ? ElevatedButton(
                  onPressed: _submitLogin,
                  child: const Text('Login'),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    );
  }
}
