import 'dart:convert';

import 'package:app/api/api_client.dart';
import 'package:app/model/login_response.dart';
import 'package:app/model/query_list_response.dart';
import 'package:app/model/tweets_response.dart';
import 'package:app/util/app_constant.dart';

class ApiManager {
  ApiManager();

  Future<LoginResponse> requestLogin(String email, String password) async {
    var reqBody = <String, String> {
      'username': email,
      'password': password,
      '_ApplicationId': AppConstant.applicationId,
      '_ClientVersion': AppConstant.clientVersion,
      '_InstallationId': AppConstant.installationId,
    };

    var response = await ApiClient.instance.postRequest('login', reqBody);
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      var emptyRes = LoginResponse();
      emptyRes.userId = null;
      return emptyRes;
    }
  }

  Future<QueryRequestsResponse> fetchQueryRequests() async {
    var reqBody = <String, Object> {
      'Widget': 'socialMedia',
      'item': {
        'userID': AppCache.instance.userId ?? '',
      },
      '_ApplicationId': AppConstant.applicationId,
      '_ClientVersion': AppConstant.clientVersion,
      '_InstallationId': AppConstant.installationId,
      '_SessionToken': AppCache.instance.sessionToken ?? '',
    };

    var response = await ApiClient.instance.postRequest('functions/FetchMyTweets', reqBody);
    if (response.statusCode == 200) {
      return QueryRequestsResponse.fromJson(json.decode(response.body));
    } else {
      var emptyRes = QueryRequestsResponse();
      emptyRes.result = null;
      return emptyRes;
    }
  }

  Future<TweetsDetails?> fetchTweetsFromQuery(int queryTime) async {
    var reqBody = <String, Object> {
      'Widget': 'socialMedia',
      'item': {
        'userID': AppCache.instance.userId ?? '',
        'queryTime': queryTime,
      },
      '_ApplicationId': AppConstant.applicationId,
      '_ClientVersion': AppConstant.clientVersion,
      '_InstallationId': AppConstant.installationId,
      '_SessionToken': AppCache.instance.sessionToken ?? '',
    };

    var response = await ApiClient.instance.postRequest('functions/FetchMyTweet', reqBody);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      if (result.isNotEmpty) {
        var rr = json.decode(result["result"]);
        return TweetsDetails.fromJson(rr);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<TweetsDetails?> searchTweets(List<String?> query, String startDate, String endDate, String lang) async {
    var reqBody = <String, Object> {
      'Widget': 'socialMedia',
      'item': {
        'searchText': query,
        'startDate': startDate,
        'endDate': endDate,
        'userID': AppCache.instance.userId ?? '',
        'langR': lang,
        'queryTime': DateTime.now().microsecondsSinceEpoch,
        'status': false,
      },
      '_ApplicationId': AppConstant.applicationId,
      '_ClientVersion': AppConstant.clientVersion,
      '_InstallationId': AppConstant.installationId,
      '_SessionToken': AppCache.instance.sessionToken ?? '',
    };
    print(reqBody);

    var response = await ApiClient.instance.postRequest('functions/SocialMediaSearch', reqBody);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      if (result.isNotEmpty) {
        var rr = json.decode(result["result"]);
        return TweetsDetails.fromJson(rr);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}