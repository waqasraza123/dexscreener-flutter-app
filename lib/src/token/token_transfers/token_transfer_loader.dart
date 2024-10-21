import 'package:logger/logger.dart';
import '../../../services/token_service.dart';
import '../../../utils/pagination.dart';

class TokenTransferLoader {
  final TokenService tokenService;
  final String contractAddress;
  final Pagination pagination;

  TokenTransferLoader({
    required this.tokenService,
    required this.contractAddress,
  }) : pagination = Pagination(
            tokenService: tokenService, contractAddress: contractAddress);

  Future<List<dynamic>> loadInitialTransfers() async {
    try {
      return await pagination.loadInitialTransfers();
    } catch (error) {
      Logger logger = Logger();
      logger.e("Error loading initial transfers: $error");
      rethrow; // Propagate the error
    }
  }

  Future<List<dynamic>> loadMoreTransfers() async {
    try {
      return await pagination.loadMoreTransfers();
    } catch (error) {
      Logger logger = Logger();
      logger.e("Error loading more transfers: $error");
      rethrow; // Propagate the error
    }
  }
}
