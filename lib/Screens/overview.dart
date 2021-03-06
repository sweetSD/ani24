import 'package:ani24/Animation/animations.dart';
import 'package:ani24/Data/constants.dart';
import 'package:ani24/Data/data.dart';
import 'package:ani24/Screens/episode.dart';
import 'package:ani24/Widgets/texts.dart';
import 'package:ani24/Widgets/widgets.dart';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';

class OverviewPage extends StatefulWidget {

  final AnimationData animation;

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
      http.Response response;
      while(response == null) {
        try {
          response = await http.get(widget.animation.pageUrl).timeout(Duration(seconds: 10));
        }
        catch (e) {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: '오류가 발생했습니다. 다시 시도해주세요.');
          return Future.value(null);
        }
      }
      dom.Document document = parser.parse(response.body);

      final ani_info_right = document.getElementsByClassName('ani_info_right_box');
      final ani_info_lines = ani_info_right.length > 0 ? document.getElementsByClassName('ani_info_right_box')[0].getElementsByClassName('info_line') : null;
      final ani_video_list = document.getElementsByClassName('ani_video_list')[0];

      overviewData = AnimationOverview(
        document.getElementsByClassName('ani_info_title_font_box')[0].text,
        document.getElementsByClassName('ani_info_left_box').length > 0 ? ('https:' + document.getElementsByClassName('ani_info_left_box')[0].children[0].attributes['src']) : '',
        document.getElementsByClassName('score_block_right').length > 0 ? double.parse(document.getElementsByClassName('score_block_right')[0].text) : 0,
        ani_info_lines != null ? ani_info_lines[0].children[1].text : '-',
        ani_info_lines != null ? ani_info_lines[1].children[1].text : '-',
        ani_info_lines != null ? ani_info_lines[2].children[1].text : '-',
        ani_info_lines != null ? ani_info_lines[3].children[1].text : '-',
        ani_info_lines != null ? ani_info_lines[4].children[1].text : '-',
        ani_info_lines != null ? ani_info_lines[5].children[1].text : '-',
        ani_info_lines != null ? ani_info_lines[6].children[1].text : '-',
        ani_info_lines != null ? ani_info_lines[7].children[1].text : '-',
        ani_info_lines != null ? ani_info_lines[8].children[1].text : '-',
        ani_info_lines != null ? ani_info_lines[9].children[1].text : '-',
        ani_info_lines != null ? ani_info_lines[10].children[1].text : '-',
        ani_info_lines != null ? ani_info_lines[11].children[1].text : '-',
        ani_info_lines != null ? ani_info_lines[12].children[1].text : '-',
        ani_video_list.children.map((e) {
          return AnimationEpisodeData('https:' + e.children[0].children[0].attributes['src'], e.children[1].children[0].text, e.children[1].children[1].text, baseurl + e.attributes['href']);
        }).toList(),

      );
      return overviewData;
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
    
    contentSpace(int index) => FadeInOffset(
      delayInMilisecond: index * 50 + 1000,
      offset: Offset(0, 30),
      child: Container(
        child: Column(
          children: <Widget>[
            Space(5),
            Divider(height: 1, thickness: 1, color: ani24_background_grey,),
            Space(5),
        ],),
      ),
    );

    getContent(String name, String value, {int index = 0}) {
      return FadeInOffset(
        delayInMilisecond: index * 50 + 1000,
        offset: Offset(0, 30),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: CustomText(name == null || name.isEmpty ? '-' : name, align: TextAlign.left, size: 16, color: ani24_text_grey,),
              ),
              Expanded(
                child: CustomText(value == null || value.isEmpty ? '-' : value, align: TextAlign.right, size: 16,),
              )
            ],
          ),
        ),
      );
    }

    getRating() => Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomText('평균 평점', align: TextAlign.left,),
          Expanded(child: Space(1), ),
          RatingBar(
            ignoreGestures: true,
            onRatingUpdate: (value) {},
            initialRating: overviewData.rating,
            glowColor: Colors.transparent,
            unratedColor: Color(0xffdadada),
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemPadding: EdgeInsets.zero,
            itemCount: 5,
            itemBuilder: (context, _) => Container(
              width: 30 * MediaQuery.of(context).size.width / 540,
              height: 30 * MediaQuery.of(context).size.width / 540,
              child: Icon(
                Icons.star,
                color: Color(0xff424d97),
              ),
            )
          ),
          CustomText(overviewData.rating.toString() + '점', align: TextAlign.right, size: 16,),
        ],
      ),
    );

    getOverview() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        width: double.infinity,
        decoration: roundBoxDecoration(),
        child: Column(
          children: <Widget>[
            FadeInOffset(
              delayInMilisecond: 900,
              offset: Offset(0, 30),
              child: CachedNetworkImage(imageUrl: overviewData.thumbUrl, fit: BoxFit.fitWidth,),
            ),
            Space(30),
            Container(
              child: Column(
                children: <Widget>[
                  FadeInOffset(
                    delayInMilisecond: 900,
                    offset: Offset(0, 30),
                    child: getRating(),
                  ),
                  contentSpace(0),
                  getContent('원제', overviewData.originalTitle, index: 0),
                  contentSpace(1),
                  getContent('원작', overviewData.originalSeries, index: 1),
                  contentSpace(2),
                  getContent('감독', overviewData.director, index: 2),
                  contentSpace(3),
                  getContent('각본', overviewData.writer, index: 3),
                  contentSpace(4),
                  getContent('캐릭터 디자인', overviewData.characterDesign, index: 4),
                  contentSpace(5),
                  getContent('음악', overviewData.music, index: 5),
                  contentSpace(6),
                  getContent('제작사', overviewData.production, index: 6),
                  contentSpace(7),
                  getContent('장르', overviewData.genre, index: 7),
                  contentSpace(8),
                  getContent('분류', overviewData.classification, index: 8),
                  contentSpace(9),
                  getContent('제작국가', overviewData.produceCountry, index: 9),
                  contentSpace(10),
                  getContent('방영일', overviewData.broadcastDate, index: 10),
                  contentSpace(11),
                  getContent('등급', overviewData.mediaRating, index: 11),
                  contentSpace(12),
                  getContent('총회수', overviewData.totalMediaCount, index: 12),

                ],
              ),
            ),
          ],
        ),
      );
    }

    getEpisodes() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        width: double.infinity,
        decoration: roundBoxDecoration(),
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Ani24Episode(overviewData.episodes[index]);
          },
          separatorBuilder: (context, index) => Container(child: Divider(height: 1, thickness: 1, color: ani24_background_grey,),),
          itemCount: overviewData.episodes.length,
        )
      );
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: ani24_background_grey,
      appBar: getAni24Appbar(),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          print(snapshot.error);
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
                  FadeInOffset(offset: Offset(0, 50), child: title,),
                  Space(20),
                  FadeInOffset(delayInMilisecond: 500, offset: Offset(0, 50), child: getOverview(),),
                  Space(20),
                  FadeInOffset(delayInMilisecond: 1000, offset: Offset(0, 50), child: getEpisodes(),),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}