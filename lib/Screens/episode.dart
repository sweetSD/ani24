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
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EpisodePage extends StatefulWidget {

  final AnimationEpisodeData animationEpisodeData;

  EpisodePage(this.animationEpisodeData);

  @override
  EpisodePageState createState() => EpisodePageState();
}

class EpisodePageState extends State<EpisodePage> {

  EpisodeData episodeData;

  final AsyncMemoizer memorizer = AsyncMemoizer();

  bool isRotated = false;

  Ani24VideoPlayer player;

  getData() async {
    return memorizer.runOnce(() async {
      http.Response response;
      try {
        response = await http.get(widget.animationEpisodeData.pageUrl).timeout(Duration(seconds: 10));
      }
      catch (e) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: '오류가 발생했습니다. 다시 시도해주세요.');
        return Future.value(null);
      }

      dom.Document document = parser.parse(response.body);

      var view_info_box = document.getElementsByClassName('view_info_box')[0];

      episodeData = EpisodeData(
        view_info_box.children[0].text,
        view_info_box.children[1].text,
        getEpisodeIdFromUrl(widget.animationEpisodeData.pageUrl),
      );

      player = Ani24VideoPlayer(
        'https://utrfghbvndf.com/a/' + episodeData.episodeId + '.jpg', 
        width: MediaQuery.of(context).size.width - 24,
        height: (MediaQuery.of(context).size.width - 24) * 0.65,);

      return episodeData;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final title = Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      height: 75,
      alignment: Alignment.centerLeft,
      decoration: roundBoxDecoration(),
      child: CustomText(widget.animationEpisodeData.title ?? '', size: 18, type: TextType.ExtraBold,),
    );

    getVideoWebView() {
      return WebView(
        initialUrl: Uri.dataFromString(
          '<html><body><video id="video_player" controls="" width="100%" height="100%" style="height:calc(100% - 40px);display:block;"><source src="https://utrfghbvndf.com/a/' + episodeData.episodeId + '.jpg" type="video/mp4"></video></body></html>', 
          mimeType: 'text/html'
        ).toString(),
        javascriptMode: JavascriptMode.unrestricted,
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      );
    }

    getVideoWebViewContainer() => Container(
      width: MediaQuery.of(context).size.width - 24,
      height: (MediaQuery.of(context).size.width - 24) * 0.65,
      alignment: Alignment.centerLeft,
      child: //getVideoWebView()
      player
    );

    if(isRotated && player != null) {
      player.width = double.infinity;
      player.height = double.infinity;
    } else if (player != null) {
      player.width = MediaQuery.of(context).size.width - 24;
      player.height = (MediaQuery.of(context).size.width - 24) * 0.65;
    }

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar:  !isRotated ? getAni24Appbar() : null,
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            print(snapshot.error);
            print(snapshot.hasData);
            if(!snapshot.hasData)
              return LoadingIndicator();
            else {
              return !isRotated ? SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                physics: BouncingScrollPhysics(),
                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Space(20),
                    FadeInOffset(offset: Offset(0, 50), child: title,),
                    Space(20),
                    FadeInOffset(offset: Offset(0, 50), child: player,),
                    IconButton(icon: Icon(Icons.rotate_90_degrees_ccw), onPressed: () {setState(() {
                      isRotated = true;
                    });},),
                  ],
                )
              )
              : RotatedBox(
                quarterTurns: 45,
                child: Container(
                  width: MediaQuery.of(context).size.height,
                  height: MediaQuery.of(context).size.width,
                  child: player,
                ),
              );
            }
          },
        ),
      ),
      onWillPop: () {
        if(isRotated) {
          setState(() {
            isRotated = false;
          });
          return Future<bool>.value(false);
        }
        else {
          return Future<bool>.value(true);
        }
      },
    );
  }
}