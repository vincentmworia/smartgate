import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../screens/home_screen.dart';
import 'input_field.dart';
import '../models/logged_in_user.dart';

class AuthScreenForm extends StatefulWidget {
  const AuthScreenForm({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  State<AuthScreenForm> createState() => _AuthScreenFormState();
}

class _AuthScreenFormState extends State<AuthScreenForm> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late FocusNode _usernameFocusNode;
  late FocusNode _passwordFocusNode;

  late LoggedInUser _loggedInUser;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _loggedInUser = LoggedInUser();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            if (widget.height > 250)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    InputField(
                      key: const ValueKey('username'),
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Username',
                      icon: Icons.account_box,
                      obscureText: false,
                      focusNode: _usernameFocusNode,
                      autoCorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_passwordFocusNode),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the username';
                        }
                        if (value != "admin") {
                          return 'invalid username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _loggedInUser.username = value!;
                      },
                    ),
                    InputField(
                      key: const ValueKey('password'),
                      controller: _passwordController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Password',
                      icon: Icons.account_box,
                      obscureText: true,
                      focusNode: _passwordFocusNode,
                      autoCorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(null),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the password';
                        }
                        if (value != "admin") {
                          return 'invalid password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _loggedInUser.password = value!;
                      },
                    ),
                    const Spacer(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize:
                                Size(widget.width * 0.15, widget.height * 0.1),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.all(10),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState == null ||
                              !(_formKey.currentState!.validate())) {
                            return;
                          }
                          _formKey.currentState!.save();
                          if (kDebugMode) {
                            print(_loggedInUser.asMap());
                          }
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (_) => HomeScreen()));
                          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: MyApp.applicationSecondaryColor,
                              letterSpacing: 2.0),
                        )),
                    const Spacer(),
                  ],
                ),
              ),
          ],
        ));
  }
}
