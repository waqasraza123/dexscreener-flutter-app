import 'package:logger/logger.dart';
import '../../services/token_service.dart';

class Pagination {
  final TokenService tokenService;
  final String contractAddress;
  final int itemsToLoad;

  int currentOffset = 0;
  bool isLoadingMore = false;

  Pagination({
    required this.tokenService,
    required this.contractAddress,
    this.itemsToLoad = 10,
  });

  Future<List<dynamic>> loadInitialTransfers() async {
    final Map<String, dynamic> response = await tokenService
        .fetchTokenTransfers(contractAddress, itemsToLoad, currentOffset);
    currentOffset += itemsToLoad;
    return response['transfersData'];
  }

  Future<List<dynamic>> loadMoreTransfers() async {
    if (isLoadingMore) return [];

    isLoadingMore = true;
    try {
      final Map<String, dynamic> response = await tokenService
          .fetchTokenTransfers(contractAddress, itemsToLoad, currentOffset);
      currentOffset += itemsToLoad;
      return response['transfersData'];
    } catch (error) {
      Logger logger = Logger();
      logger.e("Error loading more transfers: $error");
      return [];
    } finally {
      isLoadingMore = false;
    }
  }
}
