import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  String html = "";
  List<List<dom.Element>> main_anis = List<List<dom.Element>>();

  Future<List<String>> getData() async {
    http.Response response = await http.get('https://ani24do.com/');
    dom.Document document = parser.parse(response.body);
    List<dom.Element> main_ani_container = document.getElementsByClassName('main_ani_list');
    List<dom.Element> main_ani_lists = main_ani_container[0].children.where((element) => element.className.contains('main_ani_day_list')).toList();

    main_anis.clear();
    // 애니 리스트 월, 화, 수, 목, 금, 토, 일
    main_anis.add(main_ani_lists[0].children);
    main_anis.add(main_ani_lists[1].children);
    main_anis.add(main_ani_lists[2].children);
    main_anis.add(main_ani_lists[3].children);
    main_anis.add(main_ani_lists[4].children);
    main_anis.add(main_ani_lists[5].children);
    main_anis.add(main_ani_lists[6].children);

    print(main_anis.length);

    main_anis.forEach((List<dom.Element> element) {
      element.forEach((dom.Element _element) { 
        print(_element.children[0].attributes['title']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ANI24"),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Ani24 Parser"),
              RaisedButton(onPressed: () {
                getData();
              },
                child: Text("Get Html"),
              ),
              Text(html)
            ],
          ),
        ),
      ),
    );
  }
}