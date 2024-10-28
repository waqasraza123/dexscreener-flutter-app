import 'package:flutter/material.dart';

import '../../services/moralis_service.dart';

class TrendingNFTsScreen extends StatefulWidget {
  @override
  _TrendingNFTsScreenState createState() => _TrendingNFTsScreenState();
}

class _TrendingNFTsScreenState extends State<TrendingNFTsScreen> {
  List<dynamic> nftData = [];
  final MoralisService moralisService = MoralisService();

  @override
  void initState() {
    super.initState();
    fetchNFTData();
  }

  Future<void> fetchNFTData() async {
    try {
      final data = await moralisService.fetchNFTData();
      setState(() {
        nftData = data;
      });
    } catch (e) {
      print('Error fetching NFT data: $e');
    }
  }

  String getImageUrl(String image) {
    if (image.startsWith('ipfs://')) {
      return image.replaceFirst('ipfs://', 'https://ipfs.io/ipfs/');
    } else if (image.contains('https://pa-genesis-previews.b-cdn.net')) {
      return image;
    } else {
      return image.isNotEmpty ? image : 'https://via.placeholder.com/150';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending NFTs'),
      ),
      body: nftData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7,
              ),
              itemCount: nftData.length,
              itemBuilder: (context, index) {
                final nft = nftData[index];
                final metadata = nft['metadata'] ?? {};
                final image = getImageUrl(metadata['image'] ?? '');
                final name = nft['name'] ?? 'Unknown NFT';
                final symbol = nft['symbol'] ?? '';
                final rarityLabel = nft['rarityLabel'] ?? '';
                final ownerOf = nft['ownerOf'] ?? 'Unknown Owner';

                return Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image, size: 50);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text('Symbol: $symbol'),
                            Text('Rarity: $rarityLabel'),
                            Text('Owner: $ownerOf'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
