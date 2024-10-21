import 'package:flutter/material.dart';
import 'package:Shubhvite/global/appcolors.dart';


class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy', style: TextStyle(color: Color.fromRGBO(251, 252, 253, 0.965)),
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
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // Text(
              //   'Privacy Policy',
              //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              Text(
                "Privacy Policy for Digital Invitation App",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "1. Introduction",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "We are committed to protecting your privacy.This Privacy Policy outlines how we collect, use, store, and protect your personal information when you use our digital invitation app. This policy applies to users in the United Kingdom and India, and it complies with the relevant privacy laws in these jurisdictions, including the UK GDPR and India's DPDPA.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "2. Data Collection",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We collect the following personal information when you use our app:\n"
                "Name\n"
                "Email address\n"
                "Phone number\n"
                "Contacts\n"
                "Pictures uploaded as part of the invitation creation process\n"
                "This data is collected to allow users to create, send, and manage invitations, and to enhance their experience.\n",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "3. Legal Basis for Processing (UK users)",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Under the UK GDPR, we rely on the following legal bases to collect and process your data:\n"
                "Consent: By using our app, you consent to the collection of your personal data.\n"
                "Contractual Necessity: Some data is necessary to fulfill the contract (e.g., to send invitations on your behalf).\n"
                "Legitimate Interest: We may process data to improve our services and app functionality.\n",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "4. Purpose of Data Collection",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We collect personal information for the following purposes:\n"
                "To allow users to create and send digital invitations.\n"
                "To store and organize invitations.\n"
                "To provide customer support and respond to inquiries.\n"
                "To enhance user experience by offering personalized services.\n"
                "To comply with legal obligations.\n",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "5. Data Sharing and Transfers",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We do not sell or share your personal data with third parties unless:\n"
                "It is required by law.\n"
                "We have your explicit consent.\n"
                "It is necessary to provide services (e.g., sending invitations through email service providers).\n"
                "If data is transferred outside the UK or India (to a third country), we will ensure appropriate safeguards (e.g., standard contractual clauses, as required by the UK GDPR and DPDPA).\n",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "6. Data Retention",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We will retain your personal data only for as long as necessary to fulfill the purposes outlined in this policy, or as required by law. After this period, data will be securely deleted.\n"
                "User information will be stored for the duration of your account's activity and up to 2 years after account deactivation unless legal obligations require extended retention.\n",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "7. Data Security",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We implement appropriate technical and organizational measures to protect your data from unauthorized access, alteration, disclosure, or destruction. This includes encrypted storage and regular security audits.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "8. User Rights (UK)",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Under the UK GDPR, users have the following rights:\n"
                "Right to Access: You can request access to your personal data.\n"
                "Right to Rectification: You can request corrections to inaccurate data.\n"
                "Right to Erasure ('Right to be Forgotten'):\n"
                "You can request the deletion of your data under certain circumstances.\n"
                "Right to Data Portability: You can request your data in a structured format.\n"
                "Right to Object: You can object to processing based on legitimate interest.\n"
                "Right to Withdraw Consent: You can withdraw consent at any time.\n"
                "User Rights (India)\n"
                "Under India’s DPDPA, users have the following rights:\n"
                "Right to Access: You can request to know what personal data we hold about you.\n"
                "Right to Correction: You can ask us to correct inaccurate data.\n"
                "Right to Data Erasure: You can request deletion of your personal data.\n"
                "Right to Nominate: You can nominate someone else to exercise your rights in case of incapacity or death.\n",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "9. Cookies and Tracking Technologies",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Our app uses cookies and similar tracking technologies to collect information about your usage and to improve our services. By using our app, you consent to the use of cookies. You can manage cookie preferences through your browser settings.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "10. Third-Party Services",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We may use third-party services, such as email delivery services, to perform certain functions. These third parties will have access to the data only to the extent necessary to perform their functions and are obligated to maintain the confidentiality and security of the data.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "11. Data Breach Notification",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "In the event of a data breach that affects your personal data, we will notify you and relevant authorities (as required by law) within the legally mandated timeframe",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "12. Age Restrictions",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Our app is not intended for use by individuals under the age of 16 in the UK or 18 in India. We do not knowingly collect data from minors.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "13. Changes to This Policy",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We reserve the right to update this privacy policy at any time. Users will be notified of any significant changes through email or in-app notifications.",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "14. Contact Us",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "If you have any questions about this privacy policy or would like to exercise your data protection rights, please contact us at:\n"
                "Email: [Support Email]\n"
                "Phone: [Support Phone Number]\n"
                "For UK residents, if you are unsatisfied with our response, you can lodge a complaint with the Information Commissioner's Office (ICO). For Indian residents, you may file a complaint with the Data Protection Authority of India once it is established.\n"
                "Key Compliance Points for the UK:\n"
                "UK GDPR compliance: Explicit consent, clear user rights, and lawful basis for data collection and processing.\n"
                "Data Transfer Safeguards: Use of standard contractual clauses or other safeguards for transferring data outside the UK.\n"
                "Notification of Breaches: Obligations to notify both users and the ICO in case of data breaches.\n"
                "Key Compliance Points for India:\n"
                "DPDPA Compliance: Handling of personal data according to the Digital Personal Data Protection Act.\n"
                "User Rights: Recognition of user rights like data erasure, correction, and access.\n"
                "Data Localization Consideration: India might enforce restrictions on the storage of sensitive personal data abroad in the future.\n",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
