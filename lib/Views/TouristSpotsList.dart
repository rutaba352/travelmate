import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/EmptyState.dart';
import 'package:travelmate/Utilities/LoadingIndicator.dart';
import 'package:travelmate/Views/MapView.dart';

class TouristSpotsList extends StatefulWidget {
  final String? cityName;
  final String? countryName;

  const TouristSpotsList({
    Key? key,
    this.cityName,
    this.countryName,
  }) : super(key: key);

  @override
  State<TouristSpotsList> createState() => _TouristSpotsListState();
}

class _TouristSpotsListState extends State<TouristSpotsList> {
  late TextEditingController _searchController;
  String selectedCategory = 'All';
  bool _isLoading = false;
  String _sortBy = 'Popular';

  final List<String> categories = [
    'All',
    'Historical',
    'Religious',
    'Adventure',
    'Cultural',
    'Nature',
    'Shopping',
    'Beach'
  ];

  final List<String> sortOptions = ['Popular', 'Rating', 'Distance', 'Price'];

  final List<Map<String, dynamic>> touristSpots = [
    // ===== PAKISTAN DESTINATIONS =====

    // Hunza Valley
    {
      'name': 'Attabad Lake',
      'location': 'Hunza Valley, Pakistan',
      'image': 'assets/images/tourist_spots/shangrilla.jpeg',
      'category': 'Nature',
      'rating': '4.9',
      'reviews': 3200,
      'description': 'Turquoise lake formed after earthquake with stunning mountain backdrop',
      'entryFee': 'PKR 500',
      'distance': 'From Hunza: 20 km',
      'openTime': '24/7',
      'isSaved': false,
    },
    {
      'name': 'Baltit Fort',
      'location': 'Hunza Valley, Pakistan',
      'image': 'assets/images/tourist_spots/baltit_fort.jpeg',
      'category': 'Historical',
      'rating': '4.7',
      'reviews': 2100,
      'description': 'Ancient fort with panoramic views of Hunza Valley',
      'entryFee': 'PKR 800',
      'distance': 'From Hunza: 2 km',
      'openTime': '9:00 AM - 5:00 PM',
      'isSaved': false,
    },

    // Skardu
    {
      'name': 'Shangrila Resort',
      'location': 'Skardu, Pakistan',
      'image': 'assets/images/tourist_spots/shangrilla.jpeg',
      'category': 'Nature',
      'rating': '4.8',
      'reviews': 2800,
      'description': 'Beautiful resort complex with Lower Kachura Lake',
      'entryFee': 'PKR 1000',
      'distance': 'From Skardu: 15 km',
      'openTime': '8:00 AM - 10:00 PM',
      'isSaved': false,
    },
    {
      'name': 'Deosai Plains',
      'location': 'Skardu, Pakistan',
      'image': 'assets/images/tourist_spots/deosai.jpeg',
      'category': 'Adventure',
      'rating': '4.9',
      'reviews': 1900,
      'description': 'Second highest plateau in the world, summer habitat of Himalayan brown bears',
      'entryFee': 'PKR 500',
      'distance': 'From Skardu: 30 km',
      'openTime': '6:00 AM - 6:00 PM',
      'isSaved': false,
    },

    // Swat Valley
    {
      'name': 'Mahodand Lake',
      'location': 'Swat Valley, Pakistan',
      'image': 'assets/images/tourist_spots/mohmand.jpeg',
      'category': 'Nature',
      'rating': '4.7',
      'reviews': 2500,
      'description': 'Alpine lake surrounded by pine forests and mountains',
      'entryFee': 'PKR 400',
      'distance': 'From Kalam: 40 km',
      'openTime': '6:00 AM - 5:00 PM',
      'isSaved': false,
    },
    {
      'name': 'Malam Jabba',
      'location': 'Swat Valley, Pakistan',
      'image': 'assets/images/tourist_spots/malam_jabba.jpeg',
      'category': 'Adventure',
      'rating': '4.5',
      'reviews': 1800,
      'description': 'Only ski resort in Pakistan with chairlifts and snow activities',
      'entryFee': 'PKR 1200',
      'distance': 'From Mingora: 40 km',
      'openTime': '8:00 AM - 6:00 PM',
      'isSaved': false,
    },

    // Fairy Meadows
    {
      'name': 'Nanga Parbat Viewpoint',
      'location': 'Fairy Meadows, Pakistan',
      'image': 'assets/images/tourist_spots/viewpoint.jpeg',
      'category': 'Adventure',
      'rating': '4.9',
      'reviews': 1500,
      'description': 'Closest view of Nanga Parbat, the killer mountain',
      'entryFee': 'PKR 500',
      'distance': 'From Fairy Meadows: 3 km trek',
      'openTime': '24/7',
      'isSaved': false,
    },
    {
      'name': 'Beyal Camp',
      'location': 'Fairy Meadows, Pakistan',
      'image': 'assets/images/tourist_spots/beyal_camp.jpeg',
      'category': 'Adventure',
      'rating': '4.6',
      'reviews': 1200,
      'description': 'Base camp for trekkers with amazing mountain views',
      'entryFee': 'PKR 300',
      'distance': 'From Fairy Meadows: 5 km',
      'openTime': '24/7',
      'isSaved': false,
    },

    // Naran Kaghan
    {
      'name': 'Lake Saif-ul-Malook',
      'location': 'Naran, Pakistan',
      'image': 'assets/images/tourist_spots/saiful_malook.jpeg',
      'category': 'Nature',
      'rating': '4.8',
      'reviews': 3500,
      'description': 'High-altitude alpine lake with crystal clear waters and legend',
      'entryFee': 'PKR 600',
      'distance': 'From Naran: 9 km',
      'openTime': '7:00 AM - 5:00 PM',
      'isSaved': false,
    },
    {
      'name': 'Babusar Pass',
      'location': 'Naran, Pakistan',
      'image': 'assets/images/tourist_spots/babusar.jpeg',
      'category': 'Adventure',
      'rating': '4.7',
      'reviews': 2200,
      'description': 'Highest point on Naran-Chilas road with breathtaking views',
      'entryFee': 'Free',
      'distance': 'From Naran: 60 km',
      'openTime': '24/7 (May-Oct only)',
      'isSaved': false,
    },

    // Lahore
    {
      'name': 'Badshahi Mosque',
      'location': 'Lahore, Pakistan',
      'image': 'assets/images/tourist_spots/mosque.jpeg',
      'category': 'Historical',
      'rating': '4.8',
      'reviews': 4200,
      'description': 'One of the largest mosques in the world, Mughal architecture',
      'entryFee': 'PKR 500',
      'distance': 'From Lahore Center: 3 km',
      'openTime': '8:00 AM - 8:00 PM',
      'isSaved': false,
    },
    {
      'name': 'Lahore Fort',
      'location': 'Lahore, Pakistan',
      'image': 'assets/images/tourist_spots/lahore_fort.jpeg',
      'category': 'Historical',
      'rating': '4.7',
      'reviews': 3800,
      'description': 'UNESCO World Heritage Site, Mughal and Sikh architecture',
      'entryFee': 'PKR 500',
      'distance': 'From Lahore Center: 3.5 km',
      'openTime': '8:30 AM - 5:00 PM',
      'isSaved': false,
    },

    // Murree
    {
      'name': 'Mall Road',
      'location': 'Murree, Pakistan',
      'image': 'assets/images/tourist_spots/mall_road.jpeg',
      'category': 'Shopping',
      'rating': '4.3',
      'reviews': 3200,
      'description': 'Famous shopping street with colonial-era buildings and views',
      'entryFee': 'Free',
      'distance': 'From Murree Center: 0 km',
      'openTime': '24/7',
      'isSaved': false,
    },
    {
      'name': 'Patriata Chairlift',
      'location': 'Murree, Pakistan',
      'image': 'assets/images/tourist_spots/patriata.jpeg',
      'category': 'Adventure',
      'rating': '4.5',
      'reviews': 2800,
      'description': 'Chairlift ride offering panoramic views of mountains',
      'entryFee': 'PKR 800',
      'distance': 'From Murree: 15 km',
      'openTime': '9:00 AM - 5:00 PM',
      'isSaved': false,
    },

    // Mohenjo-daro
    {
      'name': 'Mohenjo-daro Ruins',
      'location': 'Mohenjo-daro, Pakistan',
      'image': 'assets/images/tourist_spots/museum.jpeg',
      'category': 'Historical',
      'rating': '4.6',
      'reviews': 1800,
      'description': 'Archaeological site of ancient Indus Valley Civilization',
      'entryFee': 'PKR 300',
      'distance': 'From Larkana: 30 km',
      'openTime': '8:30 AM - 5:30 PM',
      'isSaved': false,
    },
    {
      'name': 'Mohenjo-daro Museum',
      'location': 'Mohenjo-daro, Pakistan',
      'image': 'assets/images/mohenjo_daro.jpg',
      'category': 'Cultural',
      'rating': '4.4',
      'reviews': 1200,
      'description': 'Museum showcasing artifacts from Indus Valley Civilization',
      'entryFee': 'PKR 200',
      'distance': 'Within Mohenjo-daro site',
      'openTime': '9:00 AM - 4:00 PM',
      'isSaved': false,
    },

    // Karachi
    {
      'name': 'Clifton Beach',
      'location': 'Karachi, Pakistan',
      'image': 'assets/images/tourist_spots/clifton.jpeg',
      'category': 'Beach',
      'rating': '4.3',
      'reviews': 4500,
      'description': 'Popular beach for camel rides, horse rides, and sunset views',
      'entryFee': 'Free',
      'distance': 'From Karachi Center: 8 km',
      'openTime': '24/7',
      'isSaved': false,
    },
    {
      'name': 'Mohatta Palace',
      'location': 'Karachi, Pakistan',
      'image': 'assets/images/tourist_spots/mohatta.jpeg',
      'category': 'Cultural',
      'rating': '4.5',
      'reviews': 2100,
      'description': 'Palace turned museum with beautiful architecture and art exhibitions',
      'entryFee': 'PKR 300',
      'distance': 'From Karachi Center: 12 km',
      'openTime': '11:00 AM - 6:00 PM',
      'isSaved': false,
    },

    // Neelum Valley
    {
      'name': 'Sharda Peeth',
      'location': 'Neelum Valley, Pakistan',
      'image': 'assets/images/tourist_spots/sharda.jpeg',
      'category': 'Historical',
      'rating': '4.7',
      'reviews': 1600,
      'description': 'Ancient Hindu temple and Buddhist learning center ruins',
      'entryFee': 'Free',
      'distance': 'From Athmuqam: 40 km',
      'openTime': '24/7',
      'isSaved': false,
    },
    {
      'name': 'Ratti Gali Lake',
      'location': 'Neelum Valley, Pakistan',
      'image': 'assets/images/tourist_spots/ratti_gali.jpeg',
      'category': 'Nature',
      'rating': '4.8',
      'reviews': 1400,
      'description': 'High-altitude glacial lake with emerald green waters',
      'entryFee': 'PKR 500',
      'distance': 'From Dowarian: 16 km trek',
      'openTime': '6:00 AM - 4:00 PM',
      'isSaved': false,
    },

    // ===== INTERNATIONAL DESTINATIONS =====

    // Maldives
    {
      'name': 'Artificial Beach',
      'location': 'Malé, Maldives',
      'image': 'assets/images/tourist_spots/male_beach.jpeg',
      'category': 'Beach',
      'rating': '4.8',
      'reviews': 3800,
      'description': 'Popular public beach with white sand and clear waters',
      'entryFee': 'Free',
      'distance': 'From Malé: 2 km',
      'openTime': '24/7',
      'isSaved': false,
    },
    {
      'name': 'National Museum',
      'location': 'Malé, Maldives',
      'image': 'assets/images/tourist_spots/male_museum.jpeg',
      'category': 'Cultural',
      'rating': '4.5',
      'reviews': 2100,
      'description': 'Showcasing Maldivian history and cultural artifacts',
      'entryFee': 'MVR 100',
      'distance': 'From Malé Center: 1 km',
      'openTime': '9:00 AM - 5:00 PM',
      'isSaved': false,
    },

    // Dubai
    {
      'name': 'Burj Khalifa',
      'location': 'Dubai, UAE',
      'image': 'assets/images/tourist_spots/burj_khalifa.jpeg',
      'category': 'Adventure',
      'rating': '4.9',
      'reviews': 5200,
      'description': 'World\'s tallest building with observation decks',
      'entryFee': 'AED 149',
      'distance': 'From Dubai Center: 10 km',
      'openTime': '8:30 AM - 11:00 PM',
      'isSaved': false,
    },
    {
      'name': 'Dubai Mall',
      'location': 'Dubai, UAE',
      'image': 'assets/images/tourist_spots/dubai_mall.jpeg',
      'category': 'Shopping',
      'rating': '4.8',
      'reviews': 4800,
      'description': 'World\'s largest shopping mall with aquarium and fountain shows',
      'entryFee': 'Free',
      'distance': 'From Dubai Center: 12 km',
      'openTime': '10:00 AM - 12:00 AM',
      'isSaved': false,
    },

    // Istanbul
    {
      'name': 'Hagia Sophia',
      'location': 'Istanbul, Turkey',
      'image': 'assets/images/tourist_spots/hajia_sophia.jpeg',
      'category': 'Historical',
      'rating': '4.9',
      'reviews': 4500,
      'description': 'Architectural marvel, former church and mosque',
      'entryFee': '₺450',
      'distance': 'From Sultanahmet: 0 km',
      'openTime': '9:00 AM - 7:30 PM',
      'isSaved': false,
    },
    {
      'name': 'Grand Bazaar',
      'location': 'Istanbul, Turkey',
      'image': 'assets/images/tourist_spots/grand_bazar.jpeg',
      'category': 'Shopping',
      'rating': '4.7',
      'reviews': 3900,
      'description': 'One of the world\'s oldest and largest covered markets',
      'entryFee': 'Free',
      'distance': 'From Sultanahmet: 1.5 km',
      'openTime': '8:30 AM - 7:00 PM',
      'isSaved': false,
    },

    // Bangkok
    {
      'name': 'Wat Arun',
      'location': 'Bangkok, Thailand',
      'image': 'assets/images/tourist_spots/wat_arun.jpeg',
      'category': 'Religious',
      'rating': '4.7',
      'reviews': 3200,
      'description': 'Temple of Dawn with stunning porcelain decoration',
      'entryFee': '฿100',
      'distance': 'From Bangkok Center: 5 km',
      'openTime': '8:00 AM - 6:00 PM',
      'isSaved': false,
    },
    {
      'name': 'Chatuchak Market',
      'location': 'Bangkok, Thailand',
      'image': 'assets/images/tourist_spots/chatuchak.jpeg',
      'category': 'Shopping',
      'rating': '4.6',
      'reviews': 2800,
      'description': 'World\'s largest weekend market with 15,000 stalls',
      'entryFee': 'Free',
      'distance': 'From Bangkok Center: 10 km',
      'openTime': '9:00 AM - 6:00 PM',
      'isSaved': false,
    },

    // Bali
    {
      'name': 'Tanah Lot',
      'location': 'Bali, Indonesia',
      'image': 'assets/images/tourist_spots/tanah_lot.jpeg',
      'category': 'Religious',
      'rating': '4.8',
      'reviews': 4100,
      'description': 'Ancient Hindu temple on rocky island with sunset views',
      'entryFee': 'Rp 60,000',
      'distance': 'From Denpasar: 20 km',
      'openTime': '7:00 AM - 7:00 PM',
      'isSaved': false,
    },
    {
      'name': 'Ubud Monkey Forest',
      'location': 'Bali, Indonesia',
      'image': 'assets/images/tourist_spots/ubud_money_forest.jpeg',
      'category': 'Nature',
      'rating': '4.6',
      'reviews': 3500,
      'description': 'Sacred monkey sanctuary in lush forest',
      'entryFee': 'Rp 80,000',
      'distance': 'From Ubud: 2 km',
      'openTime': '9:00 AM - 6:00 PM',
      'isSaved': false,
    },

    // Paris
    {
      'name': 'Eiffel Tower',
      'location': 'Paris, France',
      'image': 'assets/images/tourist_spots/eiffel_tower.jpeg',
      'category': 'Historical',
      'rating': '4.8',
      'reviews': 12500,
      'description': 'Iconic iron lattice tower and symbol of Paris',
      'entryFee': '\$25',
      'distance': 'From Paris Center: 2.5 km',
      'openTime': '9:00 AM - 11:00 PM',
      'isSaved': false,
    },
    {
      'name': 'Louvre Museum',
      'location': 'Paris, France',
      'image': 'assets/images/tourist_spots/louvre_museum.jpeg',
      'category': 'Cultural',
      'rating': '4.9',
      'reviews': 18700,
      'description': 'World\'s largest art museum and historic monument',
      'entryFee': '\$20',
      'distance': 'From Paris Center: 3.2 km',
      'openTime': '9:00 AM - 6:00 PM',
      'isSaved': true,
    },

    // Swiss Alps
    {
      'name': 'Jungfraujoch',
      'location': 'Swiss Alps, Switzerland',
      'image': 'assets/images/tourist_spots/jungfrau.jpeg',
      'category': 'Adventure',
      'rating': '4.9',
      'reviews': 3800,
      'description': 'Top of Europe - highest railway station in Europe',
      'entryFee': 'CHF 210',
      'distance': 'From Interlaken: 40 km',
      'openTime': '8:00 AM - 4:00 PM',
      'isSaved': false,
    },
    {
      'name': 'Matterhorn Glacier Paradise',
      'location': 'Swiss Alps, Switzerland',
      'image': 'assets/images/tourist_spots/matterhorn.jpeg',
      'category': 'Adventure',
      'rating': '4.8',
      'reviews': 3200,
      'description': 'Highest cable car station in Europe with glacier palace',
      'entryFee': 'CHF 95',
      'distance': 'From Zermatt: 15 km',
      'openTime': '8:30 AM - 4:30 PM',
      'isSaved': false,
    },

    // Santorini
    {
      'name': 'Oia Sunset Viewpoint',
      'location': 'Santorini, Greece',
      'image': 'assets/images/tourist_spots/oia_sunset.jpeg',
      'category': 'Nature',
      'rating': '4.9',
      'reviews': 4500,
      'description': 'Most famous sunset spot with white and blue architecture',
      'entryFee': 'Free',
      'distance': 'From Fira: 12 km',
      'openTime': '24/7',
      'isSaved': false,
    },
    {
      'name': 'Red Beach',
      'location': 'Santorini, Greece',
      'image': 'assets/images/tourist_spots/red_beach.jpeg',
      'category': 'Beach',
      'rating': '4.7',
      'reviews': 2900,
      'description': 'Unique beach with red volcanic cliffs and sand',
      'entryFee': 'Free',
      'distance': 'From Fira: 12 km',
      'openTime': '24/7',
      'isSaved': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadSpots();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSpots() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get filteredSpots {
    List<Map<String, dynamic>> filtered = touristSpots;

    if (selectedCategory != 'All') {
      filtered = filtered
          .where((spot) => spot['category'] == selectedCategory)
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((spot) =>
      spot['name']
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()) ||
          spot['description']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  Future<void> _refreshSpots() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      SnackbarHelper.showSuccess(context, 'Tourist spots refreshed!');
    }
  }

  void _toggleSave(int index) {
    setState(() {
      touristSpots[index]['isSaved'] = !touristSpots[index]['isSaved'];
    });
    SnackbarHelper.showSuccess(
      context,
      touristSpots[index]['isSaved']
          ? '${touristSpots[index]['name']} saved!'
          : '${touristSpots[index]['name']} removed from saved',
    );
  }

  void _viewSpotDetails(Map<String, dynamic> spot) {
    // Show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(spot['name']),
        content: Text('${spot['description']}\n\nEntry Fee: ${spot['entryFee']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263238),
                ),
              ),
              const SizedBox(height: 20),
              ...sortOptions.map((option) {
                return ListTile(
                  title: Text(option),
                  leading: Radio<String>(
                    value: option,
                    groupValue: _sortBy,
                    activeColor: const Color(0xFF00897B),
                    onChanged: (value) {
                      setState(() => _sortBy = value!);
                      Navigator.pop(context);
                      SnackbarHelper.showSuccess(
                        context,
                        'Sorted by $option',
                      );
                    },
                  ),
                  onTap: () {
                    setState(() => _sortBy = option);
                    Navigator.pop(context);
                    SnackbarHelper.showSuccess(context, 'Sorted by $option');
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName ?? 'Tourist Spots'),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortDialog,
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapView(
                    tripTitle: widget.cityName ?? 'Tourist Spots',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSpots,
        color: const Color(0xFF00897B),
        child: Column(
          children: [
            Container(
              color: const Color(0xFF00897B),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search tourist spots...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter by Category',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF263238),
                        ),
                      ),
                      Text(
                        '${filteredSpots.length} spots found',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category == selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            backgroundColor: Colors.grey[100],
                            selectedColor:
                            const Color(0xFF00897B).withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF00897B)
                                  : Colors.grey[700],
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF00897B)
                                  : Colors.grey[300]!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  SnackbarHelper.showSuccess(context, 'Tourist spots catalog loaded!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.travel_explore, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'View Complete Catalog',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: const ShimmerLoader(
                      width: double.infinity,
                      height: 140,
                    ),
                  );
                },
              )
                  : filteredSpots.isEmpty
                  ? EmptyState(
                icon: Icons.explore_off,
                title: 'No Spots Found',
                message:
                'Try adjusting your filters or search terms',
                buttonText: 'Clear Filters',
                onButtonPressed: () {
                  setState(() {
                    selectedCategory = 'All';
                    _searchController.clear();
                  });
                },
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredSpots.length,
                itemBuilder: (context, index) {
                  final spot = filteredSpots[index];
                  return GestureDetector(
                    onTap: () => _viewSpotDetails(spot),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 200, // Fixed height for all images
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(spot['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00897B)
                                        .withOpacity(0.9),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    spot['category'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    icon: Icon(
                                      spot['isSaved']
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      size: 18,
                                    ),
                                    color: spot['isSaved']
                                        ? const Color(0xFF00897B)
                                        : Colors.grey[600],
                                    onPressed: () =>
                                        _toggleSave(touristSpots
                                            .indexOf(spot)),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        spot['name'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF263238),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber[50],
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 14,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            spot['rating'],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  spot['description'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        spot['distance'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      spot['openTime'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.people_outline,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${spot['reviews']} reviews',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      spot['entryFee'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF00897B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}