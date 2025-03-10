import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/utils/app_size.dart';
import 'package:flutter_getx_project_template/widgets/texts/app_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
        child: AppText(
          height: 1.8,
          data:
              """At car a rental we prioritize your privacy and data security. We collect and use your personal information only to enhance your experience, process bookings, and improve our services. Your data is protected with industry-standard security measures and is never shared with third parties without your consent. By using our app, you agree to our privacy practices. For more details on data collection, usage, and protection, please review our full Privacy Policy. Your trust and security are our top priorities.
      
       """,
        ),
      ),
    );
  }
}
