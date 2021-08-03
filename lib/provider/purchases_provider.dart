part of 'providers.dart';

final purchasesProvider = ChangeNotifierProvider<PurchasesServices>(
  (ref) => PurchasesServices()
);