import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../services/token_service.dart';
import '../../utils/amount_converter.dart';
import '../../utils/time_converter.dart';

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
  bool isLoadingInitial = true;
  bool hasError = false;
  int currentOffset = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialTransfers();
  }

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
        displayedTransfers = response['transfersData'];
        currentOffset += itemsToLoad;
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
          _loadMoreTransfers();
        }
        return false;
      },
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Recent Transfers',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          displayedTransfers.isNotEmpty
              ? Column(
                  children: displayedTransfers.map<Widget>((transfer) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: _getRandomColor(), // Set a random vibrant color
                      child: ListTile(
                        title: Text(
                          'From: ${transfer['from']} To: ${transfer['to']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount: ${formatAmount(transfer['change_amount'])}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Signature: ${transfer['signature']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'Time: ${formatTime(transfer['time'])}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Color _getRandomColor() {
    // You can define your own vibrant color palette
    List<Color> colors = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.tealAccent,
    ];
    return colors[DateTime.now().millisecondsSinceEpoch % colors.length];
  }

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
        displayedTransfers.addAll(response['transfersData']);
        currentOffset += itemsToLoad;
        isLoadingMore = false;
      });
    } catch (error) {
      Logger logger = Logger();
      logger.e("Error loading more transfers: $error");
      setState(() {
        isLoadingMore = false;
        hasError = true;
      });
    }
  }
}
