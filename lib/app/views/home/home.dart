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
      backgroundColor: Colors.black45,
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


  _showImage(dynamic item){
    return Container(
        decoration: BoxDecoration(
            color: Colors.black
        ),
        margin: const EdgeInsets.all(1),
        child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                child: GestureDetector(
                    onTap: (){
                      print(item);
                      /*FlutterYoutube.playYoutubeVideoByUrl(
                          apiKey: "AIzaSyC09msL4NHvgquEtXSA4BJ2x0P2aS-UGEM",
                          videoUrl: "https://www.youtube.com/watch?v=${item['youtube_key']}",
                          autoPlay: false, //default false
                          fullScreen: false //default false
                      );*/
                      FlutterYoutube.onVideoEnded.listen((onData) {
                        //perform your action when video playing is done
                      });
                      FlutterYoutube.playYoutubeVideoById(
                          apiKey: "AIzaSyC09msL4NHvgquEtXSA4BJ2x0P2aS-UGEM",
                          videoId: item['youtube_key'],
                          autoPlay: true);
                    },
                    onLongPress: (){
                      return showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: Text(
                                  "O que deseja fazer com '${item['title']}'?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "Nada",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    "Alterar",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) => AddPage(item)
                                        )
                                    ).then((value){
                                      setState(() {
                                        getVideos();
                                      });
                                    });
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    "Remover",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _showDialog(item);
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Text(item['title'], style: TextStyle(fontSize: 20.0, color: Colors.white),)
                            ),
                          CachedNetworkImage(
                            imageUrl: "http://img.youtube.com/vi/${item['youtube_key']}/hqdefault.jpg",
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.favorite , color: Colors.red,),
                              Icon(Icons.comment, color: Colors.white,),
                              Icon(Icons.panorama_horizontal, color: Colors.white,),
                              Icon(Icons.file_download, color: Colors.white,),
                              
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                                width: double.infinity,
                                height: 1,
                                color: Colors.white,
                              )
                        ],
                      ),
                    )
                ),
              )
            ]
        )
    );
  }



  void _showDialog(dynamic item) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Remover # ${item['title']}"),
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

