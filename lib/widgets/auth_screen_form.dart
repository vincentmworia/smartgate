import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../main.dart';
import '../private_data.dart';
import '../providers/mqtt.dart';
import '../screens/home_screen.dart';
import 'input_field.dart';
import '../models/logged_in_user.dart';

class AuthScreenForm extends StatefulWidget {
  const AuthScreenForm(
      {super.key,
      required this.width,
      required this.height,
      required this.alterLoading});

  final double width;
  final double height;
  final Function alterLoading;

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

  static String _getErrorMessage(String errorTitle) {
    var message = 'Operation failed';

    if (errorTitle.contains('EMAIL_EXISTS')) {
      message = 'Email is already in use';
    }
    if (errorTitle.contains('CREDENTIAL_TOO_OLD_LOGIN_AGAIN')) {
      message = 'Select a new email';
    } else if (errorTitle.contains('INVALID_EMAIL')) {
      message = 'This is not a valid email address';
    } else if (errorTitle.contains('NOT_ALLOWED')) {
      message = 'User needs to be allowed by the admin';
    } else if (errorTitle.contains('TOO_MANY_ATTEMPTS_TRY_LATER:')) {
      message =
          'We have blocked all requests from this device due to unusual activity. Try again later.';
    } else if (errorTitle.contains('EMAIL_NOT_FOUND')) {
      message = 'Could not find a user with that email.';
    } else if (errorTitle.contains('timeout period has expired')) {
      message = 'Password must be at least 6 characters';
    } else if (errorTitle.contains('WEAK_PASSWORD')) {
      message = 'Password must be at least 6 characters';
    } else if (errorTitle.contains('INVALID_PASSWORD')) {
      message = 'Invalid password';
    } else {
      message = message;
    }
    return message;
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
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the username';
                        }
                        // if (value != "admin") {
                        //   return 'invalid username';
                        // }
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
                        // if (value != "admin") {
                        //   return 'invalid password';
                        // }
                        return null;
                      },
                      onSaved: (value) {
                        _loggedInUser.password = value!;
                      },
                    ),
                    const Spacer(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                                widget.width < 800
                                    ? widget.width * 0.35
                                    : widget.width * 0.15,
                                widget.height * 0.1),
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
                          // todo start animation for loading
                          widget.alterLoading(true);
                          try {
                            final response = await http.post(
                                Uri.parse(
                                    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$firebaseApiKey"),
                                body: json.encode({
                                  "email": _loggedInUser.username!,
                                  "password": _loggedInUser.password!,
                                  "returnSecureToken": true,
                                }));
                            final responseData = json.decode(response.body)
                                as Map<String, dynamic>;
                            if (responseData['error'] != null) {
                              widget.alterLoading(false);
                              print(_getErrorMessage(
                                  responseData['error']['message']));
                              // todo throw a popup and stop authentication
                            } else {
                              print('Here');
                              await Future.delayed(Duration.zero)
                                  .then((value) async {
                                await Provider.of<MqttProvider>(context,
                                        listen: false)
                                    .initializeMqttClient(_loggedInUser)
                                    .then((value) async =>
                                        await Navigator.pushReplacementNamed(
                                            context, HomeScreen.routeName));
                              });
                            }
                          } catch (e) {
                            var message = e.toString();
                            if ((message.contains('identity') ||
                                message.contains(
                                    'Connection closed before full') ||
                                message.contains(
                                    'Connection terminated during handshake'))) {
                              message = 'Please check your internet connection';
                            }
                            if (message == "timeout period has expired") {
                              message = "Please check your internet connection";
                            }
                            widget.alterLoading(false);
                            print(message);
                          }
                        },
                        child: const Icon(
                          Icons.login,
                          color: MyApp.applicationSecondaryColor,
                          size: 30.0,
                        )),
                    const Spacer(),
                  ],
                ),
              ),
          ],
        ));
  }
}
