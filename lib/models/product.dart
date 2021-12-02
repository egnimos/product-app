class Product {
  String id;
  String name;
  DateTime launcedAt;
  String launchedSite;
  double rate;

  Product({
    required this.id,
    required this.name,
    required this.launcedAt,
    required this.launchedSite,
    required this.rate,
  });
}

// {name: String, launchedAt: Date, launchSite: String, popularity: stars}