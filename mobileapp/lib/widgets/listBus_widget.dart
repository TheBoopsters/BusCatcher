import 'package:bus_catcher/models/bus_model.dart';
import 'package:bus_catcher/providers/api_provider.dart';
import 'package:bus_catcher/providers/bus_provider.dart';
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
        context.read<BusProvider>().setBusList(snapshot.data!);

        return SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Favorites",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 3.5, vertical: 8),
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return ItemBusWidget(
                    busData: snapshot.data![index],
                    border: true,
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Bus Stations",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 3.5, vertical: 8),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ItemBusWidget(
                    busData: snapshot.data![index],
                    border: true,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
