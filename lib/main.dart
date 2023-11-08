import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Future<void> _loginWithGoogle() async {
    final GoogleSignIn _googleSignIn =
    //GoogleService-info 파일 참고
    GoogleSignIn(clientId:"");
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      print('Google 로그인 취소 또는 오류');
    } else {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;

      if (accessToken != null) {
        final dio = Dio();
        final response = await dio.post(
            'http://ec2-15-164-7-100.ap-northeast-2.compute.amazonaws.com:8080/users/login?access_token=$accessToken');

        if (response.statusCode == 200) {
          print(response.headers['authorization']);
        }
      }
    }
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Google OAuth Login'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: _loginWithGoogle,
            child: Text('Google 로그인'),
          ),
        ),
      );
    }
  }
