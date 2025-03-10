import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/utils/app_size.dart';
import 'package:flutter_getx_project_template/widgets/texts/app_text.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
        child: AppText(
          height: 1.8,
          data:
              """Welcome to car a rental mobile application, your go-to car rental solution! We provide a hassle-free experience with a wide range of well-maintained vehicles at affordable rates. Whether it's a road Reserve, business travel, or daily commute, our seamless booking process, secure payments, and dedicated support ensure a smooth journey. With flexible rental options and reliable service, we make renting a car quick, easy, and stress-free. Drive with confidence—wherever you go, we’re here to get you there!
      
       """,
        ),
      ),
    );
  }
}
