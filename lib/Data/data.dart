
// 메인에 뜨는 간단한 애니메이션 데이터 클래스
class AnimationData {
  final String thumbUrl;
  final String pageUrl;
  final String title;
  final String genre;
  final bool isUp;
  final bool isBookMarked;

  const AnimationData(this.thumbUrl, this.pageUrl, this.title, this.genre, [this.isUp = false, this.isBookMarked = false]);
}

// 애니메이션 개요 보기 페이지에 필요한 데이터 클래스
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

  final List<AnimationEpisodeData> episodes;

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
    this.episodes,
  );

}

// 애니메이션 개요 페이지에 출력될 에피소드 데이터
class AnimationEpisodeData {
  final String thumbUrl;
  final String title;
  final String uploadedAt;
  final String pageUrl;

  const AnimationEpisodeData(this.thumbUrl, this.title, this.uploadedAt, this.pageUrl);
}

// 애니메이션 에피소드 재생 페이지에 필요한 에피소드 데이터
class EpisodeData {
  final String title;
  final String viewInfo;
  final String episodeId;

  const EpisodeData(this.title, this.viewInfo, this.episodeId);
}

// 애니메이션 리뷰 데이터
class ReviewCommentData {
  final String thumbUrl;
  final String nickname;
  final int rating;
  final String body;
  final DateTime uploadedDate;
  final int likeCount;
  final String likeUrl;

  const ReviewCommentData(this.thumbUrl, this.nickname, this.rating, this.body, this.uploadedDate, this.likeCount, this.likeUrl);
}

// 애니메이션 검색 데이터
class SearchData {
  final String searchKeyword;

  const SearchData(this.searchKeyword);
}