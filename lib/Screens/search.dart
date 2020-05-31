import 'package:ani24/Animation/animations.dart';
import 'package:ani24/Data/constants.dart';
import 'package:ani24/Data/data.dart';
import 'package:ani24/Widgets/texts.dart';
import 'package:ani24/Widgets/widgets.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class SearchPage extends StatefulWidget {

  final SearchData searchData;

  const SearchPage(this.searchData);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final AsyncMemoizer memorizer = AsyncMemoizer();

  List<AnimationData> _searchResults;

  String html = '';

  getData() async {
    return memorizer.runOnce(() async {
      http.Response response;
      while(response == null) {
        try {
          response = await http.get(baseurl + '/ani/search.php?query=${widget.searchData.searchKeyword}&search_button=%EA%B2%80%EC%83%89').timeout(Duration(seconds: 10));
        }
        catch (e) {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: '오류가 발생했습니다. 다시 시도해주세요.');
          return Future.value(null);
        }
      }
      dom.Document document = parser.parse(response.body);
      final ani_search_list_box = document.getElementsByClassName('ani_search_list_box')[0];
      _searchResults = ani_search_list_box.children.map((e) {
        return AnimationData(
          e.getElementsByClassName('thumbnail')[0].children[0].attributes['src'],
          baseurl + e.getElementsByClassName('thumbnail')[0].attributes['href'],
          e.getElementsByClassName('subject')[0].text,
          e.getElementsByClassName('genre')[0].text,
        );
      }).toList();

      

      return _searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {

    getTitle() => Container(width: double.infinity, child: CustomText("'${widget.searchData.searchKeyword}' 검색결과", size: 24, type: TextType.Bold,), height: 30,) ;
    getInfo() => Container(width: double.infinity, child: CustomText("${_searchResults.length}개의 검색결과", size: 18,), height: 30,) ;

    getAnimations() {
      return Container(
        width: double.infinity,
        decoration: roundBoxDecoration(),
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return AnimationCard(_searchResults[index]);
          },
          separatorBuilder: (context, index) => Container(child: Divider(height: 1, thickness: 1, color: ani24_background_grey,),),
          itemCount: _searchResults.length,
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
                  FadeInOffset(offset: Offset(0, 50), child: getTitle(),),
                  Space(10),
                  FadeInOffset(offset: Offset(0, 50), child: getInfo(),),
                  Space(20),
                  FadeInOffset(offset: Offset(0, 50), child: getAnimations(),),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}