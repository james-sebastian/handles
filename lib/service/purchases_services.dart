part of "services.dart";

class PurchasesServices with ChangeNotifier{
  static const _apiKey = 'GJwnSERogYKUiCaRvukwcnWaQTCsIHSN';

  Future<void> init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_apiKey);
  }

  Future<Offering?> fetchOffers() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null && offerings.current!.monthly != null) {
        print(offerings.current);
      }

      print("null");
    } on PlatformException catch (e) {
      print("error");
    }
  }
}