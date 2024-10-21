import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../services/token_service.dart';

class TokenTransfers extends StatefulWidget {
  final String contractAddress;

  const TokenTransfers({super.key, required this.contractAddress});

  @override
  TokenTransfersState createState() => TokenTransfersState();
}

class TokenTransfersState extends State<TokenTransfers> {
  List<dynamic> displayedTransfers = [];
  int itemsToLoad = 10;
  bool isLoadingMore = false;
  bool isLoadingInitial = true; // To track initial loading
  bool hasError = false; // To track any errors
  int currentOffset = 0; // To track the current offset

  @override
  void initState() {
    super.initState();
    _loadInitialTransfers(); // Load initial transfers
  }

  // Load initial transfers from the API
  Future<void> _loadInitialTransfers() async {
    setState(() {
      isLoadingInitial = true;
      hasError = false;
    });

    final tokenService = TokenService();

    try {
      final Map<String, dynamic> response =
          await tokenService.fetchTokenTransfers(
              widget.contractAddress, itemsToLoad, currentOffset);

      setState(() {
        displayedTransfers = response[
            'transfersData']; // Assuming 'transfersData' is the key in your API response
        currentOffset += itemsToLoad; // Update the offset for next loading
        isLoadingInitial = false;
      });
    } catch (error) {
      Logger logger = Logger();
      logger.e("Error loading initial transfers: $error");
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
      return const Center(child: Text('Error loading transfers data.'));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoadingMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadMoreTransfers(); // Load more transfers when scrolled to the bottom
        }
        return false;
      },
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recent Transfers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          displayedTransfers.isNotEmpty
              ? Column(
                  children: displayedTransfers.map<Widget>((transfer) {
                    return ListTile(
                      title: Text(
                          'From: ${transfer['from']} To: ${transfer['to']}'),
                      subtitle: Text(
                          'Amount: ${transfer['amount']} Date: ${transfer['date']}'),
                    );
                  }).toList(),
                )
              : const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No recent transfers available.'),
                ),
          if (isLoadingMore)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // Load more transfers when the user scrolls to the bottom
  void _loadMoreTransfers() async {
    setState(() {
      isLoadingMore = true;
    });

    try {
      final tokenService = TokenService();
      final Map<String, dynamic> response =
          await tokenService.fetchTokenTransfers(
              widget.contractAddress, itemsToLoad, currentOffset);

      setState(() {
        displayedTransfers
            .addAll(response['transfersData']); // Add new transfers
        currentOffset += itemsToLoad; // Update the offset for next loading
        isLoadingMore = false;
      });
    } catch (error) {
      Logger logger = Logger();
      logger.e("Error loading more transfers: $error");
      setState(() {
        isLoadingMore = false;
        hasError = true; // Set error state if loading fails
      });
    }
  }
}
