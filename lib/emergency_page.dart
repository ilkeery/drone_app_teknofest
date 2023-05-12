import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_storage.dart';
import 'package:http/http.dart' as http;

enum tshirt { kirmizi, mavi, yesil }

//Riverpod ile veri alışverişi için ConsumerStateful..
enum cinsiyet { erkek, kadin }

class emergency_page extends ConsumerStatefulWidget {
  const emergency_page({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<emergency_page> createState() => _emergency_pageState();
}

class _emergency_pageState extends ConsumerState<emergency_page> {
  tshirt? _renk = tshirt.kirmizi;
  String imgE_mavi = 'assets/E_mavi.jpg';
  String imgK_mavi = 'assets/K_mavi.jpg';
  String imgE_mor = 'assets/E_mor.jpg';
  String imgK_mor = 'assets/K_mor.jpg';
  String imgE_yesil = 'assets/E_yesil.jpg';
  String imgK_yesil = 'assets/K_yesil.jpg';
  String img = 'assets/E_yesil.jpg';
  cinsiyet? _cinsiyet = cinsiyet.erkek;
  bool bulundu = false;
  bool yardim = false;
  //Butona basılı mı kontrol..
  //bool isProcessing = false;
  // Sayfa yenilendiğinde de aynı kalması için repo'ya alıyoruz.

  //ConsumerStateful olduğundan buildera ayrıca Widget ref vermiyoruz.
  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("arananlar").snapshots(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            bulundu = snapshot.data!.docs.first.get("bulundu");
            yardim = snapshot.data!.docs.first.get("yardim");
            GeoPoint bulundu_loc = snapshot.data!.docs.first.get("bulundu_loc");
            ref.read(KayipProvider).bulunduMu = bulundu;
          }
          getDataFromThingSpeak();
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          child: bulundu
                              ? //ilk yardıma ulaştı mı?
                              ilkYardim(yardim)
                              : //show progress on loading = true
                              const Text("")
                          // const Text(
                          //     "Kayıp Arama;",
                          //     style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //     ),), //show this text on loading = false
                          ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),
                Container(
                    child: bulundu
                        ? //ilk yardıma ulaştı mı?
                        FutureBuilder(
                            future: storage.downloadURL('/images/aa.png'),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                return Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Image.network(
                                        snapshot.data!,
                                        height: 350,
                                        width: 300,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  !snapshot.hasData) {
                                return CircularProgressIndicator();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.none) {
                                return Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Image.asset(
                                        img,
                                        height: 350,
                                        width: 300,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return CircularProgressIndicator();
                            },
                          )
                        : //show progress on loading = true
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Image.asset(
                                  img,
                                  height: 350,
                                  width: 300,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ],
                          )
                    // const Text(
                    //     "Kayıp Arama;",
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //     ),), //show this text on loading = false
                    ),

                //Buradaki kod çok daha optime yazılabilir.
                //FuturBuilder bulunan şahsın resmini indirmece..
                const SizedBox(
                  height: 5,
                ),

                Container(
                  child: bulundu
                  ?
                  Text('')
                  : 
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text('Cinsiyet:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ))
                      ],
                    ),
                  )
                ),
                Container(
                  child: bulundu
                  ?
                   Text('')
                   :
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RadioListTile<cinsiyet>(
                          contentPadding: const EdgeInsets.only(left: 5),
                          //cP Yazılar aşağıya kayıyor bozuluyordu.
                          title: const Text(
                            "ERKEK",
                            style: TextStyle(fontSize: 12),
                          ),
                          value: cinsiyet.erkek,
                          groupValue: _cinsiyet,
                          onChanged: (cinsiyet? value) {
                            setState(() {
                              _cinsiyet = value;
                              if (ref.read(KayipProvider).aranan == "A") {
                                img = imgE_yesil;
                              } else if (ref.read(KayipProvider).aranan == "B") {
                                img = imgE_mavi;
                              } else {
                                img = imgE_mor;
                              }
                              ref.read(KayipProvider).erkekMi = true;
                              //Repoya erişip değiştiriyoruz.
                            });
                          },
                        ),
                      ),
                      Container(
                        child:bulundu
                        ?
                        Text('')
                        :
                         Expanded(
                          child: RadioListTile<cinsiyet>(
                            contentPadding: const EdgeInsets.all(0),
                            //cP Yazılar aşağıya kayıyor bozuluyordu.
                            title: const Text(
                              "KADIN",
                              style: TextStyle(fontSize: 12),
                            ),
                            value: cinsiyet.kadin,
                            groupValue: _cinsiyet,
                            onChanged: (cinsiyet? value) {
                              setState(() {
                                _cinsiyet = value;
                                if (ref.read(KayipProvider).aranan == "A") {
                                  img = imgK_yesil;
                                } else if (ref.read(KayipProvider).aranan == "B") {
                                  img = imgK_mavi;
                                } else {
                                  img = imgK_mor;
                                }
                                //Repoya erişip değiştiriyoruz.
                                ref.read(KayipProvider).erkekMi = false;
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child:bulundu
                  ?
                  Text('')
                  :
                   Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text('Giyilen tişört-şort renkleri:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                  child: bulundu 
                  ?
                  Text('')
                  :
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<tshirt>(
                          contentPadding: const EdgeInsets.all(0),
                          //cP Yazılar aşağıya kayıyor bozuluyordu.
                          title: const Text(
                            "YEŞİL-KIRMIZI",
                            style: TextStyle(fontSize: 12),
                          ),
                          value: tshirt.kirmizi,
                          groupValue: _renk,
                          onChanged: (tshirt? value) {
                            setState(() {
                              _renk = value;
                              if (ref.read(KayipProvider).erkekMi) {
                                img = imgE_yesil;
                              } else {
                                img = imgK_yesil;
                              }
                              //Repoya erişip değiştiriyoruz.
                              ref.read(KayipProvider).change('A');
                            });
                          },
                        ),
                      ),
                      Container(
                        child: bulundu 
                        ?
                        Text('')
                        :
                        Expanded(
                          child: RadioListTile<tshirt>(
                            contentPadding: const EdgeInsets.all(0),
                            //cP Yazılar aşağıya kayıyor bozuluyordu.
                            title: const Text(
                              "MAVİ-PEMBE",
                              style: TextStyle(fontSize: 12),
                            ),
                            value: tshirt.mavi,
                            groupValue: _renk,
                            onChanged: (tshirt? value) {
                              setState(() {
                                _renk = value;
                                if (ref.read(KayipProvider).erkekMi) {
                                  img = imgE_mavi;
                                } else {
                                  img = imgK_mavi;
                                }
                                //Repoya erişip değiştiriyoruz.
                                ref.read(KayipProvider).change('B');
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        child: bulundu
                        ?
                        Text('')
                        :
                        Expanded(
                          child: RadioListTile<tshirt>(
                            contentPadding: const EdgeInsets.all(0),
                            //cP Yazılar aşağıya kayıyor bozuluyordu.
                            title: const Text(
                              "MOR-SARI",
                              style: TextStyle(fontSize: 12),
                            ),
                            value: tshirt.yesil,
                            groupValue: _renk,
                            onChanged: (tshirt? value) {
                              setState(() {
                                _renk = value;
                                if (ref.read(KayipProvider).erkekMi) {
                                  img = imgE_mor;
                                } else {
                                  img = imgK_mor;
                                }
                                //Repoya erişip değiştiriyoruz.
                                ref.read(KayipProvider).change('C');
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //https://www.flutterbeads.com/button-with-icon-and-text-flutter/ çok iyi
                // İlerde bakarak daha güzel tasarlanabilir.
                // onPressed: null yazılarak buton deaktif edilebilir.
                //onPressed: () {} veya return Func ile aktif edilebilir.
                //Kullanıcının defalarca basmasını istemeyiz,1 kez basması gerekiyor.
                //PhysichalModel ile daha havalı elevatedbutton ilerde olabilir.

                Container(
                  child: bulundu ?
                  Text('')
                  :
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton.icon(
                      //isProcessing butona basıldıysa basılmasın diye null..
                      //ilerde isStarted diyip true gelince Ekrana kayıp araması başlatılmıştır.
                      //Ayrıca resim yerine de arama başlatılmıştır resmi olabilir.
                      //Sayfa değiştiğinde buton basılabilir olmasın diye repo'dan veriyi alıyoruz.
                      onPressed: ref.read(KayipProvider).isProcessing
                          ? null
                          : () async {
                              const snackBar = SnackBar(
                                content: Text('ARAMA BAŞLATILDI!'),
                              );
                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              String aranan = ref.read(KayipProvider).aranan;
                              await FirebaseFirestore.instance
                                  .collection('arananlar')
                                  .doc('aranan')
                                  .update({'renk': aranan});
                              setState(() {
                                ref.read(KayipProvider).isProcessing = true;
                              });
                            },
                      icon: const Icon(
                        // <-- Icon
                        Icons.search,
                        size: 24.0,
                      ),
                      label: const Text('ARAMAYI BAŞLAT!'), // <-- Text
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class imageGetir extends StatelessWidget {
  const imageGetir({
    Key? key,
    required this.img,
  }) : super(key: key);

  final String img;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Image.network(
                  snapshot.data!,
                  height: 350,
                  width: 300,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Image.asset(
                  img,
                  height: 350,
                  width: 300,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}

//ilk yardıma ulaştı mı kontrol..
ilkYardim(yardim) {
  if (yardim) {
    return const Expanded(
      child: Text(
        "Kayıp Şahıs ilk yardıma ulaşmıştır\nBulunduğu konum haritada işaretlenmiştir.",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
    );
  } else {
    return const Expanded(
      child: Text(
        "Kayıp Şahıs Bulundu.\nBulunduğu konum haritada işaretlenmiştir.",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
    );
  }
}

void getDataFromThingSpeak() async {
  final response = await http.get(Uri.parse(
      'https://api.thingspeak.com/channels/2071328/feeds.json?api_key=SLNZ31MTM1TM2QUG&results=2'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final field1 = data['feeds'][0]['field1'];
    print('Field 1: $field1');
  } else {
    print('Failed to get data from ThingSpeak');
  }
}
