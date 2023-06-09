import 'package:bus_catcher/models/route_model.dart';
import 'package:bus_catcher/providers/api_provider.dart';
import 'package:bus_catcher/providers/bus_provider.dart';
import 'package:bus_catcher/providers/location_provider.dart';
import 'package:bus_catcher/providers/map_provider.dart';
import 'package:bus_catcher/widgets/itemBus_widget.dart';
import 'package:bus_catcher/widgets/stopBus_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoBusWidget extends StatefulWidget {
  const InfoBusWidget({Key? key}) : super(key: key);

  @override
  State<InfoBusWidget> createState() => _InfoBusWidgetState();
}

class _InfoBusWidgetState extends State<InfoBusWidget> {
  getRouteId() {
    return context.read<BusProvider>().getRouteId();
  }

  getBusId() {
    return context.read<BusProvider>().getBusId();
  }

  @override
  Widget build(BuildContext context) {
    context.read<MapProvider>().sendLocation(
        context.read<LocationProvider>().getLiveLocation(),
        getBusId(),
        context.read<APIProvider>().getAccessToken());
    context.read<MapProvider>().getMarkers(getBusId(), getRouteId());
    context.read<MapProvider>().setBusId(getBusId());
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  context.read<BusProvider>().unselectBus();
                  context.read<MapProvider>().clearMarkers();
                  context.read<MapProvider>().clearBusId();
                  context.read<MapProvider>().closeLiveLocation();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 25,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.25,
                child: Column(
                  children: [
                    ItemBusWidget(
                      busData: context.read<BusProvider>().getBus()!,
                      border: false,
                    ),
                    FutureBuilder(
                      future: context
                          .read<MapProvider>()
                          .calculateDistanceFromBus(getBusId()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return Text(
                          "${snapshot.data}",
                          style: const TextStyle(),
                          textAlign: TextAlign.center,
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
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
