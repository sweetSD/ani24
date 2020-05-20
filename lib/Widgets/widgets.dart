import 'package:ani24/Data/data.dart';
import 'package:ani24/Screens/overview.dart';
import 'package:ani24/Widgets/texts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Space extends StatelessWidget {
  final double size;

  const Space(this.size);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size, width: size,);
  }
}

class AnimationCard extends StatelessWidget {

  final AnimationInfo animation;

  const AnimationCard(this.animation);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    navigateToOverviewPage() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => OverviewPage(animation)));
    }

    return Container(
      child: InkWell(
        onTap: navigateToOverviewPage,
        child: Row(
          children: <Widget>[
            Container(
              width: size.width * 0.3,
              height: size.height * 0.21,
              child: CachedNetworkImage(
                // (animation.thumbUrl.startsWith('//') ? 'https:' : '') + animation.thumbUrl
                imageUrl: 'https:' + animation.thumbUrl,
                placeholder: (context, url) => Padding(padding: EdgeInsets.symmetric(horizontal: size.height * 0.05, vertical: size.height * 0.078), child: CircularProgressIndicator(),),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText(animation.title, size: 20, type: TextType.ExtraBold,),
                    Space(20),
                    CustomText(animation.genre, style: TextStyle(color: ani24_text_blue),)
              ],)
              ,)
            ,),
        ],),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Space(30),
          Text("로딩중입니다.."),
      ],),
    );
  }
}