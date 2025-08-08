import 'package:flutter/material.dart';

class FacilityPcScreen extends StatefulWidget {
  final Set<String> favorites;
  final void Function(String) toggleFavorite;

  const FacilityPcScreen({
    super.key,
    required this.favorites,
    required this.toggleFavorite,
  });

  @override
  State<FacilityPcScreen> createState() => _FacilityPcScreenState();
}

class _FacilityPcScreenState extends State<FacilityPcScreen> {
  final Map<String, List<Map<String, String>>> groupedData = const {
    'PC방': [
      {
        'name': '늘PC',
        'location': '충북 충주시 충열5길 12 2층 늘PC방',
      },
      {
        'name': '팝콘피씨카페 1호점',
        'location': '충북 충주시 충열1길 34',
      },
      {
        'name': '팝콘피씨카페키친 2호점',
        'location': '충북 충주시 충열5길 22 지하',
      },
      {
        'name': '싸이버피시방 단월점',
        'location': '충북 충주시 충열4길 9-2',
      },
    ],
    '노래방': [
      {
        'name': '마이꼴밴드노래연습장',
        'location': '충북 충주시 충열5길 22 테마빌 지하1층 B호',
      },
      {
        'name': '팝콘코인노래연습장',
        'location': '충북 충주시 충원대로 206',
      },
      {
        'name': '아지트노래방',
        'location': '충북 충주시 충열5길 16',
      },
    ],
    '당구장': [
      {
        'name': '신촌당구타운',
        'location': '충북 충주시 충열5길 16-1',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '오락시설',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00552E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: groupedData.entries.map((entry) {
          final category = entry.key;
          final places = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00552E),
                ),
              ),
              const SizedBox(height: 8),
              ...places.map((place) {
                final itemKey = 'restaurant-${place['name']}|편의점/마트|${place['location']}';
                final isFavorited = widget.favorites.any((f) => f.startsWith('restaurant-${place['name']}|'));

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              place['name']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                           IconButton(
                              icon: Icon(
                                isFavorited ? Icons.star : Icons.star_border,
                                color: Colors.orange,
                              ),
                              onPressed: () => widget.toggleFavorite(itemKey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              place['location']!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 24),
            ],
          );
        }).toList(),
      ),
    );
  }
}
