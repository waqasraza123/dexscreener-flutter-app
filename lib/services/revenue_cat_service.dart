import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  Future<void> fetchProducts(BuildContext context) async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      final Logger logger = Logger();
      logger.i(offerings);
      if (offerings.current != null) {
        showSubscriptionPopup(context, offerings.current!);
      }
    } catch (e) {
      // Handle errors
      print('Error fetching products: $e');
    }
  }

  void showSubscriptionPopup(BuildContext context, Offering offering,
      {VoidCallback? onSuccess}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Subscribe to unlock features"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: offering.availablePackages.map((package) {
              return ListTile(
                title: Text(package.storeProduct.title),
                subtitle: Text(package.storeProduct.priceString),
                onTap: () async {
                  // Purchase the package and check success
                  await purchasePackage(package, onSuccess);
                  Navigator.of(context).pop(); // Close popup after selection
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> purchasePackage(Package package, VoidCallback? onSuccess) async {
    try {
      // The purchasePackage method now returns the PurchaserInfo
      CustomerInfo purchaserInfo = await Purchases.purchasePackage(package);
      if (purchaserInfo.entitlements.active.isNotEmpty) {
        print("Subscription successful!");
        onSuccess?.call(); // Call the onSuccess callback if it's provided
      }
    } catch (e) {
      print('Error purchasing package: $e');
    }
  }

  Future<bool> checkSubscriptionStatus() async {
    return true;
    // try {
    //   // Fetch the purchaser info
    //   CustomerInfo purchaserInfo = await Purchases.getPurchaserInfo();
    //   return purchaserInfo.entitlements.active
    //       .isNotEmpty; // Check if any entitlements are active
    // } catch (e) {
    //   print('Error checking subscription status: $e');
    //   return false;
    // }
  }

  Future<Offering> fetchOffering() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      final Logger logger = Logger();
      logger.i(offerings);
      Offering currentOffering = offerings.current!;
      return currentOffering;
    } catch (e) {
      throw Exception("Error fetching offering: $e");
    }
  }
}
