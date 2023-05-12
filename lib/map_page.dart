import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: camel_case_types
class map_page extends ConsumerStatefulWidget {
  const map_page({super.key});

  @override
  ConsumerState<map_page> createState() => _map_pageState();
}

// ignore: camel_case_types
class _map_pageState extends ConsumerState<map_page>
    with TickerProviderStateMixin {
  //iha markeri
  List<Marker> markers = [];
  late final MapController _mapController;
  List<String> binaAd = [];
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    //SafeAre ve Stream ile verileri alıyoruz içerdeki builder içinde tekrar return Scafold.
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("binalar").snapshots(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            final documentSnapshotList = snapshot.data!.docs;
            final binaSayisi = documentSnapshotList.length;
            String deneme = snapshot.data!.docs[0].get("isim");
            //print(deneme);
            int binaCount = 1;
            //binaAd[0]= "Data bekleniyor";
            if (binaSayisi > 0 && binaSayisi != null && snapshot.data!.docs[0].get("isim") != null) {
              binaCount = binaSayisi;
              print(binaCount);
              for (int i = 0; i < binaSayisi; i++) {
                binaAd[i] = snapshot.data!.docs[i].get("isim");
              }
            }
            for (int i = 0; i < binaSayisi; i++) {
              binaAd[i] = snapshot.data!.docs[1].get("isim");
            }
            //print(binaSayisi);
            //print(snapshot.data!.docs[1].get("isim"));
            //markers.clear();
            LatLng latLng = LatLng(41.015137, 28.979530);
            markers.add(
              Marker(
                width: 30,
                height: 30,
                point: latLng,
                builder: (context) => Column(
                  children: <Widget>[
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue[300]!.withOpacity(0.5)),
                          height: 30.0,
                          width: 30.0,
                        ),
                        const Icon(
                          Icons.flight,
                          size: 20.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
            //Kuyruğu sürekli ekliyoruz.
            // points.add(latLng);
            //Bulundugu yere icon koyma.
            // if (bulundu) {
            //   markers.add(Marker(
            //     width: 30,
            //     height: 30,
            //     point: bulundu_latLng,
            //     builder: (context) => Column(
            //       children: <Widget>[
            //         Stack(
            //           alignment: AlignmentDirectional.center,
            //           children: <Widget>[
            //             Container(
            //               decoration: BoxDecoration(
            //                   shape: BoxShape.rectangle,
            //                   color: Colors.green[300]!.withOpacity(0.8)),
            //               height: 30.0,
            //               width: 30.0,
            //             ),
            //             const Icon(
            //               Icons.local_hospital,
            //               size: 25.0,
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ));
            // }
            //Map burada
            if (0 == 0) {
              return Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      plugins: <MapPlugin>[
                        LocationPlugin(),
                        const LocationMarkerPlugin(),
                        MarkerClusterPlugin(),
                      ],
                      center: latLng,
                      interactiveFlags: InteractiveFlag.pinchZoom |
                          InteractiveFlag.drag |
                          InteractiveFlag.doubleTapZoom,
                      minZoom: 9,
                      maxZoom: 17,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayerOptions(
                        markers: markers,
                        rotate: true,
                      ),
                    ],

                    //Telefonun konumu(bizi gösteren icon)

                    mapController: _mapController,
                  ),
                  Positioned(
                      bottom: 20,
                      right: 0,
                      left: 0,
                      child: Container(
                        height: 150,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: binaCount, //Sunucudan çekilecek
                            itemBuilder: (BuildContext context, int index) =>
                                GestureDetector(
                                  onTap: () {
                                    _mapController.move(latLng, 15);
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    width:
                                        MediaQuery.of(context).size.width / 1.7,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        //Text bilgileri sunucudan gelecek.
                                        children: [
                                          Text("deneme")
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                      )),
                Text(deneme)
                ],
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
