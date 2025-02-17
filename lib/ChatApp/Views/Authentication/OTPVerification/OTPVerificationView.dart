import 'dart:developer';
import 'package:d_chat/ChatApp/Controller/DataApi/DataApiCloudStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../../../Controller/Authentication/AuthenticationRepository.dart';
import '../../../Controller/Authentication/MobileNoVerificationController.dart';
import '../../../Utils/TextStyleConstant.dart';
import '../../NamePhotoAddScreen/NamePhotoAddScreen.dart';

class OTPVerificationView extends StatefulWidget {
  const OTPVerificationView({
    Key? key,
  }) : super(key: key);

  @override
  State<OTPVerificationView> createState() => _OTPVerificationViewState();
}

class _OTPVerificationViewState extends State<OTPVerificationView> {
  String verificationCode = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // selfInfo();
    verificationCode = '';
  }

  selfInfo() async {
    DataApiCloudStore.GetSelfInfo();
    DataApiCloudStore.getSelfInfo();
  }

  final mobileNoVerificationController =
      Get.put(MobileNoVerificationController());
  final verificationController = Get.put(AuthenticationRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  width: Get.width,
                  color: Colors.indigo,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height / 10),
                      CircleAvatar(
                        child: Image.asset(
                          'Assets/otp.png',
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        radius: Get.height / 15,
                      ),
                      SizedBox(
                        height: Get.height / 30,
                      ),
                      Text("Verify Your Mobile Number!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                          )),
                      SizedBox(
                        height: Get.height / 10,
                      ),
                    ],
                  ),
                ),
              )),
          Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height / 30,
                      ),
                      Text("We have send an OTP on your mobile Number "),
                      SizedBox(
                        height: Get.height / 100,
                      ),
                      SizedBox(
                        height: Get.height / 30,
                      ),
                      OtpTextField(
                        numberOfFields: 6,
                        fieldWidth: 50,
                        margin: EdgeInsets.only(right: 12),
                        borderColor: const Color(0xFF512DA8),
                        showFieldAsBox: true,
                        onCodeChanged: (String code) {
                          verificationCode = code;
                        },
                        onSubmit: (String code) {
                          verificationCode = code;
                          log(verificationCode);
                          // moveToHome(context);
                        }, // end onSubmit
                      ),
                      SizedBox(
                        height: Get.height / 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          DataApiCloudStore.verifyOTP1(
                                  verificationCode, context)
                              .then((value) async => {
                                    if (value)
                                      {
                                        if (await DataApiCloudStore
                                            .userExists())
                                          {
                                            DataApiCloudStore
                                                .getFirebaseMessagingToken(),
                                            Get.to(NamePhotoAddScreen()),
                                          }
                                        else
                                          {
                                            await DataApiCloudStore.createUser()
                                                .then((value) {
                                              DataApiCloudStore
                                                  .getFirebaseMessagingToken();

                                              Get.to(NamePhotoAddScreen());
                                            })
                                          }
                                      }
                                    else
                                      {}
                                  });
                        },
                        child: Container(
                            width: Get.width / 3,
                            height: Get.height / 18,
                            decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text("VERIFY",
                                    style: TextStyleConstant.ButtonColor))),
                      ),
                      SizedBox(
                        height: Get.height / 10,
                      ),
                      TextButton(
                          onPressed: () async {
                            await DataApiCloudStore.phoneAuthnetication(
                                    '+91${mobileNoVerificationController.phoneNumber.text.trim()}')
                                .then((value) => {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                contentPadding: EdgeInsets.zero,
                                                backgroundColor: Colors.white
                                                    .withOpacity(.9),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Center(
                                                        child: Text(
                                                            "Otp Resend Successfully....!!!"),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        right: 8,
                                                        top: 6,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text("Okay"),
                                                        ))
                                                  ],
                                                ),
                                              ))
                                    });

                            //  Get.to(ChatMainScreenView());
                          },
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
