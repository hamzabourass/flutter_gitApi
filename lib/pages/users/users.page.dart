import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:git_hub_mobile_app/pages/repositories/gitRepoPage.page.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatefulWidget {

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
   String query = "";
   bool notVisible = false;
   dynamic data=null;
   int currenPage = 0;
   int totalPages = 0;
   int pageSize = 20;
   ScrollController scrollController = new ScrollController();
   List<dynamic> items = [];

   void _search(String query) {
     String url = "https://api.github.com/search/users?q=${query}&per_page=${pageSize}&page=${currenPage}";
     print(url);

     http.get(Uri.parse(url)).then((response) {
       setState(() {
         data=json.decode(response.body);
         items.addAll(data['items']);
         if(data['total_count']%pageSize==0){
           totalPages= data['total_count']~/pageSize;
         }
         else  totalPages= (data['total_count']/pageSize).floor() + 1;

       });
     }).catchError((err) {
       print(err);
     });
   }

   TextEditingController queryTextEditingController = new TextEditingController();
   
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if(scrollController.position.pixels==scrollController.position.maxScrollExtent){
        setState(() {
          if(currenPage<totalPages-1){
            ++currenPage;
            _search(query);
          }

        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Users Page  : ${query} $currenPage/$totalPages')),
      body:  Center(
       child: Column(
         children: [
           Row(
             children: [
               Expanded(
                 child: Container(
                     padding: EdgeInsets.all(10),
                     child: TextFormField(

                       obscureText: notVisible,
                       onChanged: (value)=>{
                         setState((){
                           this.query=value;
                           //_search(query);
                         })
                       },
                       controller: queryTextEditingController,
                       decoration: InputDecoration(
                         suffixIcon: IconButton(icon: Icon(
                           notVisible==false?Icons.visibility:Icons.visibility_off,
                         ),onPressed: () {
                           setState(() {
                            notVisible=!notVisible;
                           });
                         },

                         ),
                         contentPadding: EdgeInsets.all(10),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(50),
                           borderSide: const BorderSide(
                             width: 1, color: Colors.deepOrange
                           )
                         )
                       ),
                     )),
               ),
               IconButton(onPressed: (){
                 setState(() {
                   items=[];
                   currenPage=0;

                   this.query = queryTextEditingController.text;
                   _search(query);


                 });

               }, icon: Icon(Icons.search, color: Colors.deepOrange,))
             ],
           ),
           Expanded(
             child: ListView.separated(
               separatorBuilder: (context,index)=>Divider(height: 2,color: Colors.deepOrange,),
               controller: scrollController,
                 itemCount:items.length,
               itemBuilder: (context,index){
                 return ListTile(
                   onTap: (){
                     Navigator.push(context,MaterialPageRoute(builder: (context)=>GitRepoPage(login: items[index]['login'], avatar_url: items[index]['avatar_url'],)
                     ));
                   },
                   title: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Row(
                         children: [
                           CircleAvatar(
                             backgroundImage: NetworkImage(items[index]["avatar_url"]),
                             radius: 30,

                           ),
                           SizedBox(width: 10,),
                           Text("${items[index]['login']}"),

                         ],
                       ),
                       CircleAvatar(
                           child: Text("${items[index]['score']}",
                           )),
                     ],
                   ),
                 );
               }),
           )
         ],
       ),
      ),
    );
  }

}