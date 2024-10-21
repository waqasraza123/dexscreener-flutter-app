import 'package:flutter/material.dart';
import '../../services/token_service.dart';
import '../token/token_transfers/token_transfer_loader.dart';
import './token_transfers/transfer_list.dart';

class TokenTransfers extends StatefulWidget {
  final String contractAddress;

  const TokenTransfers({super.key, required this.contractAddress});

  @override
  TokenTransfersState createState() => TokenTransfersState();
}

class TokenTransfersState extends State<TokenTransfers> {
  List<dynamic> displayedTransfers = [];
  bool isLoadingInitial = true;
  bool hasError = false;
  late TokenTransferLoader transferLoader; // Use TokenTransferLoader

  @override
  void initState() {
    super.initState();
    transferLoader = TokenTransferLoader(
        tokenService: TokenService(), contractAddress: widget.contractAddress);
    _loadInitialTransfers();
  }

  Future<void> _loadInitialTransfers() async {
    setState(() {
      isLoadingInitial = true;
      hasError = false;
    });

    try {
      displayedTransfers = await transferLoader.loadInitialTransfers();
      setState(() {
        isLoadingInitial = false;
      });
    } catch (error) {
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
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
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
              ? TransferList(
                  transfers: displayedTransfers,
                  getRandomColor: _getRandomColor,
                  isLoadingMore: transferLoader.pagination.isLoadingMore,
                )
              : const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No recent transfers available.'),
                ),
          if (transferLoader.pagination.isLoadingMore)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Color _getRandomColor() {
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
    final newTransfers = await transferLoader.loadMoreTransfers();
    setState(() {
      displayedTransfers.addAll(newTransfers);
    });
  }
}
