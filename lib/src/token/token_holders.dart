import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../services/token_service.dart';

class TokenHolders extends StatefulWidget {
  final String contractAddress;

  const TokenHolders({super.key, required this.contractAddress});

  @override
  TokenHoldersState createState() => TokenHoldersState();
}

class TokenHoldersState extends State<TokenHolders> {
  List<dynamic> displayedHolders = [];
  int itemsToLoad = 10; // Number of items to load per request
  bool isLoadingMore = false;
  bool isLoadingInitial = true;
  bool hasError = false;
  int offset = 0; // Starting point for pagination
  int totalCount = 0; // Total number of records for pagination

  @override
  void initState() {
    super.initState();
    _fetchHolders();
  }

  Future<void> _fetchHolders() async {
    setState(() {
      isLoadingInitial = true;
      hasError = false;
    });

    try {
      final response = await TokenService()
          .fetchTokenHolders(widget.contractAddress, itemsToLoad, offset);
      final holdersData = response['holdersData'];
      totalCount = response['total']; // Get total count

      setState(() {
        displayedHolders.addAll(holdersData); // Append the new data
        isLoadingInitial = false;
      });
    } catch (error) {
      Logger logger = Logger();
      logger.e("Error fetching holders data: $error");
      setState(() {
        isLoadingInitial = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return const Center(child: Text('Error fetching holders data.'));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoadingMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadMoreHolders();
        }
        return false;
      },
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Holders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          displayedHolders.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: displayedHolders.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == displayedHolders.length && isLoadingMore) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    var holder = displayedHolders[index];
                    return ListTile(
                      title: Text(holder['account']),
                      subtitle: Text(
                          'Quantity: ${holder['quantity']}, Percentage: ${holder['percentage']}%'),
                    );
                  },
                )
              : const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No holders data available.'),
                ),
        ],
      ),
    );
  }

  // Load more holders when the user scrolls to the bottom
  void _loadMoreHolders() async {
    setState(() {
      isLoadingMore = true;
    });

    // Increase offset for pagination
    offset += itemsToLoad;

    try {
      final response = await TokenService()
          .fetchTokenHolders(widget.contractAddress, itemsToLoad, offset);
      final moreHoldersData = response['holdersData'];

      if (displayedHolders.length < totalCount) {
        // Check if there are still more holders to load
        if (moreHoldersData.isNotEmpty) {
          setState(() {
            displayedHolders.addAll(moreHoldersData);
            isLoadingMore = false;
          });
        } else {
          // No more data to load
          setState(() {
            isLoadingMore = false;
          });
        }
      } else {
        // Already fetched all holders
        setState(() {
          isLoadingMore = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoadingMore = false;
        hasError = true;
      });
    }
  }
}
