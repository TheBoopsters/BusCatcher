import 'package:bus_catcher/models/route_model.dart';
import 'package:bus_catcher/models/stop_model.dart';
import 'package:bus_catcher/providers/api_provider.dart';
import 'package:bus_catcher/providers/bus_provider.dart';
import 'package:bus_catcher/widgets/stopBus_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class InfoBusWidget extends StatefulWidget {
  const InfoBusWidget({Key? key}) : super(key: key);

  @override
  State<InfoBusWidget> createState() => _InfoBusWidgetState();
}

class _InfoBusWidgetState extends State<InfoBusWidget> {
  List<StopModel> route = [
    StopModel(
      id: 0,
      name: "1Busz",
      orderId: 0,
      routeId: 0,
      position: const LatLng(30, 45),
    ),
    StopModel(
      id: 0,
      name: "1Busz",
      orderId: 0,
      routeId: 0,
      position: const LatLng(30, 45),
    ),
    StopModel(
      id: 0,
      name: "1Busz",
      orderId: 0,
      routeId: 0,
      position: const LatLng(30, 45),
    ),
    StopModel(
      id: 0,
      name: "1Busz",
      orderId: 0,
      routeId: 0,
      position: const LatLng(30, 45),
    ),
    StopModel(
      id: 0,
      name: "1Busz",
      orderId: 0,
      routeId: 0,
      position: const LatLng(30, 45),
    ),
    StopModel(
      id: 0,
      name: "1Busz",
      orderId: 0,
      routeId: 0,
      position: const LatLng(30, 45),
    ),
  ];

  getRouteId() {
    return context.read<BusProvider>().getRouteId();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              context.read<BusProvider>().unselectBus();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 25,
            ),
          ),
          FutureBuilder(
              future: context.read<APIProvider>().getRoute(getRouteId()),
              builder: (context, AsyncSnapshot<RouteModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Container();
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3.5, vertical: 8),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.listStop.length,
                  itemBuilder: (context, index) {
                    return StopBusWidget(
                        stopModel: snapshot.data!.listStop[index]);
                  },
                );
              }),
        ],
      ),
    );
  }
}
