import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notification_app/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationService service = NotificationService();

  @override
  void initState() {
    super.initState();
    service.init(context);

    service.getDeviceToken().then((value) {
      if (kDebugMode) {
        print("device token");
        print(value);
      }
    });
  }

  void sendNotification() {
    service.getDeviceToken().then(
      (value) async {
        var data = {
          'to': value.toString(),
          'notification': {
            'title': 'This is title',
            'body': 'This is body',
          },
          'data': {
            'type': 'message',
            'id': 0,
            'test': ['a', 'b'],
          }
        };
        await Dio()
            .post(
          'https://fcm.googleapis.com/fcm/send',
          data: jsonEncode(data),
          options: Options(
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization':
                  'key=AAAADiRDcIo:APA91bGcgI_F8ou4YHR1fadIlfYdTyNVkRckYtEuAinzj75WBIiihO410fFGgEyuXPH34T4pNXpLD_oKdUykTtK07_RAEbHDJpmU1SogtbZRXTw5Pn8Hxh-YBSXdAYKvQN6nSvUk8NLk',
            },
          ),
        )
            .then((value) {
          if (kDebugMode) {
            print(value.data.toString());
          }
        }).onError((error, stackTrace) {
          if (kDebugMode) {
            print(error);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Notification"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          sendNotification();
        },
        child: const Text("Send Notification!"),
      ),
    );
  }
}
