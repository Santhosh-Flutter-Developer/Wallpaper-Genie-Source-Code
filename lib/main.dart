import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wallpaper_genie/screens/gallery.dart';
import 'package:wallpaper_genie/routes/route_pages.dart';
import 'package:wallpaper_genie/routes/routes.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized(); 
   SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Wallpaper Genie",
       scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
       getPages: RoutePages.routes,
        enableLog: true,
         initialRoute:  Routes.GALLERY,
        debugShowCheckedModeBanner: false,
      home:  Gallery(),
    );
  }
}


class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
