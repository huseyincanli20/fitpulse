class WeightRecord {
  final DateTime date;
  final double weightKg;
  final String? note;

  WeightRecord({
    required this.date,
    required this.weightKg,
    this.note,
  });
}

class BodyMeasurement {
  final DateTime date;
  final double chestCm;
  final double waistCm;
  final double armsCm;
  final double hipsCm;
  final double thighsCm;

  BodyMeasurement({
    required this.date,
    required this.chestCm,
    required this.waistCm,
    required this.armsCm,
    required this.hipsCm,
    required this.thighsCm,
  });
}
