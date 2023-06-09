import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/services/api_service.dart';

import 'episode_screen.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    Key? key,
    required this.title,
    required this.thumb,
    required this.id,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late final SharedPreferences prefs;
  bool isLiked = false;
  static const likedToonsKey = 'likedToons';

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodeById(widget.id);
    initPref();
  }

  initPref() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList(likedToonsKey);
    if (likedToons != null) {
      if (likedToons.contains(widget.id) ==
          true) { //likedToons.contains(widget.id) 랑 뭐가 다른가?
        setState(() {
          isLiked = true;
        });
      }
    } else {
      prefs.setStringList(likedToonsKey, []);
    }
  }

  onHartTap() async {
    final likedToons = prefs.getStringList(likedToonsKey);
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      }
      else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList(likedToonsKey, likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                    onHartTap();
                },
                icon: isLiked
                    ? const Icon(Icons.favorite_rounded)
                    : const Icon(Icons.favorite_border_rounded)),
          ],
          elevation: 2,
          centerTitle: true,
          foregroundColor: Colors.green,
          backgroundColor: Colors.white,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Hero(
                          tag: widget.id,
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            width: 250,
                            child: Image.network(widget.thumb),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: const Offset(10, 10),
                                      blurRadius: 10),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                FutureBuilder(
                  future: webtoon,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.about,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "${snapshot.data!.genre} / ${snapshot.data!.age}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      );
                    }
                    return const Text(
                      '...',
                      style: TextStyle(fontSize: 20),
                    );
                  },
                ),
                FutureBuilder(
                  future: episodes,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      //episodes가 리턴하는 데이ㅓ는 10개 밖에 안되는 리스트이므로 ListView 사용 X
                      var episodeList =
                      snapshot.data as List<WebtoonEpisodeModel>;
                      return Column(
                        children: [
                          for (var episode in episodeList)
                            Episode(
                              episode: episode,
                              titleId: widget.id,
                            )
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
}
