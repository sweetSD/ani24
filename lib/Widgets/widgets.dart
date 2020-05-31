import 'package:intl/intl.dart';
import 'package:ani24/Data/constants.dart';
import 'package:ani24/Data/data.dart';
import 'package:ani24/Screens/episode.dart';
import 'package:ani24/Screens/overview.dart';
import 'package:ani24/Widgets/texts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    // (animation.thumbUrl.startsWith('//') ? 'https:' : '') + animation.thumbUrl
                    imageUrl: animation.thumbUrl.startsWith('http') ? '' : 'https:' + animation.thumbUrl,
                    placeholder: (context, url) => Padding(padding: EdgeInsets.symmetric(horizontal: size.height * 0.05, vertical: size.height * 0.078), child: CircularProgressIndicator(),),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  if(animation.isUp)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width * 0.06,
                        height: size.width * 0.06,
                        color: Color(0xfffb4949),
                        child: CustomText('UP', color: Colors.white, size: 16,),
                      ),
                    )
                ],
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

class ReviewCard extends StatefulWidget {

  final ReviewCommentData _reviewCommentData;

  const ReviewCard(this._reviewCommentData);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.network(widget._reviewCommentData.thumbUrl, width: 32, height: 32,),
              Space(10),
              CustomText(widget._reviewCommentData.nickname, size: 16,),
              Space(10),
              Ani24RatingBar(initialRating: widget._reviewCommentData.rating.toDouble(), sizePx: 24,),
            ],
          ),
          Space(15),
          Container(
            width: double.infinity,
            child: CustomText(widget._reviewCommentData.body, align: TextAlign.left, height: 1.5,),
          ),
          Space(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomText(DateFormat('yyyy-MM-dd').format(widget._reviewCommentData.uploadedDate)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.7, color: Color(0xff7e7f85)),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5)
                  )
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.thumb_up, size: 16,),
                    Space(5),
                    CustomText(widget._reviewCommentData.likeCount.toString()),
                  ],
                ),
              ),
            ],
          ),

        ],
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

class Ani24RatingBar extends StatelessWidget {

  final bool ignoreGestures;
  final ValueChanged<double> onRatingUpdate;
  final double initialRating;
  final double sizePx;

  Ani24RatingBar({this.ignoreGestures = true, this.onRatingUpdate, this.initialRating = 0, this.sizePx = 32});

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      ignoreGestures: ignoreGestures,
      onRatingUpdate: onRatingUpdate,
      initialRating: initialRating,
      glow: false,
      unratedColor: Color(0xffdadada),
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemPadding: EdgeInsets.zero,
      itemSize: sizePx * MediaQuery.of(context).size.width / 540,
      itemCount: 5,
      itemBuilder: (context, _) => Container(
        width: sizePx * MediaQuery.of(context).size.width / 540,
        height: sizePx * MediaQuery.of(context).size.width / 540,
        child: Icon(
          Icons.star,
          color: Color(0xff424d97),
        ),
      )
    );
  }
}

class Ani24Episode extends StatelessWidget {

  final AnimationEpisodeData data;
  final bool openPageOnTap;

  const Ani24Episode(this.data, {this.openPageOnTap = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(openPageOnTap)
          Navigator.push(context, MaterialPageRoute(builder: (context) => EpisodePage(data),));
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.13,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(child: CachedNetworkImage(imageUrl: data.thumbUrl, fit: BoxFit.fill,), width: MediaQuery.of(context).size.width * 0.3, height: (MediaQuery.of(context).size.width * 0.3) * 0.65),
            Space(10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(child: Space(1), flex: 1,),
                  Container(height: 60, child: CustomText(data.title, align: TextAlign.left, size: 16,), constraints: new BoxConstraints(maxWidth: 300, maxHeight: 70)),
                  CustomText(data.uploadedAt, align: TextAlign.left,),
                  Expanded(child: Space(1), flex: 1,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}