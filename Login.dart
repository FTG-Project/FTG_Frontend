import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  bool isLoggedIn = false;
  String jwtToken = '';
  String email = '';
  
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: backgroundcolor().grey,
        ),
        backgroundColor: backgroundcolor().grey,
        body: Center(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                width: mq.width / 1.0,
                height: mq.height / 1.8,
                child:
                    Image.asset('assets/logo/logo.png', fit: BoxFit.fitWidth)),
            SizedBox(
                width: mq.width / 1.2,
                child: TextButton(
                    onPressed: () {
                         getJwtToken(); 
                    },
                    style: TextButton.styleFrom(
                        elevation: 1.0,
                        backgroundColor: const Color(0xffffffff)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: SizedBox(
                                  width: 18.0,
                                  height: 18.0,
                                  child: Image.asset(
                                    'assets/logo/Google__G__Logo.svg.png',
                                  ))),
                          Text("Sign in With  Google",
                              style: TextStyle(color: Colors.grey[600])),
                        ]))),
            Padding(
                padding: EdgeInsets.only(top: mq.height / 7.0),
                child: Text("consent",
                        style: TextStyle(
                            color: primaryColor().black,
                            fontWeight: FontWeight.w600))
                    .tr()),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton(
                  onPressed: () {},
                  child: Text("Terms of Use",
                          style: TextStyle(color: primaryColor().black))
                      .tr()),
              TextButton(
                  onPressed: () {},
                  child: Text("privacy policy",
                          style: TextStyle(color: primaryColor().black))
                      .tr()),
            ]),
          ]),
        )));
  }

  Future<void> signIn(String jwt) async {
    try {
      await googleSignIn.signIn();
      final user = googleSignIn.currentUser;
      // final token = await googleSignIn.currentUser!.authentication;
      if (user != null) {
        setState(() {
          isLoggedIn = true;
          jwtToken = jwt;
          email = user.email;
        });
        sendToken(jwtToken, email);
      }
    } catch (error) {
      print('Google 로그인 실패: $error');
    }
  }

    Future<void> sendToken(String idToken, String email) async {
    try {
      final serverUrl = Uri.parse(
          'http://ec2-15-164-7-100.ap-northeast-2.compute.amazonaws.com:8080/oauth2/authorization/google');
      final response = await http.post(serverUrl, headers: {
        'Authorization': 'Bearer $idToken',
      });

      if (response.statusCode == 200) {
        print('서버 응답: ${response.body}');
      } else {
        print('서버 응답 실패: ${response.statusCode}');
      }
    } catch (error) {
      print('서버 요청 실패: $error');
    }
  }

  
Future<String?> getJwtToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      IdTokenResult tokenResult = await user.getIdTokenResult();

      signIn(tokenResult.token.toString());
    }
    return null;
  }


}




