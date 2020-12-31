import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeBody extends StatefulWidget {
  HomeBody() : super();
  final String title = "Başlık";
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  static const String url = 'https://www.hurriyet.com.tr/rss/anasayfa';

  RssFeed _feed;
  String _title;
  GlobalKey<RefreshIndicatorState> _refreshKey;

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  load() async {
    updateTitle("Yükleniyor");
    loadFeed().then((value) {
      if (value == null || value.toString().isEmpty) {
        updateTitle("Başlıksız");
        return;
      }
      updateFeed(value);
      updateTitle(_feed.title);
    });
  }

  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final res = await client.get(url);
      return RssFeed.parse(res.body);
    } catch (e) {}
    return null;
  }

  Future<void> openWebView(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: true,
      );
      return;
    }
    updateTitle("Başaramadık");
  }

  isFeedEmpty() {
    return null == _feed || _feed.items == null;
  }

  @override
  void initState() {
    super.initState();
    updateTitle(widget.title);
    load();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            onRefresh: () => load(),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _feed.items.length,
              itemBuilder: (context, index) {
                final item = _feed.items[index];
                return ListTile(
                  trailing: Icon(Icons.keyboard_arrow_left),
                  contentPadding: EdgeInsets.all(5),
                  onTap: () {
                    openWebView(item.link);
                  },
                  title: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: CachedNetworkImage(
                      imageUrl: item.enclosure.url,
                      width: 70,
                      height: 50,
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
            ),
          );
  }
}