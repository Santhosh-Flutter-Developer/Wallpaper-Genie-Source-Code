import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpaper_genie/controller/gallery.controller.dart';


class ImageDetails extends StatelessWidget {
   ImageDetails({super.key});

final controller = Get.isRegistered<GalleryController>()?Get.find<GalleryController>():Get.put(GalleryController());

  @override
  Widget build(BuildContext context) {
       controller.parameters = Get.parameters;
       String tags =  controller.hits[int.parse(controller.parameters["index"]!=null?controller.parameters["index"].toString():"0")]['tags']??"";
       
  
  // Convert string to list
  List tagsList = tags.split(',').map((tag) => tag.trim()).toList();
  double width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      child: Scaffold(
        body:Obx(()=>controller.loader.value?const CircularProgressIndicator() :width<1000? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.imageUI(height:300),
              controller.imageDetailsUI(tagsList: tagsList),

           ],
          ),
        ):Row(
          children: [
            Expanded(
              
              child: controller.imageUI(height:MediaQuery.of(context).size.height)),
            SizedBox(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: controller.imageDetailsUI(tagsList: tagsList),
              ))
          ],
        ),
      )),
    );
  }
}

