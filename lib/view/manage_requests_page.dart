import 'dart:async';

import 'package:app/api/api_manager.dart';
import 'package:app/main.dart';
import 'package:app/model/query_list_response.dart';
import 'package:app/util/app_style.dart';
import 'package:app/util/common_util.dart';
import 'package:app/util/shared_preference.dart';
import 'package:app/util/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({Key? key}) : super(key: key);

  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  final _shimmerLoading = ShimmerLoading();
  bool _loading = true;

  List<QueryResult> _requestData = [];

  @override
  void initState() {
    _getData();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getData() {
    setState(() => _loading = true);

    ApiManager().fetchQueryRequests().then((response) {
      if (mounted) {
        setState(() => _loading = false);
        if (response.result != null && response.result!.isNotEmpty) {
          setState(() {
            _requestData = response.result!;
          });
        } else {
          _showErrorForSessionTimeout();
        }
      }
    }, onError: (e) {
      setState(() => _loading = false);
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
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: (_loading == true)
          ? _shimmerLoading.buildShimmerContent()
          : _buildListView(),
        )
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _requestData.length,
      padding: const EdgeInsets.symmetric(vertical: 0),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _buildRequestItem(index, MediaQuery.of(context).size.width);
      },
    );
  }

  Widget _buildRequestItem(index, boxImageSize){
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, tweetDetailsRoute, arguments: _requestData.elementAt(index));
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RichText (
                                textAlign: TextAlign.start,
                                text: TextSpan(text: 'Suche: ',
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                    ),
                                    children: [
                                      TextSpan(
                                          text: _requestData[index].searchQuery?.first ?? '',
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500
                                          )
                                      )
                                    ]),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColor.Primary.withOpacity(0.8),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(7.5),
                                )),
                              child: Padding(
                                padding: const EdgeInsets.all(7.5),
                                child: Text(_requestData[index].language ?? '',
                                  style: const TextStyle(fontSize: AppTextStyle.ExtraSmallTextSize, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RichText (
                                textAlign: TextAlign.start,
                                text: TextSpan(text: 'Beginn: ',
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                    ),
                                    children: [
                                      TextSpan(
                                          text: CommonUtil.getServerDateToString(_requestData[index].startDate ?? ''),
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500
                                          )
                                      )
                                    ]),
                              ),
                            ),
                            Expanded(
                              child: RichText (
                                textAlign: TextAlign.end,
                                text: TextSpan(text: 'Ende: ',
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                    ),
                                    children: [
                                      TextSpan(
                                          text: CommonUtil.getServerDateToString(_requestData[index].endDate ?? ''),
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500
                                          )
                                      )
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        (index == _requestData.length - 1)
          ? Wrap()
          : const Divider(
            height: 1,
            color: Colors.black26,
        )
      ],
    );
  }

  Future refreshData() async {
    setState(() {
      _requestData.clear();
      _loading = true;
      _getData();
    });
  }
}
