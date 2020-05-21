class AnimationInfo {
  final String thumbUrl;
  final String pageUrl;
  final String title;
  final String genre;

  const AnimationInfo(this.thumbUrl, this.pageUrl, this.title, this.genre);
}

class AnimationOverview {
  final String title;           // 애니 타이틀

  final String thumbUrl;        // 애니 썸네일 url

  final double rating;          // 애니 평점
  final String originalTitle;   // 원제
  final String originalSeries;  // 원작
  final String director;        // 감독
  final String writer;          // 각본
  final String characterDesign; // 캐릭터 디자인
  final String music;           // 음악
  final String production;      // 제작사
  final String genre;           // 장르
  final String classification;  // 분류
  final String produceCountry;  // 제작 국가
  final String broadcastDate;   // 방영 일자
  final String mediaRating;     // 등급
  final String totalMediaCount; // 총화수

  const AnimationOverview(
    this.title,
    this.thumbUrl,
    this.rating,
    this.originalTitle,
    this.originalSeries,
    this.director,
    this.writer,
    this.characterDesign,
    this.music,
    this.production,
    this.genre,
    this.classification,
    this.produceCountry,
    this.broadcastDate,
    this.mediaRating,
    this.totalMediaCount,
  );

}