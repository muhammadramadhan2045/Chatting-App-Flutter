import 'package:chatting_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String sandi = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "GroupKita",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Login now to see what they are talking!",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Image.asset("assets/images/login.png"),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                      print(email);
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Kata Sandi",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      sandi = value;
                      print(sandi);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
