import 'dart:convert';

class TweetsResponse {
  TweetsResponse({
    this.result,
  });

  TweetsDetails? result;

  factory TweetsResponse.fromRawJson(String str) => TweetsResponse.fromJson(json.decode(str));

  factory TweetsResponse.fromJson(Map<String, dynamic> jsonResult) => TweetsResponse(
    result: json.decode(jsonResult["result"]),
  );
}

class TweetsDetails {
  TweetsDetails({
    this.count,
    this.englishData,
    this.germanData,
    this.stats,
  });

  CountryCount? count;
  TweetsByLang? englishData;
  TweetsByLang? germanData;
  TweetsStat? stats;

  factory TweetsDetails.fromRawJson(String str) => TweetsDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TweetsDetails.fromJson(Map<String, dynamic> json) => TweetsDetails(
    count: CountryCount.fromJson(json["count"]),
    englishData: TweetsByLang.fromJson(json["english"]),
    germanData: json["german"],
    stats: TweetsStat.fromJson(json["series"]),
  );

  Map<String, dynamic> toJson() => {
    "count": count != null ? count!.toJson() : null,
    "english": englishData != null ? englishData!.toJson() : null,
    "german": germanData != null ? germanData!.toJson() : null,
    "series": stats != null ? stats!.toJson() : null,
  };
}

class CountryCount {
  CountryCount({
    this.canada,
    this.colombia,
    this.india,
    this.southAfrica,
    this.usa,
    this.unknown,
  });

  int? canada;
  int? colombia;
  int? india;
  int? southAfrica;
  int? usa;
  int? unknown;

  factory CountryCount.fromRawJson(String str) => CountryCount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountryCount.fromJson(Map<String, dynamic> json) => CountryCount(
    canada: json["Canada"],
    colombia: json["Colombia"],
    india: json["India"],
    southAfrica: json["SouthAfrica"],
    usa: json["USA"],
    unknown: json["Unknown"],
  );

  Map<String, dynamic> toJson() => {
    "Canada": canada,
    "Colombia": colombia,
    "India": india,
    "SouthAfrica": southAfrica,
    "USA": usa,
    "Unknown": unknown,
  };
}

class TweetsByLang {
  TweetsByLang({
    this.data,
    this.topics,
  });

  List<TweetData>? data;
  List<Topic>? topics;

  factory TweetsByLang.fromRawJson(String str) => TweetsByLang.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TweetsByLang.fromJson(Map<String, dynamic> json) => TweetsByLang(
    data: List<TweetData>.from(json["data"].map((x) => TweetData.fromJson(x))),
    topics: List<Topic>.from(json["topics"].map((x) => Topic.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data != null ? List<dynamic>.from(data!.map((x) => x.toJson())) : null,
    "topics": topics != null ? List<dynamic>.from(topics!.map((x) => x.toJson())) : null,
  };
}

class TweetData {
  TweetData({
    this.clusterId,
    this.country,
    this.countryLabel,
    this.id,
    this.index,
    this.language,
    this.likes,
    this.date,
    this.place,
    this.retweet,
    this.sentiment,
    this.sentimentIcon,
    this.sentimentObj,
    this.tweetText,
    this.user,
  });

  int? clusterId;
  String? country;
  int? countryLabel;
  int? id;
  int? index;
  String? language;
  int? likes;
  String? date;
  String? place;
  int? retweet;
  double? sentiment;
  String? sentimentIcon;
  SentimentObj? sentimentObj;
  String? tweetText;
  String? user;

  factory TweetData.fromRawJson(String str) => TweetData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TweetData.fromJson(Map<String, dynamic> json) => TweetData(
    clusterId: json["clusterID"],
    country: json["country"],
    countryLabel: json["country_label"],
    id: json["id"],
    index: json["index"],
    language: json["language"],
    likes: json["likes"],
    date: json["date"],
    place: json["place"],
    retweet: json["retweet"],
    sentiment: json["sentiment"].toDouble(),
    sentimentIcon: json["sentimentIcon"],
    sentimentObj: SentimentObj.fromJson(json["sentiment_obj"]),
    tweetText: json["tweet_text"],
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "clusterID": clusterId,
    "country": country,
    "country_label": countryLabel,
    "id": id,
    "index": index,
    "language": language,
    "likes": likes,
    "date": date,
    "place": place,
    "retweet": retweet,
    "sentiment": sentiment,
    "sentimentIcon": sentimentIcon,
    "sentiment_obj": sentimentObj != null ? sentimentObj!.toJson() : null,
    "tweet_text": tweetText,
    "user": user,
  };
}

class SentimentObj {
  SentimentObj({
    this.compound,
    this.neg,
    this.neu,
    this.pos,
  });

  double? compound;
  double? neg;
  double? neu;
  double? pos;

  factory SentimentObj.fromRawJson(String str) => SentimentObj.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SentimentObj.fromJson(Map<String, dynamic> json) => SentimentObj(
    compound: json["compound"].toDouble(),
    neg: json["neg"].toDouble(),
    neu: json["neu"].toDouble(),
    pos: json["pos"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "compound": compound,
    "neg": neg,
    "neu": neu,
    "pos": pos,
  };
}

class Topic {
  Topic({
    this.id,
    this.rank,
    this.title,
    this.tweetCount,
    this.value,
  });

  int? id;
  String? rank;
  String? title;
  int? tweetCount;
  String? value;

  factory Topic.fromRawJson(String str) => Topic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json["id"],
    rank: json["rank"],
    title: json["title"],
    tweetCount: json["tweet_count"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rank": rank,
    "title": title,
    "tweet_count": tweetCount,
    "value": value,
  };
}

class TweetsStat {
  TweetsStat({
    this.happy,
    this.neutral,
    this.sad,
  });

  List<int>? happy;
  List<int>? neutral;
  List<int>? sad;

  factory TweetsStat.fromRawJson(String str) => TweetsStat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TweetsStat.fromJson(Map<String, dynamic> json) => TweetsStat(
    happy: List<int>.from(json["happy"].map((x) => x)),
    neutral: List<int>.from(json["neutral"].map((x) => x)),
    sad: List<int>.from(json["sad"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "happy": happy!= null ? List<dynamic>.from(happy!.map((x) => x)) : null,
    "neutral": neutral!= null ? List<dynamic>.from(neutral!.map((x) => x)) : null,
    "sad": sad!= null ? List<dynamic>.from(sad!.map((x) => x)) : null,
  };
}
