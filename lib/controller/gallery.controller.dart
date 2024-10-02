
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:http/http.dart' as http;
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'dart:io';
// import 'dart:html' as html;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_genie/routes/routes.dart';  // Only for Android and iOS


class GalleryController extends GetxController {

 final List<String> categories = [
   'Anime',
    'Architecture',
    'Cars',
   
    'Travel',
    'Animal',
    'Food',
    'Sports', 
    'Nature',
  ];

  RxBool enableSearch=false.obs,loader=false.obs,skiploader=false.obs;
  RxList hits =[].obs;
  RxString keyWord="".obs;
   var imagesDate;
  RxInt currentPage=1.obs,size=20.obs,totalPages=1.obs,initialIndex=0.obs;
  TextEditingController searchController = TextEditingController();
   ScrollController scrollController= ScrollController();
  var debouncer = Debouncer(delay:const Duration(seconds: 1));
  var parameters={};

@override
  void onInit() {
    super.onInit();
    parameters = Get.parameters;
 
    keyWord.value=categories[initialIndex.value];
    getImage(initial: true,keyword: keyWord.value);
    scrollController =
         ScrollController(initialScrollOffset: 0.0)
          ..addListener(onScroll);
          
  }


onScroll() async {
    if(scrollController.offset >=
              scrollController.positions.last.maxScrollExtent &&
          !scrollController.positions.last.outOfRange){
       if(currentPage.value<=totalPages.value) {
      currentPage.value=currentPage.value+1;
      currentPage.refresh();
         skiploader.value=true;
       await  getImage(initial: false,keyword: keyWord.value);
         skiploader.value=false;
       }
       }
  }


Future<void> downloadImage(String url, String fileName) async {
  // Get the image from the network
  http.Response response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Uint8List imageBytes = response.bodyBytes;

    // Handle for Web
    if (GetPlatform.isWeb) {
      // final blob = html.Blob([imageBytes]);
      // final url = html.Url.createObjectUrlFromBlob(blob);
      // final anchor = html.AnchorElement(href: url)
      //   ..setAttribute("download", fileName)
      //   ..click();
      // html.Url.revokeObjectUrl(url);
    } else {
      // Handle for Android and iOS
      Directory appDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDir.path}/$fileName';

      File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      print('Image downloaded and saved at $filePath');
    }
  } else {
    throw Exception('Failed to download image');
  }
}



  getImage({bool? initial=false,String? keyword=""})async{
    try{
      if(initial==true){
        loader.value=true;
        loader.refresh();
        hits.clear();
        currentPage.value=1;
        size.value=20;
        totalPages.value=1;
      }
      String url = "https://pixabay.com/api/?"
        "key=16582589-68a2e0e5d7a78080a8fa51cbe"
        "&q=$keyword"
        "&page=$currentPage"
        "&per_page=$size";
await http.get(Uri.parse(url)).then((onResp) {
       
        // hits=json.decode(onResp.body);
        this.imagesDate=json.decode(onResp.body);
        hits.addAll(imagesDate['hits']);
        if(imagesDate['totalHits']%size.value==0){
          totalPages.value=imagesDate['totalHits']~/size.value;
          }
        else {
          totalPages.value=1+int.parse((imagesDate['totalHits']/size.value).floor().toString());
        }
   
     });

    }catch(e){
      print(e);
    }
    loader(false);
    loader.refresh();
  }


Widget imageUI({double? height}){
  return Stack(
                children: [
                  InstaImageViewer(
                    imageUrl: hits[int.parse(parameters["index"]!=null?parameters["index"].toString():"0")][GetPlatform.isWeb?"webformatURL":'largeImageURL']??"",
                    child: Container(
                      height:height,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        image: DecorationImage(image: NetworkImage(hits[int.parse(parameters["index"]!=null?parameters["index"].toString():"0")][GetPlatform.isWeb?"webformatURL":'largeImageURL']??""),fit: BoxFit.cover)
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.6)
                        ),
                        child:const Center(
                          child: Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 16,),
                          ),
                        )),
                    ),
                  )
                ],
              );
}


 Widget imageDetailsUI({List? tagsList}){
return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: ListTile(
  
    leading: CircleAvatar(
      radius: 24,
      backgroundImage: NetworkImage(hits[int.parse(parameters["index"]!=null?parameters["index"].toString():"0")]['userImageURL']??""),
    ),
    title: Text(hits[int.parse(parameters["index"]!=null?parameters["index"].toString():"0")]['user']??"",maxLines: 1,
    style:const TextStyle(
      fontWeight: FontWeight.w800,
      color: Colors.black
    ),
    ),
    // trailing: IconButton(onPressed: (){
    //   controller.downloadImage(controller.hits[int.parse(controller.parameters["index"]!=null?controller.parameters["index"].toString():"0")]['largeImageURL']??"", "wallpaper-genie${DateTime.now()}.jpg");
    // }, icon:const Icon(Icons.cloud_download,size: 30,),),
  ),
),

Padding(
  padding: const EdgeInsets.symmetric(vertical: 10.0),
  child: Row(
    children: [
      Expanded(
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.indigo.withOpacity(0.3),
              child:const Icon(Icons.remove_red_eye,color: Colors.indigo,),
            ),
           const SizedBox(
              height: 10,
            ),
            Text(hits[int.parse(parameters["index"]!=null?parameters["index"].toString():"0")]['views']!=null?hits[int.parse(parameters["index"]!=null?parameters["index"].toString():"0")]['views'].toString():"0",
            style:const TextStyle(
              fontSize: 12,
            ),
            ),
           const Text("Views",
           style: TextStyle(
             fontSize: 12,
             fontWeight: FontWeight.w800
           ),
           )
          ],
        ),
      ),
      Expanded(
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.amber.withOpacity(0.3),
              child:const Icon(Icons.thumb_up,color: Colors.amber,),
            ),
           const SizedBox(
              height: 10,
            ),
            Text(hits[int.parse(parameters["index"]!=null?parameters["index"].toString():"0")]['likes']!=null?hits[int.parse(parameters["index"]!=null?parameters["index"].toString():"0")]['likes'].toString():"0",
            style:const TextStyle(
              fontSize: 12,
            ),
            ),
           const Text("Likes",
           style: TextStyle(
             fontSize: 12,
             fontWeight: FontWeight.w800
           ),
           )
          ],
        ),
      ),
      Expanded(
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.green.withOpacity(0.3),
              child:const Icon(Icons.comment,color: Colors.green),
            ),
           const SizedBox(
              height: 10,
            ),
            Text(hits[int.parse(parameters["index"]!=null?parameters["index"].toString():"0")]['comments']!=null?hits[int.parse(parameters["index"]!=null?parameters["index"].toString():"0")]['comments'].toString():"0",
            style:const TextStyle(
              fontSize: 12,
            ),
            ),
           const Text("Comments",
           style: TextStyle(
             fontSize: 12,
             fontWeight: FontWeight.w800
           ),
           )
          ],
        ),
      ),
      
    ],
  ),
),
const Padding(
  padding:  EdgeInsets.all(10.0),
  child: Text("Tags:",style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),),
),
Padding(
  padding: const EdgeInsets.symmetric(horizontal:10.0),
  child: Wrap(
    children: 
  List.generate(tagsList!.length,(index) {
   return Padding(
     padding: const EdgeInsets.only(right:8.0),
     child: Chip(label: Text(tagsList[index]),
     backgroundColor: Colors.grey.shade300,
     side:const BorderSide(
      style: BorderStyle.none
     ),
     
     shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(26)
     ),),
   ); 
  })),
),

  ],
);
 
  }

}