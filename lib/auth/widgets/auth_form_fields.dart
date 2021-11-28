import 'package:flutter/material.dart';
import 'package:upcharika/auth/service/auth_service.dart';
import 'package:upcharika/main.dart';

class AuthFormFields extends StatefulWidget {
  const AuthFormFields({Key key}) : super(key: key);

  @override
  _AuthFormFieldsState createState() => _AuthFormFieldsState();
}

enum AuthType { Login, Signup, Reset }

class _AuthFormFieldsState extends State<AuthFormFields> {
  final _formKey = GlobalKey<FormState>();
  AuthType authType = AuthType.Signup;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getStringAuthType(authType),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                alignLabelWithHint: true,
                labelStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              validator: (value) {
                if (value.isEmpty) return "Please enter a password";
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                alignLabelWithHint: true,
                labelStyle:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              validator: (value) {
                if (value.isEmpty) return "Please enter a password";
                return null;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(
                      MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height * 0.06)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    try {
                      if (authType == AuthType.Login) {
                        await authService.login(
                            _emailController.text, _passwordController.text);
                      } else if (authType == AuthType.Signup) {
                        await authService.signUpWithEmailAndPassword(
                            _emailController.text, _passwordController.text);
                      } else {}

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => BottomNavbar()),
                          (route) => route.isFirst);
                    } catch (e) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          e.message,
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.amberAccent,
                        duration: Duration(seconds: 60),
                        action: SnackBarAction(
                          onPressed: () => ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar(),
                          label: "Dismiss",
                        ),
                      ));
                    }
                  }
                },
                child: Text(
                  getStringAuthType(authType).replaceAll('-', ""),
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(authType == AuthType.Signup
                    ? "Already have an account? "
                    : "Create an account. "),
                TextButton(
                    onPressed: () {
                      setState(() {
                        authType = authType == AuthType.Login
                            ? AuthType.Signup
                            : AuthType.Login;
                      });
                    },
                    child: Text(
                        authType == AuthType.Signup ? "Log-in" : "Sign-up")),
              ],
            )
          ],
        ),
      ),
    );
  }

  String getStringAuthType(AuthType type) {
    return authType == AuthType.Login
        ? "Log-in"
        : authType == AuthType.Signup
            ? "Sign-up"
            : "Reset";
  }
}
