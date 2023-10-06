// ignore_for_file: file_names, use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpServer;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_travel/Colors/Colors.dart';
import 'package:flutter_travel/SignUp/Language.dart';
import 'package:flutter_travel/Widgets/Move.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

const html = """
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Grant Access to Flutter</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    html, body { margin: 0; padding: 0; }

    main {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Helvetica,Arial,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol;
    }

    #icon {
      font-size: 96pt;
    }

    #text {
      padding: 2em;
      max-width: 260px;
      text-align: center;
    }

    #button a {
      display: inline-block;
      padding: 6px 12px;
      color: white;
      border: 1px solid rgba(27,31,35,.2);
      border-radius: 3px;
      background-image: linear-gradient(-180deg, #34d058 0%, #22863a 90%);
      text-decoration: none;
      font-size: 14px;
      font-weight: 600;
    }

    #button a:active {
      background-color: #279f43;
      background-image: none;
    }
  </style>
</head>
<body>
  <main>
    <div id="icon">&#x1F3C7;</div>
    <div id="text">Press the button below to sign in using your Localtest.me account.</div>
    <div id="button"><a href="foobar://success?code=1337">Sign in</a></div>
  </main>
</body>
</html>
""";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // String _status = '';

  // @override
  // void initState() {
  //   super.initState();
  //   startServer();
  // }

  // get() async {
  //   final response = await http.get(Uri.parse(
  //       'http://ec2-15-164-7-100.ap-northeast-2.compute.amazonaws.com:8080'));

  //   if (response.statusCode == 200) {
  //     return print(jsonDecode("${response.headers}"));
  //   } else {
  //     throw Exception('에러');
  //   }
  // }

  // Future<void> startServer() async {
  //   final server = await HttpServer.bind(
  //       'http://ec2-15-164-7-100.ap-northeast-2.compute.amazonaws.com:8080',
  //       60);

  //   server.listen((req) async {
  //     setState(() {
  //       _status = 'request';
  //     });

  //     req.response.headers.add('Content-Type', 'text/html');
  //     req.response.write(html);
  //     req.response.close();
  //   });
  // }

  // void authenticate() async {
  //   const url =
  //       'http://ec2-15-164-7-100.ap-northeast-2.compute.amazonaws.com:8080/';
  //   const callbackUrlScheme = 'redirectUri';

  //   try {
  //     final result = await FlutterWebAuth.authenticate(
  //         url: url, callbackUrlScheme: callbackUrlScheme);
  //     setState(() {
  //       _status = '성공: $result';
  //     });
  //   } on PlatformException catch (e) {
  //     setState(() {
  //       _status = '에러: $e';
  //     });
  //   }
  // }

// gettoken()async{
//   final result = await FlutterWebAuth.authenticate(
//     url:
//         "",
//     callbackUrlScheme: "",
//   );

//   final token = Uri.parse(result);
//   String at = token.fragment;
//   at = "서버주소/login/oauth2/code/google$at";
//   var accesstoken = Uri.parse(at).queryParameters['access_token'];
//   print('token');
//   print(accesstoken);
// }
  
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
                      move(const Language(), context);
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

  final Uri _url = Uri.parse(
      'http://ec2-15-164-7-100.ap-northeast-2.compute.amazonaws.com:8080/oauth2/authorization/google');

  // ignore: unused_element
  Future<void> _launchUrl2() async {
    var response = await http.get(_url);

    if (!await launchUrl(_url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $_url');
    }
    print('응답코드 : ${response.statusCode}');

    if (response.statusCode == 200) {
      print('응답코드 : ok');
    } else if (response.statusCode == 404) {
      print('응답코드 : not');
    } else if (response.statusCode == 500) {
      print('응답코드 : no');
    }
  }

// final googleClientId = '';
// final callbackUrlScheme = '';

// final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
//   'response_type': 'code',
//   'client_id': googleClientId,
//   'redirect_uri': '$callbackUrlScheme:/',
// });

// final result = await FlutterWebAuth.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlScheme);

// final code = Uri.parse(result).queryParameters['code'];

// // Use this code to get an access token
// final response = await http.post('', body: {
//   'client_id': googleClientId,
//   'redirect_uri': '$callbackUrlScheme:/',
//   'grant_type': 'authorization_code',
//   'code': code,
// });

// final accessToken = jsonDecode(response.body)['access_token'] as String;
}
