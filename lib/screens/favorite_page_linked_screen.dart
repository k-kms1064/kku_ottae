import 'package:flutter/material.dart';

class FavoritePageScreen extends StatelessWidget {
  final Set<String> favorites;

  const FavoritePageScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    final List<String> sortedFavorites = favorites.toList()..sort();

    // 탭 구분용 데이터 분리
    final List<String> busFavorites = sortedFavorites.where((f) =>
        f.startsWith("dong-") || f.startsWith("anyang-") || f.startsWith("ansan-")).toList();

    final List<String> facilityFavorites =
        sortedFavorites.where((f) => f.startsWith("restaurant-")).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: const Text(
            '즐겨찾기',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF00552E),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: '버스'),
              Tab(text: '편의시설'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBusFavorites(busFavorites),
            _buildFacilityFavorites(facilityFavorites),
          ],
        ),
      ),
    );
  }

  // 🚍 버스 탭 내용
  Widget _buildBusFavorites(List<String> favorites) {
    const directDongSeoulTimes = {
      "9:50", "10:45", "13:35", "14:15", "14:35", "18:20", "19:20"
    };

    if (favorites.isEmpty) {
      return const Center(child: Text("즐겨찾기한 버스가 없습니다."));
    }

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final key = favorites[index];
        String label = "";
        TextStyle style = const TextStyle(fontWeight: FontWeight.bold);

        if (key.startsWith("dong-")) {
          String time = key.replaceFirst("dong-", "");
          final isDirect = directDongSeoulTimes.contains(time);
          if (isDirect) {
            label = "동서울 $time(직통)";
            style = const TextStyle(fontWeight: FontWeight.bold, color: Colors.red);
          } else {
            label = "동서울 $time";
          }
        } else if (key.startsWith("anyang-")) {
          final time = key.replaceFirst("anyang-", "");
          label = "안양·부천 $time";
        } else if (key.startsWith("ansan-")) {
          final time = key.replaceFirst("ansan-", "");
          label = "안산·인천 $time";
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: Text(label, style: style),
          ),
        );
      },
    );
  }

  // 🍽️ 편의시설(식당) 탭 내용
  Widget _buildFacilityFavorites(List<String> favorites) {
    if (favorites.isEmpty) {
      return const Center(child: Text("즐겨찾기한 편의시설이 없습니다."));
    }

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final key = favorites[index];
        final value = key.replaceFirst("restaurant-", "");
        final parts = value.split('|');
        final name = parts[0];
        final menu = parts.length > 1 ? parts[1] : "";
        final location = parts.length > 2 ? parts[2] : "";

        final label = "$name ($menu)\n$location";

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}
