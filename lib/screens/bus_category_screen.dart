import 'package:flutter/material.dart';

class BusCategoryScreen extends StatefulWidget {
  final Set<String> favorites;
  final void Function(String) toggleFavorite;

  const BusCategoryScreen({
    super.key,
    required this.favorites,
    required this.toggleFavorite,
  });

  @override
  State<BusCategoryScreen> createState() => _BusCategoryScreenState();
}

class _BusCategoryScreenState extends State<BusCategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00552E),
      appBar: AppBar(
        title: const Text(
          '버스 정보',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00552E),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[300],
          tabs: const [
            Tab(text: '시외버스'), // ✅ 순서 바뀜
            Tab(text: '시내버스'),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: TabBarView(
          controller: _tabController,
          children: [
            OutCityBusTab(
              favorites: widget.favorites,
              toggleFavorite: widget.toggleFavorite,
            ),
            const InCityBusTab(),
          ],
        ),
      ),
    );
  }
}

class InCityBusTab extends StatelessWidget {
  const InCityBusTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> busStops = [
      "후문",
      "도서관",
      "건국대 정문",
      "충주역",
      "호암지",
    ];

    return ListView.builder(
      itemCount: busStops.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '${busStops[index]} 버스정보',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}

class OutCityBusTab extends StatelessWidget {
  final Set<String> favorites;
  final void Function(String) toggleFavorite;

  const OutCityBusTab({
    super.key,
    required this.favorites,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> busTimes = {
      "동서울": [
        "7:00", "9:00", "9:50", "10:20", "10:45", "13:00", "13:35",
        "14:15", "14:35", "15:00", "16:40", "18:20", "19:20", "20:10"
      ],
      "안양·부천": ["16:25"],
      "안산·인천": ["8:30", "13:20", "17:30"],
    };

    final Set<String> directDongSeoul = {
      "9:50", "10:45", "13:35", "14:15", "14:35", "18:20", "19:20"
    };

    return ListView(
      children: busTimes.entries.map((entry) {
        final title = entry.key;
        final times = entry.value;

        return ExpansionTile(
          title: Text(
            "$title행 시외버스",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.green[50],
          collapsedBackgroundColor: Colors.white,
          children: times.isEmpty
              ? [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("시간 정보 없음",
                        style: TextStyle(color: Colors.grey)),
                  )
                ]
              : times.map((time) {
                  final isDirect =
                      title == "동서울" && directDongSeoul.contains(time);
                  final key = title == "동서울"
                      ? "dong-$time"
                      : title == "안양·부천"
                          ? "anyang-$time"
                          : "ansan-$time";

                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          isDirect ? "$time (직통)" : time,
                          style: TextStyle(
                            color: isDirect ? Colors.red : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          iconSize: 18,
                          padding: const EdgeInsets.only(left: 4),
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            favorites.contains(key)
                                ? Icons.star
                                : Icons.star_border,
                            color: favorites.contains(key)
                                ? Colors.amber
                                : Colors.grey,
                          ),
                          onPressed: () => toggleFavorite(key),
                        ),
                      ],
                    ),
                  );
                }).toList(),
        );
      }).toList(),
    );
  }
}
