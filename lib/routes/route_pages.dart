
import 'package:get/get.dart';
import 'package:wallpaper_genie/screens/gallery.dart';
import 'package:wallpaper_genie/routes/routes.dart';
import 'package:wallpaper_genie/screens/imagedetails.dart';

class RoutePages {
  static final routes =[
    GetPage(
      title: "Gallery",
      name: Routes.GALLERY, page: ()=> Gallery()),
      GetPage(
      title: "Image Details",
      name: Routes.IMAGEDETAILS, page: ()=> ImageDetails())  
  ];
}