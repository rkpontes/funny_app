import 'dart:convert';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:funny_app/app/views/add/add.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List data;

  getVideos() async{
    http.Response response;
    response = await http.get(
        "http://czoomdev.pe.hu/funny/api/video",
        headers: {"Accept": "application/json"}
    );
    setState(() {
      data = json.decode(response.body);
      print('JSON: ${data.toString()}');
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Funny Videos App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => AddPage()
                  )
              ).then((value){
                setState(() {
                  getVideos();
                });
              });
            },
          ),
        ],
      ),
      body: _listView(),
    );
  }

  _listView(){
    return ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (context, index) {
          return _showImage(data[index]);
        }
    );
  }


  _showImage(dynamic item) => Container(
    decoration: BoxDecoration(
      color: Colors.white
    ),
    margin: const EdgeInsets.all(1),
    child: Column(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            print(item);
            FlutterYoutube.playYoutubeVideoByUrl(
                apiKey: "AIzaSyC09msL4NHvgquEtXSA4BJ2x0P2aS-UGEM",
                videoUrl: "https://www.youtube.com/watch?v=${item['youtube_key']}",
                autoPlay: false, //default false
                fullScreen: false //default false
            );
          },
          onLongPress: (){
            _showDialog(item);
          },
          child: CachedNetworkImage(
            imageUrl: "https://img.youtube.com/vi/${item['youtube_key']}/hqdefault.jpg",
          )
        )
      ]
    )
  );


  void _showDialog(dynamic item) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Deletar # ${item['title']}"),
          content: Text("Deseja mesmo remover este vídeo?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Não"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Sim"),
              onPressed: () {
                print(item);
                _submitDelete(item);
              },
            ),
          ],
        );
      },
    );
  }


  _submitDelete(item) async{
    http.Response response;
    response = await http.delete(
        "http://czoomdev.pe.hu/funny/api/video/${item['id']}",
        headers: {"Accept": "application/json"}
    );
    print(response.body);
    getVideos();
    Navigator.of(context).pop();
  }


}

