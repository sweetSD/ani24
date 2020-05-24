import 'package:ani24/Data/constants.dart';
import 'package:ani24/Data/data.dart';
import 'package:ani24/Screens/overview.dart';
import 'package:ani24/Widgets/texts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar getAni24Appbar() {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.white,
    title: Image.asset('assets/image/main_logo.png', width: 120, height: 30,),
    iconTheme: IconThemeData(color: Colors.black),
  );
}

class Space extends StatelessWidget {
  final double size;

  const Space(this.size);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size, width: size,);
  }
}

class AnimationCard extends StatelessWidget {

  final AnimationData animation;

  const AnimationCard(this.animation);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    navigateToOverviewPage() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => OverviewPage(animation)));
    }

    return Container(
      decoration: roundBoxDecoration(),
      child: InkWell(
        onTap: navigateToOverviewPage,
        child: Row(
          children: <Widget>[
            Container(
              width: size.width * 0.3,
              height: size.height * 0.21,
              padding: EdgeInsets.symmetric(horizontal: size.height * 0.005, vertical: size.height * 0.01),
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
                    CustomText(animation.title, size: 20,),
                    Space(20),
                    CustomText(animation.genre, color: ani24_text_blue,)
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