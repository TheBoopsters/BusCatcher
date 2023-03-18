import 'package:bus_catcher/models/bus_model.dart';
import 'package:bus_catcher/providers/api_provider.dart';
import 'package:bus_catcher/widgets/itemBus_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListBusWidget extends StatefulWidget {
  const ListBusWidget({Key? key}) : super(key: key);

  @override
  State<ListBusWidget> createState() => _ListBusWidgetState();
}

class _ListBusWidgetState extends State<ListBusWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<APIProvider>().getBusList(),
      builder: (context, AsyncSnapshot<List<BusModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 8),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return ItemBusWidget(busData: snapshot.data![index]);
          },
        );
      },
    );
  }
}
