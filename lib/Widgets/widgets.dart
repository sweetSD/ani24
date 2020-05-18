import 'package:ani24/Data/data.dart';
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

    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: size.width * 0.3,
            height: size.height * 0.21,
            child: CachedNetworkImage(
              imageUrl: (animation.thumbUrl.startsWith('//') ? 'https:' : '') + animation.thumbUrl,
              placeholder: (context, url) => Padding(padding: EdgeInsets.symmetric(horizontal: size.height * 0.05, vertical: size.height * 0.078), child: CircularProgressIndicator(),),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(children: <Widget>[
              CustomText(animation.title),
              Space(10),
              CustomText(animation.genre, style: TextStyle(color: ani24_text_blue),)
            ],)
            ,)
          ,),
      ],),
    );
  }
}