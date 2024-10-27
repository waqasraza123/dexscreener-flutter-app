import 'package:flutter/material.dart';
import '../candlestick_chart/candlestick_chart.dart';
import '../candlestick_chart/data/candlestick_data.dart';
import 'package:logger/logger.dart';
import './chat/token_messages_screen.dart';
import './token/token_holders.dart';
import './token/token_transfers.dart';
import './token/token_overview.dart';
import '../utils/colors.dart';

class SingleTokenScreen extends StatefulWidget {
  final dynamic token;

  const SingleTokenScreen({super.key, required this.token});

  @override
  SingleTokenScreenState createState() => SingleTokenScreenState();
}

class SingleTokenScreenState extends State<SingleTokenScreen> {
  int _selectedIndex = 0;
  final List<CandleData> _candlestickData = generateCandlestickData();

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getHeaderImageUrl(String originalUrl) {
    final int pngIndex = originalUrl.lastIndexOf('.png');
    if (pngIndex == -1) return originalUrl;
    return originalUrl.substring(0, pngIndex) +
        '/header' +
        originalUrl.substring(pngIndex);
  }

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();

    String originalImageUrl = widget.token['token']['tokenImageUrl'];
    logger.i(originalImageUrl);

    String headerImageUrl = _getHeaderImageUrl(originalImageUrl);
    logger.i('Header Image URL: $headerImageUrl');

    final List<Widget> screens = [
      TokenOverview(token: widget.token),
      TokenHolders(contractAddress: widget.token['contract_address']),
      TokenTransfers(contractAddress: widget.token['contract_address']),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.token['token']['tokenSymbol']?.toUpperCase() ?? 'Token',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TokenMessagesScreen(token: widget.token),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_selectedIndex == 0) ...[
              Hero(
                tag: widget.token['contract_address'],
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(headerImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                height:
                    300, // Set a fixed height for the chart for scrollable space
                child: InteractiveChart(
                  candles:
                      _candlestickData, // Display the generated candlestick data
                  style: ChartStyle(),
                ),
              ),
            ],
            screens[_selectedIndex], // Display the selected screen content
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () => _onItemTapped(0),
              color: _selectedIndex == 0 ? brightBlue : customBlack,
            ),
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () => _onItemTapped(1),
              color: _selectedIndex == 1 ? brightBlue : customBlack,
            ),
            IconButton(
              icon: const Icon(Icons.swap_horiz),
              onPressed: () => _onItemTapped(2),
              color: _selectedIndex == 2 ? brightBlue : customBlack,
            ),
          ],
        ),
      ),
    );
  }
}
