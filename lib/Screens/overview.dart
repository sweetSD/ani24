import 'package:ani24/Data/data.dart';
import 'package:ani24/Widgets/widgets.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class OverviewPage extends StatelessWidget {

  final AnimationInfo animation;

  OverviewPage(this.animation);

  final AsyncMemoizer memoizer = AsyncMemoizer();

  getData() async {
    return memoizer.runOnce(() async {
      http.Response response = await http.get(animation.pageUrl);
      dom.Document document = parser.parse(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Image.asset('assets/image/main_logo.png', width: 120, height: 30,),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          return LoadingIndicator();
        },
      ),
    );
  }
}