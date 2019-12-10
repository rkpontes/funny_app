import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {

  final Map video;

  AddPage([this.video]);

  @override
  _AddPageState createState() => _AddPageState(this.video);
}

class _AddPageState extends State<AddPage> {

  Map video;

  _AddPageState([this.video]);

  List _playlists;
  String _selectedListItem;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _youtubeUrlController = TextEditingController();

  _getPlaylists() async{
    http.Response response;
    response = await http.get(
        "http://czoomdev.pe.hu/funny/api/playlist",
        headers: {"Accept": "application/json"}
    );
    setState(() {
      _playlists = json.decode(response.body);
      print(_playlists);
    });
    //return json.decode(response.body);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(video != null){
      _titleController.text = video['title'];
      _descriptionController.text = video['description'];
      _youtubeUrlController.text = "https://www.youtube.com/watch?v=" + video['youtube_key'];
      _selectedListItem = video['playlist_id'].toString();
    }

    _getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: video != null ? Text("Alterar Video") : Text("Adicionar Video"),
      ),
      body: _formAdd(),
    );
  }


  _formAdd(){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          TextFormField(
            controller: _titleController,
            key: Key('title'),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: 'Título'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _descriptionController,
            key: Key('description'),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: 'Descrição'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
           SizedBox(height: 10),
          TextFormField(
            controller: _youtubeUrlController,
            key: Key('youtube_key'),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: 'URL Vídeo Youtube'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
           SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DropdownButton<String>(
                isExpanded: true,
                hint: Text("Selecione uma Playlist"),
                value: _selectedListItem,
                onChanged: (newValue) {
                  setState(() {
                    _selectedListItem = newValue;
                  });
                },
                items: _playlists?.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['id'].toString(),
                    child: Text(
                      item['name'],
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                })?.toList() ?? [],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height/2,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: RaisedButton(
                        color: Colors.red,
                        padding: EdgeInsets.fromLTRB(150, 0, 150, 0),
                        onPressed: () {
                          _submitForm();
                        },
                        child: Container(
                          child: Text('Salvar',style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  _submitForm() async{

    http.Response response;

    if(video != null){
      response = await http.put(
          "http://czoomdev.pe.hu/funny/api/video/"+video['id'].toString(),
          body: {
            'title': _titleController.text.toString(),
            'description': _descriptionController.text.toString(),
            'youtubeUri': _youtubeUrlController.text.toString(),
            'playlist_id': _selectedListItem,
          },
          headers: {"Accept": "application/json"}
      );
    }else{
      response = await http.post(
          "http://czoomdev.pe.hu/funny/api/video",
          body: {
            'title': _titleController.text.toString(),
            'description': _descriptionController.text.toString(),
            'youtubeUri': _youtubeUrlController.text.toString(),
            'playlist_id': _selectedListItem,
          },
          headers: {"Accept": "application/json"}
      );
    }

    print(response.body);
    Navigator.pop(context);
  }


}
