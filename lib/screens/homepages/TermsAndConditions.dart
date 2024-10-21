import 'package:flutter/material.dart';
import 'package:Shubhvite/global/appcolors.dart';

class Termsandconditions extends StatelessWidget {
  const Termsandconditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms And Conditions",
          style: TextStyle(color: Color.fromRGBO(251, 252, 253, 0.965)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Appcolors.primary,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Terms and Conditions for Digital Invitation App",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "1. Introduction",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome to our digital invitation app ('the App'). By accessing or using the App, you agree to be bound by these Terms and Conditions ('Terms'). Please read them carefully before using the App. If you do not agree to these Terms, you must discontinue using the App.\n"
                  "These Terms apply to all users, including but not limited to visitors, registered users, and any person who accesses or uses the App.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "2. Eligibility",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "By using the App, you confirm that you are:\n"
                  "At least 16 years old if you are located in the United Kingdom.\n"
                  "At least 18 years old if you are located in India.\n"
                  "If you are under the legal age, you must obtain the consent of your parent or guardian before using the App.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "3. User Account Registration",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "To use certain features of the App, you may be required to create an account. When registering, you agree to provide accurate and complete information, including your:\n"
                  "Full name\n"
                  "Email address\n"
                  "Phone number\n"
                  "You are responsible for safeguarding your account login credentials and for any activity performed through your account. If you suspect any unauthorized use of your account, you must notify us immediately.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "4. Use of the App",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "You agree to use the App only for lawful purposes and in accordance with these Terms. By using the App, you agree:\n"
                  "Not to upload content that is illegal, offensive, defamatory, or violates the rights of others.\n"
                  "Not to use the App in any way that violates local, national, or international laws.\n"
                  "Not to use the App to spam, harass, or engage in any harmful activities toward others.\n"
                  "Not to misuse or tamper with the App's features, security mechanisms, or related services.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "5. User-Generated Content",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "You may upload personal content, including names, photos, and event details, to create digital invitations. By doing so, you represent and warrant that:\n"
                  "You own the rights to the content or have obtained proper permission to use it.\n"
                  "The content does not infringe on the intellectual property rights, privacy, or any other rights of third parties.\n"
                  "You grant us a limited, non-exclusive, and royalty-free license to use, modify, display, and distribute the content solely for the purposes of providing our services.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "6. Intellectual Property",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "All intellectual property rights related to the App, including software, design, trademarks, and other materials, belong to us or our licensors. You may not copy, modify, distribute, or create derivative works based on any content provided through the App without our express permission.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "7. Paid Services",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Some features of the App may be offered as paid services (e.g., premium invitation designs, ad-free usage, additional storage). If you choose to use these features, you agree to pay the applicable fees and charges, which will be clearly communicated to you before payment.\n"
                  "Fees are non-refundable unless stated otherwise by law.\n"
                  "Payment processing may be handled by third-party service providers, and by making a purchase, you agree to their terms of service as well.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "8. Limitation of Liability",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "To the extent permitted by law, we are not liable for any damages, whether direct, indirect, incidental, or consequential, arising from:\n"
                  "Your use of or inability to use the App.\n"
                  "Any errors or inaccuracies in the App.\n"
                  "Unauthorized access to your personal data.\n"
                  "Any content posted by users, including invitations or comments.\n"
                  "In jurisdictions that do not allow certain limitations of liability, our liability is limited to the extent permitted by law.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "9. Data Protection and Privacy",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "We take the privacy of your personal data seriously. By using the App, you consent to the collection, storage, and use of your data in accordance with our Privacy Policy.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "10. Termination",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "We reserve the right to suspend or terminate your access to the App without notice if:\n"
                  "You breach these Terms.\n"
                  "We are required to do so by law.\n"
                  "We discontinue the App's services.\n"
                  "Upon termination, you must cease using the App and delete any copies of the App in your possession.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "11. Modifications to the App and Terms",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "We may update or modify these Terms or the App at any time. Significant changes will be communicated through in-app notifications or via email. Continued use of the App following any modifications signifies your acceptance of the revised Terms.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "12. Governing Law",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "For users in the United Kingdom: These Terms and your use of the App shall be governed by and construed in accordance with the laws of England and Wales. You agree to submit to the exclusive jurisdiction of the courts in England for the resolution of any disputes arising from these Terms.\n"
                  "For users in India: These Terms and your use of the App shall be governed by and construed in accordance with the laws of India. You agree to submit to the exclusive jurisdiction of the courts in [your preferred city/state] for the resolution of any disputes arising from these Terms.\n",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "13. Indemnification",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "You agree to indemnify, defend, and hold us harmless from any claims, liabilities, damages, losses, and expenses (including legal fees) arising from your use of the App, violation of these Terms, or any third-party claims related to content you upload.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "14. Third-Party Links",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "The App may contain links to third-party websites or services. We are not responsible for the content, accuracy, or availability of these external sites. Accessing these links is at your own risk, and we recommend reviewing their terms and privacy policies.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "15. Contact Information",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "If you have any questions about these Terms or the App, please contact us at:\n"
                  "Email: [Support Email]\n"
                  "Phone: [Support Phone Number]\n"
                  "Key Considerations:\n"
                  "User Obligations: Ensure users understand their responsibility for accurate content, lawful use, and safeguarding login details.\n"
                  "Intellectual Property: Clearly state ownership of app materials and prohibit unauthorized use.\n"
                  "Liability Limitations: Protect your app from legal liabilities related to user-generated content or third-party services.\n"
                  "Paid Services: Define payment terms for any premium features or in-app purchases.\n"
                  "Data Privacy: Reference your privacy policy to ensure transparency around data handling.\n"
                  "These Terms and Conditions, along with the privacy policy, offer comprehensive protection for both your business and users, ensuring legal compliance in the UK and India.\n",
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          )),
    );
  }
}
