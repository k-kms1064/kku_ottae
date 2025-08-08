import 'package:flutter/material.dart';

import 'restaurant/restaurant_korea_screen.dart';
import 'restaurant/restaurant_china_screen.dart';
import 'restaurant/restaurant_japan_screen.dart';
import 'restaurant/restaurant_chicken_screen.dart';
import 'restaurant/restaurant_meat_screen.dart';

class _Subcategory {
  final String name;
  final String emoji;

  const _Subcategory({required this.name, required this.emoji});
}

class FacilityRestaurantScreen extends StatefulWidget {
  final Set<String> favorites;
  final void Function(String) toggleFavorite;

  const FacilityRestaurantScreen({
    super.key,
    required this.favorites,
    required this.toggleFavorite,
  });

  @override
  State<FacilityRestaurantScreen> createState() => _FacilityRestaurantScreenState();
}

class _FacilityRestaurantScreenState extends State<FacilityRestaurantScreen> {
  static const List<_Subcategory> subcategories = [
    _Subcategory(name: '한식', emoji: '🍚'),
    _Subcategory(name: '중식', emoji: '🍜'),
    _Subcategory(name: '일식, 아시안', emoji: '🍱'),
    _Subcategory(name: '치킨·피자·햄버거·토스트', emoji: '🍗'),
    _Subcategory(name: '족발/보쌈/고기/꼬치', emoji: '🍢'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00552E),
      appBar: AppBar(
        title: const Text(
          '식당 소분류',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00552E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: subcategories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 130,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final sub = subcategories[index];

            return GestureDetector(
              onTap: () {
                switch (sub.name) {
                  case '한식':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestaurantKoreaScreen(
                          favorites: widget.favorites,
                          toggleFavorite: widget.toggleFavorite,
                        ),
                      ),
                    );
                    break;
                  case '중식':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestaurantChinaScreen(
                          favorites: widget.favorites,
                          toggleFavorite: widget.toggleFavorite,
                        ),
                      ),
                    );
                    break;
                  case '일식, 아시안':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestaurantJapanScreen(
                          favorites: widget.favorites,
                          toggleFavorite: widget.toggleFavorite,
                        ),
                      ),
                    );
                    break;
                  case '치킨·피자·햄버거·토스트':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestaurantChickenScreen(
                          favorites: widget.favorites,
                          toggleFavorite: widget.toggleFavorite,
                        ),
                      ),
                    );
                    break;
                  case '족발/보쌈/고기/꼬치':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestaurantMeatScreen(
                          favorites: widget.favorites,
                          toggleFavorite: widget.toggleFavorite,
                        ),
                      ),
                    );
                    break;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(sub.emoji, style: const TextStyle(fontSize: 30)),
                    const SizedBox(height: 10),
                    Text(
                      sub.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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
