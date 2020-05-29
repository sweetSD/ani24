import 'package:ani24/Data/constants.dart';
import 'package:ani24/Data/data.dart';
import 'package:ani24/Widgets/texts.dart';
import 'package:ani24/Widgets/widgets.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  // 참고 : https://idlecomputer.tistory.com/326
  final AsyncMemoizer memorizer = AsyncMemoizer();

  String html = "";

  List<List<dom.Element>> main_anis = List<List<dom.Element>>();
  List<List<AnimationData>> main_ani_infoes = List<List<AnimationData>>();

  getData() async {
    return memorizer.runOnce(() async {
      // 사이트 html을 긁어와 애니 목록을 가져옵니다.
      http.Response response = await http.get(baseurl);
      dom.Document document = parser.parse(response.body);
      List<dom.Element> main_ani_container = document.getElementsByClassName('main_ani_list');
      List<dom.Element> main_ani_lists = main_ani_container[0].children.where((element) => element.className.contains('main_ani_day_list')).toList();

      main_anis.clear();
      main_ani_infoes.clear();
      // 애니 리스트 월, 화, 수, 목, 금, 토, 일
      for(int i = 0;i < 7;i++) {
        main_ani_infoes.add(List<AnimationData>());
        main_anis.add(main_ani_lists[i].children);
      }

      int index = 0;
      // Element의 firstChild와 children[0]은 다름.
      main_anis.forEach((List<dom.Element> element) {
        element.forEach((dom.Element _element) { 
          main_ani_infoes[index].add(AnimationData(
            _element.children[0].attributes['style'].split('(')[1].replaceAll(')', ''), 
            baseurl + _element.children[0].attributes['href'], 
            _element.children[1 + (_element.children.length == 4 ? 1 : 0)].text, 
            _element.children[2 + (_element.children.length == 4 ? 1 : 0)].text,
            _element.children.length == 4,
            ));
        });
        index++;
      });

      return main_ani_infoes;
    });
  }

  @override
  Widget build(BuildContext context) {

    final divider = Divider(color: ani24_text_grey, height: 2,);

    ScreenUtil.init(context, width: 540, height: 960, allowFontScaling: true);
    
    Widget buildTab(String text) {
      return Padding(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 24), child: Text(text),);
    }

    ListView buildAnimeListView(int day) {
      return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return AnimationCard(main_ani_infoes[day][index]);
        }, separatorBuilder: (context, index) {
          return Space(10);
        }, itemCount: main_ani_infoes[day].length
      );
    }

    return MaterialApp(
      home: DefaultTabController(
        length: 7,
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return Scaffold(
                resizeToAvoidBottomPadding: false,
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  bottom: TabBar(
                    labelColor: ani24_text_blue,
                    unselectedLabelColor: ani24_text_black,
                    indicatorColor: ani24_text_blue,
                    tabs: <Widget>[
                      buildTab("월"),
                      buildTab("화"),
                      buildTab("수"),
                      buildTab("목"),
                      buildTab("금"),
                      buildTab("토"),
                      buildTab("일"),
                    ],
                  ),
                  title: Image.asset('assets/image/main_logo.png', width: 120, height: 30,),
                ),
                body: TabBarView(
                  children: <Widget>[
                    buildAnimeListView(0),
                    buildAnimeListView(1),
                    buildAnimeListView(2),
                    buildAnimeListView(3),
                    buildAnimeListView(4),
                    buildAnimeListView(5),
                    buildAnimeListView(6),
                  ],
                ),
              );
            } else {
              return Scaffold(
                resizeToAvoidBottomPadding: false,
                body: LoadingIndicator()
              );
            }
        },),
      )
    );
  }
}