import 'package:ani24/Animation/animations.dart';
import 'package:ani24/Data/constants.dart';
import 'package:ani24/Data/data.dart';
import 'package:ani24/Data/parser.dart';
import 'package:ani24/Widgets/texts.dart';
import 'package:ani24/Widgets/video.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ani24/Widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum SortType { New, Like }

class EpisodePage extends StatefulWidget {

  final AnimationEpisodeData animationEpisodeData;

  EpisodePage(this.animationEpisodeData);

  @override
  EpisodePageState createState() => EpisodePageState();
}

class EpisodePageState extends State<EpisodePage> {

  EpisodeData episodeData;
  List<AnimationEpisodeData> otherEpisodes;
  List<ReviewCommentData> reviews;

  SortType _sortType = SortType.Like;

  final AsyncMemoizer memorizer = AsyncMemoizer();

  Ani24VideoPlayer player;

  WebViewController _cont;

  getData() async {
    return memorizer.runOnce(() async {
      http.Response response;
      while(response == null) {
        try {
          response = await http.get(widget.animationEpisodeData.pageUrl).timeout(Duration(seconds: 10));
        }
        catch (e) {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: '오류가 발생했습니다. 다시 시도해주세요.');
          return Future.value(null);
        }
      }

      dom.Document document = parser.parse(response.body);

      var view_info_box = document.getElementsByClassName('view_info_box')[0];

      episodeData = EpisodeData(
        view_info_box.children[0].text,
        view_info_box.children[1].text,
        getEpisodeIdFromUrl(widget.animationEpisodeData.pageUrl),
      );
      
      String video_addr = 'https://';
      document.getElementsByTagName('script').forEach((element) {
        print(element.text.trim());
        if(element.text.contains("ifr_adr")) {
          var lines = element.text.split('\n');
          for(int i = 0;i < lines.length; i ++) {
            if(lines[i].trim().startsWith('ifr_adr'))
              video_addr += lines[i].split('"')[1];
          }
        }
        print(video_addr);
      });

      player = Ani24VideoPlayer(
         'https://utrfghbvndf.com/a/' + episodeData.episodeId + '.jpg', 
        //video_addr, 
        //'http://new1.filegroupa.com/redirect.php?path=%2Ffiles%2F0%2F4001%7E8000%2Fid_6026.mp4',
        width: MediaQuery.of(context).size.width - 24,
        height: (MediaQuery.of(context).size.width - 24) * 0.65,
      );

      var video_list_box = document.getElementsByClassName('video_list_box')[0];
      otherEpisodes = video_list_box.children.where((element) => element.className.contains('video_list')).map((e) => AnimationEpisodeData(
        baseurl + e.getElementsByClassName('video_list_image')[0].attributes['src'],
        e.getElementsByClassName('subject')[0].text,
        e.getElementsByClassName('view_info_font')[0].text,
        baseurl + e.attributes['href']
      )).toList();

      var review_list = document.getElementsByClassName('review_list').length > 0 ? document.getElementsByClassName('review_list')[0] : null;
      reviews = review_list == null ? [] : review_list.children.map((element) {
        return ReviewCommentData(
          baseurl + element.getElementsByClassName('profile')[0].children[0].attributes['src'],
          element.getElementsByClassName('nick')[0].text,
          element.getElementsByClassName('review_score_box')[0].children.where((element) => element.className == 'starR on').length,
          element.getElementsByClassName('review_content')[0].text,
          DateTime.parse(element.getElementsByClassName('review_date')[0].text),
          int.parse(element.getElementsByClassName('review_good_num')[0].text),
          baseurl + element.getElementsByClassName('review_good')[0].attributes['href'],
        );
      }).toList();

      return episodeData;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    gettitle() => Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      alignment: Alignment.centerLeft,
      decoration: roundBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomText(widget.animationEpisodeData.title ?? '', size: 18, type: TextType.ExtraBold,),
          Space(5),
          CustomText(episodeData.viewInfo ?? '', size: 16,),
        ],
      ),
    );

    getOtherEpisodes() => Container(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => index == 0 ? 
          Container(child: CustomText('영상 리스트', size: 24, type: TextType.Bold,), height: 30,) 
          : Ani24Episode(otherEpisodes[index - 1], openPageOnTap: otherEpisodes[index - 1].pageUrl.compareTo(widget.animationEpisodeData.pageUrl) != 0), 
        separatorBuilder: (context, index) => Divider(thickness: 1, height: 1, color: ani24_background_grey,), 
        itemCount: otherEpisodes.length + 1
      ),
    );

    // 리뷰 위젯
    getReviews() { 
      if(_sortType == SortType.Like)
        reviews.sort((data1, data2) => data2.likeCount.compareTo(data1.likeCount));
      else if (_sortType == SortType.New)
        reviews.sort((data1, data2) => data2.uploadedDate.compareTo(data1.uploadedDate));
      return Container(
        color: Colors.white,
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => index == 0 ?
          Row(
            children: <Widget>[
              Container(child: CustomText('유저 리뷰', size: 24, type: TextType.Bold,), height: 30,), 
              Expanded(child: Space(1),),
              InkWell(
                onTap: () {
                  setState(() {
                    _sortType = SortType.New;
                  });
                },
                child: CustomText('최신순', color: _sortType == SortType.New ? ani24_text_blue : ani24_text_black, size: 16,),
              ),
              Space(10),
              InkWell(
                onTap: () {
                  setState(() {
                    _sortType = SortType.Like;
                  });
                },
                child: CustomText('좋아요순', color: _sortType == SortType.Like ? ani24_text_blue : ani24_text_black, size: 16,),
              ),
            ],
          )
          : ReviewCard(reviews[index - 1]), 
          separatorBuilder: (context, index) => Divider(thickness: 1, height: 24, color: ani24_background_grey,), 
          itemCount: reviews.length + 1,
        ),
      );
    }

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
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
                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Space(20),
                    FadeInOffset(offset: Offset(0, 50), child: gettitle(), delayInMilisecond: 500,),
                    Space(20),
                    FadeInOffset(offset: Offset(0, 50), child: player, delayInMilisecond: 1000,),
                    Space(10),
                    FadeInOffset(offset: Offset(0, 50), child: InkWell(
                      onTap: () async {
                        if(await canLaunch(widget.animationEpisodeData.pageUrl))
                          launch(widget.animationEpisodeData.pageUrl);
                      },
                      child: Container(
                        decoration: roundBoxDecoration(),
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        child: CustomText('영상이 뜨지 않으면 여기를 눌러 인터넷으로 이동해주세요.', size: 16, align: TextAlign.center,),
                      ),
                    ), delayInMilisecond: 1000,),
                    Space(40),
                    FadeInOffset(offset: Offset(0, 50), child: getOtherEpisodes(), delayInMilisecond: 1500,),
                    Space(40),
                    FadeInOffset(offset: Offset(0, 50), child: getReviews(), delayInMilisecond: 2000,),
                  ],
                )
              );
            }
          },
        ),
      ),
      onWillPop: () {
        return Future<bool>.value(true);
      },
    );
  }
}