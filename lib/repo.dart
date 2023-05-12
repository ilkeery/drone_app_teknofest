import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Kaybolan şahısı A'B'C farklı modelleri ile Stringde tutmaya yarıyor.
//Riverpod yardımıyla..


class Kayip extends ChangeNotifier{
//Resimlerin değişimi
String aranan = 'A';
bool erkekMi = false;
bool bulunduMu = false;
bool status1 = false;
bool status2 = false;

//Arama butonu
bool isProcessing = false;
void change(String X){
  aranan = X;
  print(aranan);
  //Terminalde çalışıp çalışmadığını görebilmek için print ile yazdırıyoruz.
}

@override
  void notifyListeners() {
    // Bunu eklemezsek değişimlerden ref. alanların haberi olmaz.
  }
}
//ref.read(KayipProvider).change('C'); şeklinde provider üzerinden Class'a erişiyoruz.
final KayipProvider = ChangeNotifierProvider((ref) {
  return Kayip();
});

// ignore: non_constant_identifier_names
