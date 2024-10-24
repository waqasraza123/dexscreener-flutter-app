import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../services/token_service.dart';
import '../../utils/amount_converter.dart'; // Import the converter utility

class TokenHolders extends StatefulWidget {
  final String contractAddress;

  const TokenHolders({super.key, required this.contractAddress});

  @override
  TokenHoldersState createState() => TokenHoldersState();
}

class TokenHoldersState extends State<TokenHolders>
    with TickerProviderStateMixin {
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
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Holders',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 16),
            displayedHolders.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        displayedHolders.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == displayedHolders.length && isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      var holder = displayedHolders[index];
                      return _buildHolderCard(holder);
                    },
                  )
                : const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No holders data available.',
                        style: TextStyle(color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHolderCard(Map<String, dynamic> holder) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            holder['account'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Quantity: ${formatAmount(holder['quantity'])}', // Use the converter
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            'Percentage: ${holder['percentage']}%',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
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
