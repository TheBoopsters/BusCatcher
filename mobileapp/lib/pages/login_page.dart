import 'package:bus_catcher/providers/api_provider.dart';
import 'package:bus_catcher/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userName = "";
  String password = "";
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(55.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sign In",
                          style: TextStyle(fontSize: 45),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          decoration: textFormDecoration.copyWith(
                            labelText: "Username:",
                            prefix: const Icon(Icons.person),
                          ),
                          onSaved: (newValue) {
                            setState(() {
                              userName = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username can't be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: textFormDecoration.copyWith(
                            labelText: "Password:",
                            prefix: const Icon(Icons.password),
                          ),
                          onSaved: (newValue) {
                            setState(() {
                              password = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password can't be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Material(
                          child: MaterialButton(
                            onPressed: () {
                              loginFunction();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22)),
                            color: Theme.of(context).primaryColor,
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  loginFunction() async {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      setState(() {
        _isLoading = true;
      });
      form.save();
      await context.read<APIProvider>().login(userName, password).then((value) {
        ToastContext().init(context);
        if (value == true) {
          Toast.show("You successfully logged in",
              gravity: Toast.bottom, duration: 4);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          setState(() {
            _isLoading = false;
          });
          Toast.show(
            "Wrong username or password!",
            gravity: Toast.bottom,
            duration: 4,
          );
        }
      });
    }
  }
}
