import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/auth_screen_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routeName = '/Authentication';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var loading = false;

  void alterLoadingStatus(bool status) {
    setState(() {
      loading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: width,
              height: height,
              child: Image.asset(
                'images/gate3.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: width,
              height: height,
              color: MyApp.applicationPrimaryColor.withOpacity(0.85),
            ),
            Positioned(
                top: height * .1,
                // height: height * 0.15,
                child: Container(
                  width: width * .15,
                  height: height * .15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyApp.applicationSecondaryColor,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'ELIMU',
                      style: TextStyle(
                        color: MyApp.applicationPrimaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                      ),
                    ),
                  ),
                )),
            Container(
              width: width < 800 ? width : width * .4,
              height: width < 800 ? height : height * 0.65,
              decoration: BoxDecoration(
                color: MyApp.applicationSecondaryColor
                    .withOpacity(width < 800 ? 0 : 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AuthScreenForm(
                width: width,
                height: height,
                alterLoading: alterLoadingStatus,
              ),
            ),
            if (loading)
              Container(
                width: width,
                height: height,
                color: MyApp.applicationSecondaryColor.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        );
      }),
    ));
  }
}
