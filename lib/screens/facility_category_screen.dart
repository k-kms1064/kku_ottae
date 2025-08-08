import 'package:flutter/material.dart';
import 'facility/facility_restaurant_screen.dart';
import 'facility/facility_cafe_screen.dart';
import 'facility/facility_bar_screen.dart';
import 'facility/facility_mart_screen.dart';
import 'facility/facility_etc_screen.dart';
import 'facility/facility_Pc_screen.dart';

class FacilityCategoryScreen extends StatelessWidget {
  final Set<String> favorites;
  final void Function(String) toggleFavorite;

  const FacilityCategoryScreen({
    super.key,
    required this.favorites,
    required this.toggleFavorite,
  });

  final List<_Category> categories = const [
    _Category(name: '식당', emoji: '🍽️'),
    _Category(name: '카페', emoji: '☕'),
    _Category(name: '술집', emoji: '🍻'),
    _Category(name: '편의점/마트', emoji: '🛒'),
    _Category(name: '기타 생활시설', emoji: '🛠️'),
    _Category(name: '오락시설', emoji: '🎮'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00552E),
      appBar: AppBar(
        title: const Text(
          '편의시설 카테고리',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00552E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 140,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return GestureDetector(
              onTap: () {
                // 🔁 카테고리별 분기처리
                switch (category.name) {
                  case '식당':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FacilityRestaurantScreen(
                          favorites: favorites,
                          toggleFavorite: toggleFavorite,
                        ),
                      ),
                    );
                    break;
                  case '카페':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FacilityCafeScreen(
                          favorites: favorites,
                          toggleFavorite: toggleFavorite,
                        ),
                      ),
                    );
                    break;
                  case '술집':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FacilityBarScreen(
                          favorites: favorites,
                          toggleFavorite: toggleFavorite,
                        ),
                      ),
                    );
                    break;
                  case '편의점/마트':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FacilityMartScreen(
                          favorites: favorites,
                          toggleFavorite: toggleFavorite,
                        ),
                      ),
                    );
                    break;
                  case '오락시설':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FacilityPcScreen(
                          favorites: favorites,
                          toggleFavorite: toggleFavorite,
                        ),
                      ),
                    );
                    break;
                  case '기타 생활시설':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FacilityEtcScreen(
                          favorites: favorites,
                          toggleFavorite: toggleFavorite,
                        ),
                      ),
                    );
                    break;
                  default:
                    // 혹시 대비
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${category.name} 화면이 없습니다.')),
                    );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(category.emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 10),
                    Text(
                      category.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Category {
  final String name;
  final String emoji;

  const _Category({required this.name, required this.emoji});
}