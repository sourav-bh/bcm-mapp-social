import 'dart:async';

import 'package:app/api/api_manager.dart';
import 'package:app/model/query_list_response.dart';
import 'package:app/model/tweets_response.dart';
import 'package:app/util/app_style.dart';
import 'package:app/util/cache_image_network.dart';
import 'package:app/util/common_util.dart';
import 'package:app/util/shimmer_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TweetListPage extends StatefulWidget {
  const TweetListPage({Key? key}) : super(key: key);

  @override
  _TweetListPageState createState() => _TweetListPageState();
}

class _TweetListPageState extends State<TweetListPage> {
  final _shimmerLoading = ShimmerLoading();
  bool _loading = true;

  QueryResult? _queryDetails;
  TweetsDetails? _tweetData;
  final List<bool> _isSelected = [true, false];

  @override
  void initState() {
    _getData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadIntents();
  }

  _loadIntents() async {
    var intent = ModalRoute.of(context)?.settings.arguments;
    if (intent != null) {
      if (intent is QueryResult) {
        setState(() {
          _queryDetails = intent;
          _getData();
        });
      } else if (intent is TweetsDetails) {
        setState(() => _tweetData = intent);
      }
    }
  }

  void _getData() {
    setState(() => _loading = true);
    ApiManager().fetchTweetsFromQuery(_queryDetails?.queryTime ?? 0).then((response) {
      if (mounted) {
        setState(() => _loading = false);
        if (response != null) {
          setState(() {
            _tweetData = response!;
          });
        } else {
          // _showErrorForSessionTimeout();
        }
      }
    }, onError: (e) {
      setState(() {
        if(mounted) _loading = false;
      });
      _showErrorForSessionTimeout();
    });
  }

  void _showErrorForSessionTimeout() {
    showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Session timeout, please login again!'),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                CommonUtil.logoutUser(dialogContext);
              },
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        centerTitle: true,
        title: Text(_queryDetails?.searchQuery?.first ?? 'Search Results'),
      ),
      body: RefreshIndicator(
          onRefresh: refreshData,
          child: Column(
            children: [
              Visibility(
                visible: false,
                child: PreferredSize(
                  child: Container(
                    color: AppColor.BackgroundGrey,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    height: kToolbarHeight,
                    child: ToggleButtons(
                      borderWidth: 0,
                      borderColor: AppColor.BackgroundGrey,
                      selectedColor: AppColor.Primary,
                      color: AppColor.Secondary,
                      disabledColor: AppColor.Secondary,
                      fillColor: AppColor.BackgroundGrey,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.list),
                              SizedBox(width: 5,),
                              Text('Tweets'),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(Icons.map),
                              SizedBox(width: 5,),
                              Text('Stats'),
                            ],
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0; buttonIndex < _isSelected.length; buttonIndex++) {
                            if (buttonIndex == index) {
                              _isSelected[buttonIndex] = true;
                            } else {
                              _isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      isSelected: _isSelected,
                    ),
                  ),
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                ),
              ),
              Expanded(child: (_loading == true)
                ? _shimmerLoading.buildShimmerContent()
                : _isSelected[0] == true ? _buildListView() : _buildAnalysisView(),)
            ],
          ),
        )
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _tweetData?.englishData?.data?.length ?? _tweetData?.germanData?.data?.length ?? 0,
      padding: const EdgeInsets.symmetric(vertical: 0),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _buildResultItem(index, MediaQuery.of(context).size.width);
      },
    );
  }

  Widget _buildResultItem(index, boxImageSize) {
    List<TweetData>? data = _tweetData?.englishData?.data ?? _tweetData?.germanData?.data ?? [];
    return Column(
      children: [
        GestureDetector(
          onTap: () {
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.rss_feed, color: Colors.blue,),
                            Text(
                              data[index].date ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        RichText (
                          textAlign: TextAlign.start,
                          text: TextSpan(text: 'By: ',
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500
                              ),
                              children: [
                                TextSpan(
                                    text: data[index].user ?? '',
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                              ]),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          data[index].tweetText ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        (index == data.length - 1)
          ? Wrap()
          : const Divider(
            height: 1,
            color: Colors.black12,
        )
      ],
    );
  }

  Widget _buildAnalysisView() {
    return ListView(
      children: [

      ],
    );
  }

  Future refreshData() async {
    setState(() {
      _tweetData = null;
      _loading = true;
      _getData();
    });
  }
}
