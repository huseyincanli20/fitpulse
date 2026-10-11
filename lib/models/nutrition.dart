enum MealType { kahvalti, ogle, aksam, araOgun }

extension MealTypeExtension on MealType {
  String get displayName {
    switch (this) {
      case MealType.kahvalti:
        return 'Kahvaltı';
      case MealType.ogle:
        return 'Öğle Yemeği';
      case MealType.aksam:
        return 'Akşam Yemeği';
      case MealType.araOgun:
        return 'Ara Öğün';
    }
  }
}

enum FoodUnit { gram, ml }

extension FoodUnitExtension on FoodUnit {
  String get symbol => this == FoodUnit.ml ? 'ml' : 'g';
  String get label => this == FoodUnit.ml ? 'Mililitre' : 'Gram';
}

class FoodItem {
  final String id;
  final String name;
  final String category; // 'İçecek', 'Et & Tavuk', 'Tahıl', 'Süt Ürünü', 'Meyve & Kuruyemiş' vb.
  final FoodUnit unit;    // gram veya ml
  final double caloriesPer100;
  final double proteinPer100;
  final double carbsPer100;
  final double fatPer100;
  final double defaultAmount; // örn: 200 ml veya 150 g
  final String defaultPortionName; // örn: "1 Su Bardağı (200 ml)"
  final bool isHydrating; // Su takibine dahil edilsin mi?

  const FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.caloriesPer100,
    required this.proteinPer100,
    required this.carbsPer100,
    required this.fatPer100,
    this.defaultAmount = 100.0,
    this.defaultPortionName = '100 birim',
    this.isHydrating = false,
  });

  // Verilen miktar (g veya ml) üzerinden kesin gerçek değer hesaplama
  int calculateCalories(double amount) {
    return ((amount / 100.0) * caloriesPer100).round();
  }

  double calculateProtein(double amount) {
    return double.parse(((amount / 100.0) * proteinPer100).toStringAsFixed(1));
  }

  double calculateCarbs(double amount) {
    return double.parse(((amount / 100.0) * carbsPer100).toStringAsFixed(1));
  }

  double calculateFat(double amount) {
    return double.parse(((amount / 100.0) * fatPer100).toStringAsFixed(1));
  }
}

class MealItem {
  final String id;
  final FoodItem food;
  final double amount; // Tüketilen gerçek miktar (ör: 250 ml veya 180 g)
  final MealType mealType;
  final DateTime loggedAt;

  MealItem({
    required this.id,
    required this.food,
    required this.amount,
    required this.mealType,
    required this.loggedAt,
  });

  String get name => food.name;
  FoodUnit get unit => food.unit;
  String get unitSymbol => food.unit.symbol;

  int get calories => food.calculateCalories(amount);
  double get proteinGrams => food.calculateProtein(amount);
  double get carbsGrams => food.calculateCarbs(amount);
  double get fatGrams => food.calculateFat(amount);
}

class DailyNutritionSummary {
  final int targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFat;
  final int targetWaterMl;

  int currentWaterMl;
  final List<MealItem> meals;

  DailyNutritionSummary({
    this.targetCalories = 2450,
    this.targetProtein = 165.0,
    this.targetCarbs = 270.0,
    this.targetFat = 68.0,
    this.targetWaterMl = 3200,
    this.currentWaterMl = 1800,
    List<MealItem>? meals,
  }) : meals = meals ?? [];

  int get consumedCalories => meals.fold(0, (sum, item) => sum + item.calories);
  double get consumedProtein => meals.fold(0.0, (sum, item) => sum + item.proteinGrams);
  double get consumedCarbs => meals.fold(0.0, (sum, item) => sum + item.carbsGrams);
  double get consumedFat => meals.fold(0.0, (sum, item) => sum + item.fatGrams);

  int get remainingCalories => (targetCalories - consumedCalories).clamp(0, targetCalories);
}
