import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const applicationTitle = 'Smart Gate';
  static const applicationPrimaryColor = Color(0xff2F3C7E);
  static const applicationSecondaryColor = Color(0xffFBEAEB);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: applicationTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SafeArea(child: Scaffold(
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
                color: applicationPrimaryColor.withOpacity(0.85),
              ),
              Container(
                width: width * 0.35,
                height: height * 0.5,
                decoration: BoxDecoration(
                  color: applicationSecondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Positioned(
                  top: height * .15,
                  // height: height * 0.15,
                  child: Container(
                    width: width * .15,
                    height: height * .15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: applicationSecondaryColor,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: const Center(
                      child: Text(
                        'LOGO',
                        style: TextStyle(
                          color: applicationPrimaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  )),
            ],
          );
        }),
      )),
    );
  }
}
