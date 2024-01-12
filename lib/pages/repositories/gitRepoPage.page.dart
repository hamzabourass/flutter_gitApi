
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class GitRepoPage extends StatefulWidget {

  String login;
  String avatar_url;
  GitRepoPage({ required this.login,
   required this.avatar_url});

  @override
  State<GitRepoPage> createState() => _GitRepoPageState();
}

class _GitRepoPageState extends State<GitRepoPage> {
  dynamic dataRepo ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRepositories();

  }
  Future<void> loadRepositories() async {
    String url = "https://api.github.com/users/${widget.login}/repos";
    print(url);
    http.Response response = await http.get(Uri.parse(url));
    if(response.statusCode==200){
      setState(() {
        dataRepo= json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('${widget.login}'),
      actions: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.avatar_url),
        )
      ],),
      body:  Center(
        child: ListView.separated(
            itemBuilder: (context,index)=>ListTile(
              title: Text('${dataRepo[index]['name']}'),
            ),
            separatorBuilder: (context,index)=>Divider(height: 2,color: Colors.grey,),
            itemCount: dataRepo==null?0:dataRepo.length),
      ),
    );
  }

}