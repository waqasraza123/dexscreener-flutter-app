import 'package:flutter/material.dart';
import './chat/token_messages_screen.dart';
import './token/token_holders.dart';
import './token/token_transfers.dart';
import './token/token_overview.dart';

class SingleTokenScreen extends StatefulWidget {
  final dynamic token;

  const SingleTokenScreen({super.key, required this.token});

  @override
  SingleTokenScreenState createState() => SingleTokenScreenState();
}

class SingleTokenScreenState extends State<SingleTokenScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define the screens corresponding to the tabs
    final List<Widget> screens = [
      TokenOverview(token: widget.token), // Overview screen
      TokenHolders(contractAddress: widget.token['contract_address']),
      TokenTransfers(contractAddress: widget.token['contract_address']),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.token['token']['tokenSymbol']?.toUpperCase() ?? 'Token'),
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
      body: screens[_selectedIndex], // Display the currently selected screen
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () => _onItemTapped(0),
              color: _selectedIndex == 0
                  ? Colors.blue
                  : Colors.black, // Highlight selected icon
            ),
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () => _onItemTapped(1),
              color: _selectedIndex == 1
                  ? Colors.blue
                  : Colors.black, // Highlight selected icon
            ),
            IconButton(
              icon: const Icon(Icons.swap_horiz),
              onPressed: () => _onItemTapped(2),
              color: _selectedIndex == 2
                  ? Colors.blue
                  : Colors.black, // Highlight selected icon
            ),
          ],
        ),
      ),
    );
  }
}
