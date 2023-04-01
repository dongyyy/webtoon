import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      elevation: 2,
                      centerTitle: true,
                      foregroundColor: Colors.green,
                      backgroundColor: Colors.white,
                      title: const Text(
                        "오늘의 웝툰",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    body: FutureBuilder(
                      future: webtoons, //await 해줄 필요 없이 futureBuilder가 해줌
                      builder: (context, AsyncSnapshot snapshot) {
                        //snapshot을 이용하면 Future의 상태를 알 수 있음 - Future가 데이터를 받았는지, 아니면 오류를 받았는지 알 수 있음. connectionState도 알 수 있음
                        if (snapshot.hasData) {
                          return SizedBox(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                Expanded(child: makeList(snapshot))
                              ],
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListView makeList(AsyncSnapshot<dynamic> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Column(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              width: 250,
              child: Image.network(webtoon.thumb),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(10, 10),
                        blurRadius: 10),
                  ]),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              webtoon.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 50,
      ),
    );
  }
}
