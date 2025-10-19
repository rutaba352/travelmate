import 'package:flutter/material.dart';
import 'package:travelmate/Utilities/Widgets.dart';
import 'package:travelmate/Utilities/SnackbarHelper.dart';
import 'package:travelmate/Utilities/LoadingIndicator.dart';
import 'package:travelmate/Utilities/EmptyState.dart';
import 'package:travelmate/Views/SearchResults.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late TextEditingController startLocationController;
  late TextEditingController destinationController;
  bool isLoading = false;
  bool hasError = false;
  bool showEmptyState = false;

  @override
  void initState() {
    super.initState();
    startLocationController = TextEditingController();
    destinationController = TextEditingController();
    _loadInitialData();

    // Reset loading when returning to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = false;
        });
      }
    });
  }

  @override
  void dispose() {
    startLocationController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      bool simulateError = false;

      if (simulateError) {
        throw Exception('Failed to load data');
      }

      setState(() {
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      if (mounted) {
        SnackbarHelper.showError(
          context,
          'Failed to load destinations',
          onRetry: _loadInitialData,
        );
      }
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      SnackbarHelper.showSuccess(context, 'Data refreshed successfully!');
    }
  }

  void _performSearch() {
    if (startLocationController.text.isEmpty ||
        destinationController.text.isEmpty) {
      SnackbarHelper.showWarning(
        context,
        'Please enter both start location and destination',
      );
      return;
    }

    // Navigate to SearchResults screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResults(
          startLocation: startLocationController.text,
          destination: destinationController.text,
          query: '${startLocationController.text} to ${destinationController.text}',
        ),
      ),
    ).then((_) {
      // Reset loading state when returning
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: const Color(0xFF00897B),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(),
                      const SizedBox(height: 30),
                      buildSearchSection(
                        startLocationController,
                        destinationController,
                        onSearch: _performSearch,
                      ),
                      const SizedBox(height: 30),
                      if (isLoading)
                        Column(
                          children: [
                            const Text(
                              'Popular Destinations',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF263238),
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 180,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, index) =>
                                    const DestinationCardSkeleton(),
                              ),
                            ),
                          ],
                        )
                      else if (hasError)
                        EmptyState(
                          icon: Icons.error_outline,
                          title: 'Oops! Something went wrong',
                          message:
                              'We couldn\'t load the destinations. Please try again.',
                          buttonText: 'Retry',
                          onButtonPressed: _loadInitialData,
                        )
                      else if (showEmptyState)
                        EmptyState(
                          icon: Icons.explore_off,
                          title: 'No Destinations Found',
                          message:
                              'Start exploring by searching for your dream destination!',
                          buttonText: 'Explore Now',
                          onButtonPressed: () {
                            SnackbarHelper.showInfo(
                                context, 'Opening explore page...');
                          },
                        )
                      else
                        Column(
                          children: [
                            buildPopularDestinations(),
                            const SizedBox(height: 30),
                            buildQuickActions(context),
                            const SizedBox(height: 30),
                            buildRecentSearches(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading) const FullScreenLoader(message: 'Loading...'),
        ],
      ),
    );
  }
}