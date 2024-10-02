import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:wallpaper_genie/controller/gallery.controller.dart';
import 'package:wallpaper_genie/routes/routes.dart';


class Gallery extends StatelessWidget {
   Gallery({super.key});

final controller = Get.isRegistered<GalleryController>()?Get.find<GalleryController>():Get.put(GalleryController());
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return  Scaffold(
      appBar:PreferredSize(preferredSize:const Size.fromHeight(70), child:width<1000?  Obx(()=>controller.enableSearch.value?
      AppBar(
        leading:  IconButton(onPressed: (){
          controller.enableSearch.value=false;
          controller.enableSearch.refresh();
        }, icon:const Icon(Icons.arrow_back_ios,size: 26,)),
       title: TextField(
        controller: controller.searchController,
        autofocus: true,
        decoration:const InputDecoration(
          hintText: "Search images...",
          border: InputBorder.none,
        ),
        onChanged: (val){
          controller.debouncer.call((){
             if(controller.searchController.text.isNotEmpty){
              controller.initialIndex.value=-1;
 controller.keyWord.value=val;
         controller.getImage(initial: true,keyword: controller.keyWord.value);
         controller.searchController.clear();
          controller.enableSearch.value=false;
          controller.enableSearch.refresh();}

          });
         
        },
        onSubmitted: (val){
           if(controller.searchController.text.isNotEmpty){
            controller.initialIndex.value=-1;
          controller.keyWord.value=val;
         controller.getImage(initial: true,keyword: controller.keyWord.value);
         controller.searchController.clear();
          controller.enableSearch.value=false;
          controller.enableSearch.refresh();}
        },
       ), 
       actions: [
          IconButton(onPressed: (){
            if(controller.searchController.text.isNotEmpty){
              controller.initialIndex.value=-1;
         controller.getImage(initial: true,keyword: controller.keyWord.value);
         controller.searchController.clear();
          controller.enableSearch.value=false;
          controller.enableSearch.refresh();
          }
          }, icon:const Icon(Icons.search,size: 26,))
       ],
      ):
       AppBar(
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            controller.enableSearch.value=true;
            controller.enableSearch.refresh();
            
          }, icon:const Icon(Icons.search,size: 26,))
        ],
        title: RichText(text:const TextSpan(
              children: [
                TextSpan(
                  text: "Wallpaper ",
                  style: TextStyle(
                    
                    color: Colors.redAccent,
                    fontSize: 26,
                    fontWeight: FontWeight.w600
                  )
                ),
                TextSpan(
                  text: "Genie",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  )
                ),
              ]
            )),
      )):SizedBox(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: RichText(text:const TextSpan(
                  children: [
                    TextSpan(
                      text: "Wallpaper ",
                      style: TextStyle(
                        
                        color: Colors.redAccent,
                        fontSize: 26,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    TextSpan(
                      text: "Genie",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      )
                    ),
                  ]
                )),
              ),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  
                color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(26)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                          controller: controller.searchController,
                          autofocus: true,
                         
                          decoration:const InputDecoration(
                            hintText: "Search images...",
                            border: InputBorder.none,
                  
                          ),
                          onChanged: (val){
                            controller.debouncer.call((){
                   if(controller.searchController.text.isNotEmpty){
                    controller.initialIndex.value=-1;
                   controller.keyWord.value=val;
                           controller.getImage(initial: true,keyword: controller.keyWord.value);
                           controller.searchController.clear();
                            controller.enableSearch.value=false;
                            controller.enableSearch.refresh();}
                  
                            });
                           
                          },
                          onSubmitted: (val){
                             if(controller.searchController.text.isNotEmpty){
                  controller.initialIndex.value=-1;
                            controller.keyWord.value=val;
                           controller.getImage(initial: true,keyword: controller.keyWord.value);
                           controller.searchController.clear();
                            controller.enableSearch.value=false;
                            controller.enableSearch.refresh();}
                          },
                         ),
                ),
              ), 
            ],
          ),
        ),
      )),
      body: Container(
        color: Colors.white,
        child: ListView(
          controller: controller.scrollController,
          children: [
         
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 100,
             child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                shrinkWrap: true,
                itemBuilder: (context,index){
                return Column(
                  children: [
                    Expanded(
                      child:Obx(()=> GestureDetector(
                        onTap: (){
                          controller.initialIndex.value=index;
                          controller.keyWord.value= controller.categories[index];
                          controller.getImage(initial: true,keyword: controller.keyWord.value);
                        },
                        child: Container(
                          margin:const EdgeInsets.symmetric(
                            horizontal: 8.0
                          ),
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:controller.initialIndex.value==index? Colors.redAccent:Colors.transparent,width: 2.0
                            ),
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                            image: DecorationImage(image:AssetImage('assets/${controller.categories[index]}.jpg'),fit: BoxFit.cover),
                            
                          ),
                          
                        ),
                      )),
                    ),
                     Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(controller.categories[index],style:const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),),
                      ),
                    ),
                  ],
                );
              })
            ),
          ),
         Obx(()=> controller.loader.value?MasonryGridView.count(
            itemCount: 20,
            shrinkWrap: true,
            physics:const NeverScrollableScrollPhysics(),
            crossAxisCount: width<700? 2:width<1000?3:6, itemBuilder: (context,index){
            double ht = index%2==0?200:100;
            return Padding(padding: const EdgeInsets.all(10),
            child: InstaImageViewer(child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: ht,
                color: Colors.grey.shade300,
               ),
             
            )),);
          }):
         controller.hits.isNotEmpty? MasonryGridView.count(
            itemCount: controller.hits.length,
            shrinkWrap: true,
            physics:const NeverScrollableScrollPhysics(),
            crossAxisCount: width<700? 2:width<1000?3:6, itemBuilder: (context,index){
            double ht = index%2==0?200:100;
            return Padding(padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: (){
                  Get.toNamed(Routes.IMAGEDETAILS,parameters: {
                    "index":index.toString()
                  });
                },
                child: Container(
                  height: ht,
                  color: Colors.grey.shade300,
                  child: Image.network(controller.hits[index][GetPlatform.isWeb?"webformatURL":'largeImageURL'],height:ht,fit: BoxFit.cover,)),
              ),
             
            ),);
          }):Padding(
            padding: const EdgeInsets.all(12.0),
            child:Container(
              height: 300,
              width: 300,
              child: Image.asset("assets/no-data.png"))
          ))
        ],),
      )
    );
  }
}