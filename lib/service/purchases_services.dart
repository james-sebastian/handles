part of "services.dart";

class PurchasesServices with ChangeNotifier{
  static const _apiKey = 'GJwnSERogYKUiCaRvukwcnWaQTCsIHSN';

  Future<void> init() async {
    // await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_apiKey);
  }

  Future<Offering?> fetchOffers() async {
    try {
      const Set<String> _kIds = <String>{'product1', 'product2'};
      final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kIds);

      print(response);

      if (response.notFoundIDs.isNotEmpty) {
        // Handle the error.
      }
      List<ProductDetails> products = response.productDetails;
      print(products);
    } on PlatformException catch (e) {
      print(e);
    }
  }
}