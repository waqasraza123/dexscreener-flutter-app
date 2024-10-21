import 'package:flutter/material.dart';
import 'transfer_card.dart';

class TransferList extends StatelessWidget {
  final List<dynamic> transfers;
  final Color Function() getRandomColor;
  final bool isLoadingMore;

  const TransferList({
    super.key,
    required this.transfers,
    required this.getRandomColor,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: transfers.map<Widget>((transfer) {
        return TransferCard(
          transfer: transfer,
          cardColor: getRandomColor(),
        );
      }).toList(),
    );
  }
}
