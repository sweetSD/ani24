import 'package:ani24/Data/constants.dart';
import 'package:ani24/Data/data.dart';
import 'package:ani24/Widgets/texts.dart';
import 'package:ani24/Widgets/widgets.dart';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class OverviewPage extends StatefulWidget {

  final AnimationInfo animation;

  OverviewPage(this.animation);

  @override
  OverviewPageState createState() => OverviewPageState();
}

class OverviewPageState extends State<OverviewPage> {

  final AsyncMemoizer memorizer = AsyncMemoizer();

  AnimationOverview overviewData;

  String html = '';

  getData() async {
    return memorizer.runOnce(() async {
      http.Response response = await http.get(widget.animation.pageUrl);
      dom.Document document = parser.parse(response.body);

      final ani_info_right = document.getElementsByClassName('ani_info_right_box')[0];
      final ani_info_lines = document.getElementsByClassName('ani_info_right_box')[0].getElementsByClassName('info_line');

      overviewData = AnimationOverview(
        document.getElementsByClassName('ani_info_title_font_box')[0].text,
        'https:' + document.getElementsByClassName('ani_info_left_box')[0].children[0].attributes['src'],
        double.parse(document.getElementsByClassName('score_block_right')[0].text),
        ani_info_lines[0].children[1].text,
        ani_info_lines[1].children[1].text,
        ani_info_lines[2].children[1].text,
        ani_info_lines[3].children[1].text,
        ani_info_lines[4].children[1].text,
        ani_info_lines[5].children[1].text,
        ani_info_lines[6].children[1].text,
        ani_info_lines[7].children[1].text,
        ani_info_lines[8].children[1].text,
        ani_info_lines[9].children[1].text,
        ani_info_lines[10].children[1].text,
        ani_info_lines[11].children[1].text,
        ani_info_lines[12].children[1].text,
      );
      return document.getElementsByClassName('ani_info_title_font_box')[0].text;
    });
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final title = Container(
        padding: EdgeInsets.symmetric(horizontal: 18),
        height: 75,
        alignment: Alignment.centerLeft,
        decoration: roundBoxDecoration(),
        child: CustomText(widget.animation.title, size: 18, type: TextType.ExtraBold,),
    );

    final contentSpace = Column(
      children: <Widget>[
        Space(5),
        Divider(height: 1, thickness: 1, color: ani24_background_grey,),
        Space(5),
    ],);

    getContent(String name, String value) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomText(name ?? '', align: TextAlign.left, size: 16, color: ani24_text_grey,),
            CustomText(value ?? '', align: TextAlign.right, size: 16,),
          ],
        ),
      );
    }

    getOverview() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        width: double.infinity,
        decoration: roundBoxDecoration(),
        child: Column(
          children: <Widget>[
            CachedNetworkImage(imageUrl: overviewData.thumbUrl, fit: BoxFit.fitWidth,),
            Space(30),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomText('평균 평점', align: TextAlign.left,),
                        CustomText('4.3', align: TextAlign.right,),
                      ],
                    ),
                  ),
                  contentSpace,
                  getContent('원제', overviewData.originalTitle),
                  contentSpace,
                  getContent('원작', overviewData.originalSeries),
                  contentSpace,
                  getContent('감독', overviewData.director),
                  contentSpace,
                  getContent('각본', overviewData.writer),
                  contentSpace,
                  getContent('캐릭터 디자인', overviewData.characterDesign),
                  contentSpace,
                  getContent('음악', overviewData.music),
                  contentSpace,
                  getContent('제작사', overviewData.production),
                  contentSpace,
                  getContent('장르', overviewData.genre),
                  contentSpace,
                  getContent('분류', overviewData.classification),
                  contentSpace,
                  getContent('제작국가', overviewData.produceCountry),
                  contentSpace,
                  getContent('방영일', overviewData.broadcastDate),
                  contentSpace,
                  getContent('등급', overviewData.mediaRating),
                  contentSpace,
                  getContent('총회수', overviewData.totalMediaCount),

                ],
              ),
            ),
          ],
        ),
      );
    }



    return Scaffold(
      backgroundColor: ani24_background_grey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Image.asset('assets/image/main_logo.png', width: 120, height: 30,),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          print(snapshot.hasError);
          print(snapshot.hasData);
          if(!snapshot.hasData)
            return LoadingIndicator();
          else {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Space(20),
                  title,
                  Space(20),
                  getOverview(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}