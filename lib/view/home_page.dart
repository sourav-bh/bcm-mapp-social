
import 'package:app/util/app_style.dart';
import 'package:app/view/manage_requests_page.dart';
import 'package:app/view/search_tweet_page.dart';
import 'package:app/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _scaffold = GlobalKey();
  late PageController _pageController;
  int _currentIndex = 0;

  bool _loadingRequested = false;

  final List<Widget> _contentPages = <Widget>[
    const RequestListPage(),
    const SearchTweetPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(_handleTabSelection);

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        backgroundColor: AppColor.Primary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: const Text('BCM Social Media', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey[100],
              height: 1.0,
            ),
            preferredSize: const Size.fromHeight(1.0)),
      ),
      body: _loadingRequested ?
      const Center(child: Text('Loading data...'),) :
      PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _contentPages.map((Widget content) {
          return content;
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (value) {
            _currentIndex = value;
            _pageController.jumpToPage(value);
            FocusScope.of(context).unfocus();
          },
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: AppColor.Primary,
          unselectedItemColor: AppColor.Secondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold
          ),
          iconSize: 28,
          items: const [
            BottomNavigationBarItem(
              label: 'Anfragen verwalten',
              icon: Icon(Icons.manage_search,)
            ),
            BottomNavigationBarItem(
                label: 'Suche',
                icon: Icon(Icons.search,)
            ),
            BottomNavigationBarItem(
              label: 'Konfiguration',
              icon: Icon(Icons.settings,)
            ),
          ],
        )
    );
  }
}
