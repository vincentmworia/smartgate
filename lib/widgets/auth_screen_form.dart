import 'package:flutter/material.dart';
import 'package:smartgate/main.dart';

import 'input_field.dart';
import '../models/logged_in_user.dart';

class AuthScreenForm extends StatefulWidget {
  const AuthScreenForm({super.key, required this.width});

  final double width;

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
                return null;
              },
              onSaved: (value) {
                _loggedInUser.username = value!;
              },
            ),
            const Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                        widget.width < 1000 ? widget.width * 0.2 : 200, 50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
                  // store the button state in shared preferences API
                  // todo Submit the form
                },
                child: const Text(
                  "Register",
                  style: TextStyle(
                      color: MyApp.applicationSecondaryColor,
                      letterSpacing: 2.0),
                )),
            const Spacer(),
          ],
        ));
  }
}
