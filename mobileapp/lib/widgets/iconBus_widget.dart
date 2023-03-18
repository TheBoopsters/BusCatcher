import 'package:flutter/material.dart';

class IconBusWidget extends StatefulWidget {
  final String number;
  const IconBusWidget({Key? key, required this.number}) : super(key: key);

  @override
  State<IconBusWidget> createState() => _IconBusWidgetState();
}

class _IconBusWidgetState extends State<IconBusWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2)),
      height: MediaQuery.of(context).size.height / 15,
      width: MediaQuery.of(context).size.width / 6,
      child: SizedBox(
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/iconBus_widget.png'),
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            Text(
              widget.number,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
