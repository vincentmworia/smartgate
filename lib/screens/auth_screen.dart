import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/auth_screen_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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
                top: height * .15,
                // height: height * 0.15,
                child: Container(
                  width: width * .15,
                  height: height * .15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyApp.applicationSecondaryColor,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Center(
                    child: Text(
                      'LOGO',
                      style: TextStyle(
                        color: MyApp.applicationPrimaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                )),
            Container(
              width: width * 0.35,
              height: height * 0.5,
              decoration: BoxDecoration(
                color: MyApp.applicationSecondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AuthScreenForm(width: width),
            ),
          ],
        );
      }),
    ));
  }
}
