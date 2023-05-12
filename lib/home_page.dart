import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter/material.dart';

//Ana Sayfamız
class home_page extends StatelessWidget {
  const home_page({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        // Container(
        //   height: 300,
        //   child: ModelViewer(
        //             src: 'assets/iha.glb',
        //             alt: "iha",
        //             ar: true,
        //             autoRotate: true,
        //             cameraControls: true
        //           ),
        // ),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('FIRNA SPACE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ))
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Expanded(
                  child: Text('''· Full Otonom Uçuş         
                    \n · Yer Sistemlerine Bağımlı Olmaksızın \n Tam Otamatik İniş ve Kalkış Özelliği
                    \n · Tam Otomotik Seyir ve Rota Takip Özelliği
                    \n · Tam Otomatik Görüntü İşleme \n   ve Hedef Tespiti
                    \n · 72km/sa seyir hızı
                    ''',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
