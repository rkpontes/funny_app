import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

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
    _getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Video")
      ),
      body: _formAdd(),
    );
  }


  _formAdd(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
        Padding(
          padding: const EdgeInsets.all(10),
          child: RaisedButton(
            onPressed: () {
              _submitForm();
            },
            child: Text('Salvar'),
          ),
        ),
      ],
    );
  }


  _submitForm() async{
    http.Response response;
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

    print(response.body);
    Navigator.pop(context);
  }


}
