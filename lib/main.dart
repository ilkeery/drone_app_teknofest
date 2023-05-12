import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'emergency_page.dart';
import 'home_page.dart';
import 'map_page.dart';
import 'splash_screen.dart';
void main() {
  runApp(const ProviderScope(
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firna Space',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 232, 230, 232),
        primarySwatch: Colors.blueGrey,
      ),
      home: const SplashScreen(),
    );
  }
}
//const MyHomePage(title: 'Tay Tulpar Ana Sayfa')
class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int currentIndex = 1;
  final screens = [
    const emergency_page(),
    const home_page(),
    map_page(),
  ];

  @override
                          
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIRNA SPACE'),
        centerTitle: true,
      ),
      //IndexedStack ile tüm sayfaları arkaplanda yüklü tutuyoruz.
      //Bu sayede veri kaybolmuyor fakat program kasabilir.
      //normalde body:screens[currentIndex],      
      // body: IndexedStack(index: currentIndex,children: scrrens),
      //Tüm sayfalar aynı anda çalışır arada değiştiriyorum denerken
      body:screens[currentIndex],
      //Böyle olduğunda her sayfa değişiminde veriler kayboluyor.
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 117, 151, 168),
        iconSize: 25,
        selectedFontSize: 20,
        unselectedFontSize: 16,
        selectedItemColor: Colors.black38,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex=index),
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          // ignore: prefer_const_constructors
          BottomNavigationBarItem(
           icon: const Icon(Icons.accessibility),
           label: 'Kayıp\nArama',
             ),
          // ignore: prefer_const_constructors
          BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'Ana Sayfa',
          backgroundColor: Colors.green,
            ),
          // ignore: prefer_const_constructors
          BottomNavigationBarItem(
          icon: const Icon(Icons.map),
          label: 'Harita',
          backgroundColor: Colors.pink,
            ),  
        ],
      ),
      
    );
    
  }
}


