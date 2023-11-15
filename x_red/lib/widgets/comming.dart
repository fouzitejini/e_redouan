
import 'package:flutter/material.dart';

import 'package:flutter_mail_server/flutter_mail_server.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:responsive_ui/responsive_ui.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../data/colors.dart';
import 'loading.dart';

class CommingSoon extends StatefulWidget {
 const CommingSoon({super.key});

  @override
  State<CommingSoon> createState() => _CommingSoonState();
}

class _CommingSoonState extends State<CommingSoon> {
  final cnt = Get.put(CommingSoonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => cnt.isOnload.value
            ? const Loading()
            : cnt.isError.value
                ? Center(
                    child: Text("Error".tr),
                  )
                : SingleChildScrollView(
                    child: Stack(
                      children: [
                        Container(
                          height: Get.height,
                          width: Get.width,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            BrandColors.kPrimaryColor,
                            BrandColors.googleOrange,
                            BrandColors.lightGoldColor,
                            BrandColors.oldGoldColor,
                            BrandColors.googleRed,
                          ])),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(),
                              SizedBox(
                                width: Get.width,
                                child: Text(
                                  "ترقبونا.. قريبًا",
                                  style:TextStyle(
                                      fontSize: 48,
                                      fontFamily:
                                          GoogleFonts.cairo().fontFamily),
                                
                                ),
                              ),
                              Text(
                                "  ! تابعنا او تواصل معنا للحصول على اخر التحديثات",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: GoogleFonts.cairo().fontFamily),
                                
                              ),
                              Responsive(
                                alignment: WrapAlignment.spaceAround,
                                children: [
                                  Div(
                                    divison: const Division(
                                        colS: 12, colM: 6, colL: 2),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                          height: 40,
                                          width: 150,
                                          child: ElevatedButton.icon(
                                              onPressed: null,
                                              icon: const Icon(
                                                  FontAwesomeIcons.facebookF),
                                              label: const Text("فايسبوك"))),
                                    ),
                                  ),
                                  Div(
                                    divison: const Division(
                                        colS: 12, colM: 6, colL: 2),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                          height: 40,
                                          width: 150,
                                          child: ElevatedButton.icon(
                                              onPressed: null,
                                              icon: const Icon(
                                                  FontAwesomeIcons.instagram),
                                              label: const Text("انستغرام"))),
                                    ),
                                  ),
                                  Div(
                                    divison: const Division(
                                        colS: 12, colM: 6, colL: 2),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                          height: 40,
                                          width: 150,
                                          child: ElevatedButton.icon(
                                              onPressed: () async {
                                                await  cnt.launchWhatsAppUri();
                                               
                                              },
                                              icon: const Icon(
                                                  FontAwesomeIcons.whatsapp),
                                              label: const Text("واتساب"))),
                                    ),
                                  ),
                                  Div(
                                    divison: const Division(
                                        colS: 12, colM: 6, colL: 2),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                          height: 40,
                                          width: 150,
                                          child: ElevatedButton.icon(
                                              onPressed: () async {
                                               
                                              launchUrl(Uri.parse("tel://0637114665"));
                                              },
                                              icon: const Icon(
                                                  FontAwesomeIcons.mobile),
                                              label: const Text("الهاتف"))),
                                    ),
                                  ),
                                ],
                              ),
                              Container(),
                            ],
                          ),
                        ),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: Image.asset("images/logo.png",
                                height: 80, fit: BoxFit.fitWidth)),
                        Positioned(
                            top: 10,
                            left: 10,
                            child: Image.asset("images/logo.png",
                                height: 80, fit: BoxFit.fitWidth)),
                      ],
                    ),
                  ),
      ),
    );
  }
}

//

class CommingSoonController extends GetxController {
  final isOnload = true.obs;
  final isLoaded = false.obs;
  final isError = false.obs;
  final email = TextEditingController().obs;
  @override
  void onInit() async {
    try {
      isOnload.value = true;
      isLoaded.value = false;
      isError.value = false;
    } catch (e) {
      isOnload.value = false;
      isLoaded.value = false;
      isError.value = true;
      return;
    } finally {
      isOnload.value = false;
      isLoaded.value = true;
      isError.value = false;
    }
    super.onInit();
  }

  sendMail(String recever) {
    try {
      Mailer().sendEmail('Fouzi', 'info@fouzitejini.com', 'emailmessage.text',
          recever, "", "", "");
      Get.showSnackbar(GetSnackBar(title: "Email", message: "Email sended"));
    } catch (e) {
      Get.showSnackbar(GetSnackBar(title: "Email", message: e.toString()));
    }
  }
launchWhatsAppUri() async {
  const link = WhatsAppUnilink(
    phoneNumber: '+212637114665',
    text: "Hey! I'm inquiring about the apartment listing",
  );
  // Convert the WhatsAppUnilink instance to a Uri.
  // The "launch" method is part of "url_launcher".
  await launchUrl(link.asUri());
}
  Future<void> sendEmail() async {
    final smtpServer = gmail('fawzitejini5@gmail.com', 'fawzi5@Gmail');

    final message = Message()
      ..from = const Address('fawzitejini5@gmail.com', 'اسمك')
      ..recipients.add(
          'fouzitejini@gmail.com') // البريد الإلكتروني الذي سيتم إرسال البريد إليه
      ..subject = 'بريد اختبار'
      ..text = 'هذا هو بريد اختبار تم إرساله من تطبيق Flutter web.';

    try {
      final sendReport = await send(message, smtpServer);
      print('تم إرسال الرسالة: ${sendReport.messageSendingEnd}');
    } on MailerException catch (e) {
      print('لم يتم إرسال الرسالة. ${e.toString()}');
    }
  }
}
