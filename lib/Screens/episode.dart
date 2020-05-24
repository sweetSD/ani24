import 'package:ani24/Animation/animations.dart';
import 'package:ani24/Data/constants.dart';
import 'package:ani24/Data/data.dart';
import 'package:ani24/Data/parser.dart';
import 'package:ani24/Widgets/texts.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ani24/Widgets/widgets.dart';
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

  VideoPlayerController controller;

  getData() async {
    return memorizer.runOnce(() async {
      http.Response response = await http.get(widget.animationEpisodeData.pageUrl);
      dom.Document document = parser.parse(response.body);

      var view_info_box = document.getElementsByClassName('view_info_box')[0];

      episodeData = EpisodeData(
        view_info_box.children[0].text,
        view_info_box.children[1].text,
        getEpisodeIdFromUrl(widget.animationEpisodeData.pageUrl),
      );

      // controller = VideoPlayerController.network('https://utrfghbvndf.com/a/' + episodeData.episodeId + '.jpg');
      // controller.addListener(() {
      //   setState(() {});
      // });
      // controller.initialize();
      // controller.play();

      return episodeData;
    });
  }

  @override
  void dispose() {
    if(controller != null)
      controller.dispose();
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
      padding: EdgeInsets.only(top: 12),
      alignment: Alignment.centerLeft,
      decoration: roundBoxDecoration(),
      child: getVideoWebView()
      //VideoPlayer(controller),
      
    );

    return OrientationBuilder(
      builder: (context, orientation) => Scaffold(
        appBar:  orientation == Orientation.portrait ? getAni24Appbar() : null,
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            print(snapshot.error);
            print(snapshot.hasData);
            if(!snapshot.hasData)
              return LoadingIndicator();
            else {
              return orientation == Orientation.portrait ? SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                physics: BouncingScrollPhysics(),
                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Space(20),
                    FadeInOffset(offset: Offset(0, 50), child: title,),
                    Space(20),
                    FadeInOffset(offset: Offset(0, 50), child: getVideoWebViewContainer(),)
                  ],
                )
              )
              : Container(
                width: double.infinity,
                height: double.infinity,
                child: getVideoWebView(),
              );
            }
          },
        ),
      ),
    );
  }
}