import 'package:bus_catcher/pages/login_page.dart';
import 'package:bus_catcher/providers/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

getDrawer(context) {
  return Drawer(
    child: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const Text(
            "Bus Catcher",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35),
          ),
          const Image(
            fit: BoxFit.fitHeight,
            width: 125,
            height: 125,
            image: AssetImage('assets/logo.png'),
          ),
          const Divider(
            height: 3,
            thickness: 1,
            color: Colors.black,
          ),
          Consumer<APIProvider>(
            builder: (context, value, _) {
              return !value.isLoggedIn()
                  ? ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      leading: const Icon(Icons.login),
                      title: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  : ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<APIProvider>().logout();
                        ToastContext().init(context);
                        Toast.show("Sucessfully logged out",
                            gravity: Toast.bottom, duration: 4);
                      },
                      leading: const Icon(Icons.logout),
                      title: const Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    );
            },
          ),
        ],
      ),
    ),
  );
}
