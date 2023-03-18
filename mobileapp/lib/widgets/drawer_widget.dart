import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

getDrawer(context) {
  final pagesIndex = [0, 1, 2];
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
          const SizedBox(
            height: 150,
          ),
          const Divider(
            height: 3,
            thickness: 1,
            color: Colors.black,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.login),
            title: const Text(
              "Login",
              style: TextStyle(
                fontSize: 25,
              ),
              textAlign: TextAlign.start,
            ),
          )
        ],
      ),
    ),
  );
}
