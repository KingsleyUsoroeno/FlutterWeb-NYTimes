import 'package:flutter/material.dart';
import 'package:flutter_web_new_york_times/helpers/responsive_helper.dart';
import 'package:flutter_web_new_york_times/models/article_dto.dart';
import 'package:flutter_web_new_york_times/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _articlesFuture = ApiService().fetchArticlesBySection("technology");

  _buildArticlesGrid(List<ArticleDto> articles, MediaQueryData mediaQuery) {
    final List<GridTile> tiles = List.generate(articles.length,
        (index) => _buildArticleTile(articles[index], mediaQuery));

    return Padding(
      padding: responsivePadding(mediaQuery),
      //padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
      child: GridView.count(
        crossAxisCount: responsiveNumGridTiles(mediaQuery),
        //crossAxisCount: 4,
        mainAxisSpacing: 30.0,
        crossAxisSpacing: 30.0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: tiles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 80.0,
          ),
          const Center(
            child: Text(
              'The New York Times\nTop Tech Articles',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          FutureBuilder<List<ArticleDto>>(
            future: _articlesFuture,
            initialData: const [],
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong :)"));
              } else {
                return _buildArticlesGrid(snapshot.data ?? [], mediaQuery);
              }
            },
          )
        ],
      ),
    );
  }
}

_launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

_buildArticleTile(ArticleDto article, MediaQueryData mediaQuery) {
  return GridTile(
    child: GestureDetector(
      onTap: () => _launchURL(article.url),
      child: Column(
        children: <Widget>[
          Container(
            height: responsiveImageHeight(mediaQuery),
            //height: 250,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              image: DecorationImage(
                image: NetworkImage(article.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            height: responsiveTitleHeight(mediaQuery),
            //height: 160,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 1),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                article.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
