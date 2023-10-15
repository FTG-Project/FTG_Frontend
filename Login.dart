import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  
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
                         loginWithGoogleAndToken(); 
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

  Future<void> loginWithGoogleAndToken() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn(scopes: ['email']).signIn();
      if (googleSignInAccount != null) {
        
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final String? accessToken = googleSignInAuthentication.accessToken;
        final email = googleSignInAccount.email;

        final response = await http.post(
          Uri.parse(
              'http://ec2-15-164-7-100.ap-northeast-2.compute.amazonaws.com:8080/oauth2/authorization/google'),
          headers: {
            'Authorization': '$accessToken',
          },
          body: jsonEncode({'access_token': accessToken, 'email': email}),
        );
        if (response.statusCode == 200) {
          final responseBody = response.body;
          print('요청 성공: $responseBody');
        } else {
          print('응답코드: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('구글 로그인 에러: $error');
    }
  }




