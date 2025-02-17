import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/DataApi/DataApiCloudStore.dart';
import '../Authentication/MobileNoScreen/MobileNoScreenView.dart';

class WelcomeScreenView extends StatefulWidget {
  const WelcomeScreenView({Key? key}) : super(key: key);

  @override
  State<WelcomeScreenView> createState() => _WelcomeScreenViewState();
}

class _WelcomeScreenViewState extends State<WelcomeScreenView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DataApiCloudStore.auth;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Spacer(flex: 2),
          Image.asset(
            'Assets/welcome.png',
          ),
          Spacer(flex: 3),
          Text("Welcome to our freedom \n Messaging App",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Spacer(),
          Text(
            "Freedom talk any person of your \n mother language",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.64)),
          ),
          Spacer(flex: 3),
          FittedBox(
            child: TextButton(
                onPressed: () {
                  Get.to(MobileNoScreenView());
                },
                child: Row(
                  children: [
                    Text("SKIP",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.8))),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.8))
                  ],
                )),
          ),
          Spacer(flex: 2),
        ],
      )),
    );
  }
}
