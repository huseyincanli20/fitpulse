import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/nutrition.dart';
import '../models/body_stat.dart';

class FitnessProvider extends ChangeNotifier {
  // --- 1. Egzersiz Kütüphanesi & Antrenmanlar (Videolu Anlatımlarla) ---
  final List<Exercise> _exerciseDatabase = [
    Exercise(
      id: 'ex_1',
      name: 'Barbell Bench Press',
      category: 'Göğüs',
      targetMuscle: 'Göğüs (Pectoralis Major) & Triceps',
      equipment: 'Halter & Düz Sehpa',
      description: 'Göğüs kas kütlesi ve üst vücut itiş kuvveti için temel bileşik hareket.',
      defaultSets: 4,
      defaultReps: 8,
      defaultWeightKg: 70.0,
      iconName: 'fitness_center',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80',
      executionSteps: [
        'Sehpaya sırt üstü uzanın, gözleriniz doğrudan barın altında olsun.',
        'Kürekkemiklerinizi geriye sıkıştırıp sehpaya sabitleyin ve beli hafif kavisli tutun.',
        'Barı omuz genişliğinden biraz daha geniş bir tutuşla kavrayın.',
        'Nefes alarak barı kontrollü şekilde alt göğüs hizasına indirin.',
        'Dirsekleri gövdeye 45-60 derece açıda tutarak nefes verip barı tepeye itin.',
      ],
      commonMistakes: [
        'Dirsekleri 90 derece yana açıp omuz eklemine aşırı yük bindirmek.',
        'Barı göğüsten sektirerek kaldırmak.',
        'Kalçayı sehpadan yukarı kaldırmak.',
      ],
    ),
    Exercise(
      id: 'ex_2',
      name: 'Incline Dumbbell Press',
      category: 'Göğüs',
      targetMuscle: 'Üst Göğüs (Clavicular Head)',
      equipment: 'Dambıl & Açılı Sehpa (30-45°)',
      description: 'Üst göğüs gelişimini izole eden ve omuz mobilitesini artıran hareket.',
      defaultSets: 3,
      defaultReps: 10,
      defaultWeightKg: 24.0,
      iconName: 'fitness_center',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=600&q=80',
      executionSteps: [
        'Sehpa açısını 30 ila 45 dereceye ayarlayın.',
        'Dambılları dizlerinizin yardımıyla omuz seviyesine getirin.',
        'Kürekkemiklerini sıkın, avuç içleri hafifçe içeri dönük olacak şekilde dambılları yukarı itin.',
        'Tepe noktada dambılları birbirine çarpmadan göğüs kaslarını sıkın.',
        '2-3 saniye sürede kontrollü şekilde omuz hizasına indirin.',
      ],
      commonMistakes: [
        'Sehpa eğimini 60 dereceden fazla yaparak hareketi omuz presine dönüştürmek.',
        'Ağırlıkları tepe noktada birbirine çarptırmak.',
      ],
    ),
    Exercise(
      id: 'ex_3',
      name: 'Cable Crossover / Fly',
      category: 'Göğüs',
      targetMuscle: 'İç & Alt Göğüs Kasları',
      equipment: 'Çift Kablo İstasyonu',
      description: 'Tepe noktada kas sıkışmasını maksimize eden izolasyon hareketi.',
      defaultSets: 3,
      defaultReps: 12,
      defaultWeightKg: 15.0,
      iconName: 'fitness_center',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80',
      executionSteps: [
        'Makaraları omuz hizasına ayarlayın ve bir adım öne çıkın.',
        'Dirseklerde hafif bir bükülme koruyarak kolları yana açın.',
        'Göğüs kaslarınızı sıkarak kolları önünüzde birleştirin (büyük bir ağacı kucaklar gibi).',
        'Tepe noktada 1 saniye izometrik kasılma uygulayın.',
      ],
      commonMistakes: [
        'Hareketi itişe dönüştürüp kolları büküp uzatmak.',
        'Gövdeyi aşırı öne arkaya sallayarak ivme kazanmak.',
      ],
    ),
    Exercise(
      id: 'ex_4',
      name: 'Barbell Deadlift',
      category: 'Sırt',
      targetMuscle: 'Tüm Arka Zincir, Glutes & Bel',
      equipment: 'Olimpik Halter & Plakalar',
      description: 'Arka zincir, latissimus ve trapezleri çalıştıran en güçlü güç hareketi.',
      defaultSets: 4,
      defaultReps: 6,
      defaultWeightKg: 100.0,
      iconName: 'fitness_center',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyBlazes.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80',
      executionSteps: [
        'Ayaklar kalça genişliğinde açık, bar kaval kemiğinize 2-3 cm mesafede olmalı.',
        'Kalçanızı geriye iterek çömelin ve barı omuz genişliğinde tutun.',
        'Sırtınızı düzleştirin, göğsü dik tutun ve lats kaslarını kilitleyin.',
        'Topuklarınızla yeri iterek kalça ve dizleri aynı anda düzleştirin.',
        'Dik konuma gelince kalçayı sıkın, geriye aşırı yaslanmayın.',
      ],
      commonMistakes: [
        'Sırtı kamburlaştırarak kaldırmak (ciddi sakatlık riski).',
        'Barı vücuttan uzaklaştırarak kaldırmak.',
      ],
    ),
    Exercise(
      id: 'ex_5',
      name: 'Lat Pulldown',
      category: 'Sırt',
      targetMuscle: 'Kanat Kasları (Latissimus Dorsi)',
      equipment: 'Kablo Lat İstasyonu & Geniş Bar',
      description: 'Sırt genişliği için kanat kaslarını hedefleyen dikey çekiş hareketi.',
      defaultSets: 4,
      defaultReps: 10,
      defaultWeightKg: 55.0,
      iconName: 'fitness_center',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=600&q=80',
      executionSteps: [
        'Diz desteklerini bacaklarınızı sabitleyecek şekilde ayarlayın.',
        'Geniş açılı bir tutuşla barı kavrayın.',
        'Gövdenizi 10-15 derece hafif arkaya eğin ve göğsü yukarı çıkarın.',
        'Dirsekleri aşağı ve arkaya çekerek barı üst göğse doğru indirin.',
        'Kolları yavaşça yukarı uzatırken lats kaslarının esnemesine izin verin.',
      ],
      commonMistakes: [
        'Barı boyun arkasına çekmek.',
        'Aşırı geriye yatarak hareketi yatay küreğe dönüştürmek.',
      ],
    ),
    Exercise(
      id: 'ex_6',
      name: 'Barbell Back Squat',
      category: 'Bacak',
      targetMuscle: 'Ön Bacak (Quadriceps) & Kalça (Glutes)',
      equipment: 'Squat Rack & Halter',
      description: 'Bacak gelişimi ve genel anabolik etki için altın standart egzersiz.',
      defaultSets: 4,
      defaultReps: 8,
      defaultWeightKg: 90.0,
      iconName: 'directions_run',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=600&q=80',
      executionSteps: [
        'Barı üst trapez kaslarının üzerine yerleştirin.',
        'Ayaklar omuz genişliğinde açık, parmak uçları 15-30 derece dışa dönük olmalı.',
        'Nefes alıp karın içi basınç oluşturun (Valsalva).',
        'Kalçayı geriye ve dizleri dışa doğru bükerek paralel veya biraz altına inin.',
        'Topuklardan güç alarak patlayıcı şekilde başlangıç pozisyonuna dönün.',
      ],
      commonMistakes: [
        'Dizlerin içeri çökmesi (Knee valgus).',
        'Topukların yerden kalkması.',
        'Yeterli derinliğe inmemek (Yarım squat).',
      ],
    ),
    Exercise(
      id: 'ex_7',
      name: 'Leg Press',
      category: 'Bacak',
      targetMuscle: 'Quadriceps & Glutes',
      equipment: '45 Derece Leg Press Makinesi',
      description: 'Omurgaya binen yükü azaltarak bacaklara yüksek hacim yükleme hareketi.',
      defaultSets: 3,
      defaultReps: 12,
      defaultWeightKg: 160.0,
      iconName: 'directions_run',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1434596922112-19c563067271?w=600&q=80',
      executionSteps: [
        'Sırtınızı ve kalçanızı mindere sıkıca yapıştırın.',
        'Ayaklarınızı platforma omuz genişliğinde yerleştirin.',
        'Emniyet kolunu açın ve platformu kontrollüce göğsünüze yaklaştırın.',
        'Dizler 90 dereceye gelince platformu geri itin, dizleri tam kilitlemeyin.',
      ],
      commonMistakes: [
        'Tepe noktada dizleri kitleyip ekleme baskı bindirmek.',
        'Kalçanın minderden kalkması.',
      ],
    ),
    Exercise(
      id: 'ex_8',
      name: 'Overhead Dumbbell Press',
      category: 'Omuz',
      targetMuscle: 'Ön & Yan Omuz (Deltoids)',
      equipment: 'Dambıl & Dik Sehpa',
      description: 'Omuz genişliği ve baş üstü itiş stabilitesi egzersizi.',
      defaultSets: 4,
      defaultReps: 10,
      defaultWeightKg: 20.0,
      iconName: 'fitness_center',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?w=600&q=80',
      executionSteps: [
        'Dik sehpaya oturun, dambılları kulak hizasında tutun.',
        'Dirsekler omuzların hafifçe önünde olmalı.',
        'Dambılları başınızın üstüne doğru kontrollüce itin.',
        'Tepe noktada omuzları sıkın ve yavaşça kulak hizasına indirin.',
      ],
      commonMistakes: [
        'Beli aşırı kavisli yaparak yükü omurgaya bindirmek.',
        'Dambılları kontrolsüz şekilde aşağı bırakmak.',
      ],
    ),
    Exercise(
      id: 'ex_9',
      name: 'Lateral Raise',
      category: 'Omuz',
      targetMuscle: 'Yan Omuz (Lateral Deltoid)',
      equipment: 'Dambıl',
      description: 'Geniş omuz görüntüsü (V-Taper) için kritik yan omuz izolasyonu.',
      defaultSets: 4,
      defaultReps: 15,
      defaultWeightKg: 10.0,
      iconName: 'fitness_center',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80',
      executionSteps: [
        'Ayaklar omuz genişliğinde açık, dambıllar vücudun yanında.',
        'Dirseklerde hafif bir bükülme koruyun.',
        'Dambılları omuz hizasına kadar yana doğru kaldırın.',
        'Tepe noktada serçe parmağı hafifçe yukarı bakacak şekilde tutun.',
        'Yavaşça başlangıç pozisyonuna indirin.',
      ],
      commonMistakes: [
        'Gövdeyi sallayarak ağırlığı savurmak.',
        'Trapezleri devreye sokarak omuzları kulaklara çekmek.',
      ],
    ),
    Exercise(
      id: 'ex_10',
      name: 'Barbell Bicep Curl',
      category: 'Kol',
      targetMuscle: 'Ön Kol (Biceps Brachii)',
      equipment: 'Z-Bar veya Düz Halter',
      description: 'Ön kol hacmi ve tepe kas uyarımı sağlayan klasik kıvırma hareketi.',
      defaultSets: 3,
      defaultReps: 10,
      defaultWeightKg: 30.0,
      iconName: 'fitness_center',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=600&q=80',
      executionSteps: [
        'Barı avuç içleri yukarı bakacak şekilde omuz genişliğinde kavrayın.',
        'Dirsekleri gövdenin yanına sabitleyin.',
        'Sadece ön kolları hareket ettirerek barı göğse doğru kıvırın.',
        'Tepe noktada biceps kaslarını sıkın ve 2-3 saniyede indirin.',
      ],
      commonMistakes: [
        'Dirsekleri öne ve arkaya savurarak ivme kullanmak.',
        'Beli geriye doğru bükmek.',
      ],
    ),
    Exercise(
      id: 'ex_11',
      name: 'Triceps Rope Pushdown',
      category: 'Kol',
      targetMuscle: 'Arka Kol (Triceps Lateral & Long Head)',
      equipment: 'Kablo İstasyonu & Halat Aparatı',
      description: 'Kol kütlesinin %60\'ını oluşturan arka kol kaslarını hedefleyen hareket.',
      defaultSets: 3,
      defaultReps: 12,
      defaultWeightKg: 25.0,
      iconName: 'fitness_center',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=600&q=80',
      executionSteps: [
        'Halatı her iki elinizle kavrayın, dirsekleri gövdeye sabitleyin.',
        'Ön kolları aşağı doğru iterek dirsekleri kilitleyin.',
        'Dip noktada halatın uçlarını dışa doğru ayırarak triceps kasılmasını artırın.',
        'Dirsekleri sabit tutarak ön kolların 90 dereceye dönmesine izin verin.',
      ],
      commonMistakes: [
        'Dirseklerin öne arkaya oynaması.',
        'Gövde ağırlığını halatın üzerine vererek itiş yapmak.',
      ],
    ),
    Exercise(
      id: 'ex_12',
      name: 'Hanging Leg Raise',
      category: 'Karın',
      targetMuscle: 'Alt Karın & Core Stabilitesi',
      equipment: 'Barfiks Barı',
      description: 'Güçlü karın duvarı ve stabilite için vücut ağırlığı egzersizi.',
      defaultSets: 3,
      defaultReps: 15,
      defaultWeightKg: 0.0,
      iconName: 'accessibility_new',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyBlazes.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=600&q=80',
      executionSteps: [
        'Barfiks barından omuz genişliğinde tutunarak asılın.',
        'Omuzları kilitleyin, sallanmayı durdurun.',
        'Bacakları hafif bükülü veya düz tutarak kalçayı öne kıvırıp kaldırın.',
        'Ayaklar kalça hizasına veya üstüne çıkınca 1 saniye bekleyin.',
        'Bacakları kontrollü şekilde indirin.',
      ],
      commonMistakes: [
        'Vücudu sallayarak (kipping) ivmeyle bacak kaldırmak.',
        'Sadece bacak büküp leğen kemiğini (pelvis) kıvırmamak.',
      ],
    ),
  ];

  late final List<WorkoutPlan> _workoutPlans = [
    WorkoutPlan(
      id: 'plan_push',
      title: 'Push Day (İtiş Odaklı)',
      subtitle: 'Göğüs, Ön Omuz & Triceps',
      category: 'Hipertrofi',
      estimatedMinutes: 55,
      estimatedCalories: 420,
      difficulty: 'Orta Seviye',
      exercises: [
        _exerciseDatabase[0], // Bench Press
        _exerciseDatabase[1], // Incline DB Press
        _exerciseDatabase[2], // Cable Fly
        _exerciseDatabase[7], // Overhead Press
        _exerciseDatabase[10], // Triceps Pushdown
      ],
    ),
    WorkoutPlan(
      id: 'plan_pull',
      title: 'Pull Day (Çekiş Odaklı)',
      subtitle: 'Sırt, Arka Omuz & Biceps',
      category: 'Kuvvet & Hacim',
      estimatedMinutes: 60,
      estimatedCalories: 460,
      difficulty: 'İleri Seviye',
      exercises: [
        _exerciseDatabase[3], // Deadlift
        _exerciseDatabase[4], // Lat Pulldown
        _exerciseDatabase[8], // Lateral Raise
        _exerciseDatabase[9], // Bicep Curl
      ],
    ),
    WorkoutPlan(
      id: 'plan_leg',
      title: 'Leg Day & Core',
      subtitle: 'Bacak, Kalça & Karın',
      category: 'Kuvvet',
      estimatedMinutes: 50,
      estimatedCalories: 490,
      difficulty: 'Zorlu',
      exercises: [
        _exerciseDatabase[5], // Squat
        _exerciseDatabase[6], // Leg Press
        _exerciseDatabase[11], // Hanging Leg Raise
      ],
    ),
  ];

  final List<CompletedWorkout> _history = [
    CompletedWorkout(
      id: 'h_1',
      title: 'Push Day (İtiş Odaklı)',
      date: DateTime.now().subtract(const Duration(days: 1)),
      durationSeconds: 52 * 60,
      totalCalories: 435,
      totalVolumeKg: 4250.0,
      completedSetsCount: 16,
    ),
    CompletedWorkout(
      id: 'h_2',
      title: 'Leg Day & Core',
      date: DateTime.now().subtract(const Duration(days: 3)),
      durationSeconds: 48 * 60,
      totalCalories: 510,
      totalVolumeKg: 6100.0,
      completedSetsCount: 14,
    ),
  ];

  List<Exercise> get exerciseDatabase => List.unmodifiable(_exerciseDatabase);
  List<WorkoutPlan> get workoutPlans => List.unmodifiable(_workoutPlans);
  List<CompletedWorkout> get workoutHistory => List.unmodifiable(_history);

  // --- 2. Aktif Antrenman Durumu ---
  WorkoutPlan? _activeWorkout;
  bool _isWorkoutActive = false;
  int _activeWorkoutSeconds = 0;
  Timer? _workoutTimer;
  Map<String, List<WorkoutSet>> _activeSets = {};

  WorkoutPlan? get activeWorkout => _activeWorkout;
  bool get isWorkoutActive => _isWorkoutActive;
  int get activeWorkoutSeconds => _activeWorkoutSeconds;
  Map<String, List<WorkoutSet>> get activeSets => _activeSets;

  void startWorkout(WorkoutPlan plan) {
    _activeWorkout = plan;
    _isWorkoutActive = true;
    _activeWorkoutSeconds = 0;
    _activeSets = {};

    for (var exercise in plan.exercises) {
      _activeSets[exercise.id] = List.generate(
        exercise.defaultSets,
        (index) => WorkoutSet(
          setNumber: index + 1,
          reps: exercise.defaultReps,
          weightKg: exercise.defaultWeightKg,
          isCompleted: false,
        ),
      );
    }

    _workoutTimer?.cancel();
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _activeWorkoutSeconds++;
      notifyListeners();
    });

    notifyListeners();
  }

  void toggleSetCompletion(String exerciseId, int setIndex) {
    if (_activeSets.containsKey(exerciseId)) {
      final list = _activeSets[exerciseId]!;
      if (setIndex < list.length) {
        list[setIndex].isCompleted = !list[setIndex].isCompleted;
        // Dinlenme sayacını otomatik tetikle
        if (list[setIndex].isCompleted) {
          startRestTimer(90);
        }
        notifyListeners();
      }
    }
  }

  void updateSet(String exerciseId, int setIndex, {int? reps, double? weight}) {
    if (_activeSets.containsKey(exerciseId)) {
      final list = _activeSets[exerciseId]!;
      if (setIndex < list.length) {
        if (reps != null) list[setIndex].reps = reps;
        if (weight != null) list[setIndex].weightKg = weight;
        notifyListeners();
      }
    }
  }

  void addSetToExercise(String exerciseId) {
    if (_activeSets.containsKey(exerciseId)) {
      final list = _activeSets[exerciseId]!;
      final lastSet = list.isNotEmpty ? list.last : null;
      list.add(WorkoutSet(
        setNumber: list.length + 1,
        reps: lastSet?.reps ?? 10,
        weightKg: lastSet?.weightKg ?? 20.0,
      ));
      notifyListeners();
    }
  }

  void finishWorkout() {
    if (!_isWorkoutActive || _activeWorkout == null) return;

    double volume = 0;
    int sets = 0;

    _activeSets.forEach((key, setList) {
      for (var s in setList) {
        if (s.isCompleted) {
          volume += s.reps * s.weightKg;
          sets++;
        }
      }
    });

    final completed = CompletedWorkout(
      id: 'h_${DateTime.now().millisecondsSinceEpoch}',
      title: _activeWorkout!.title,
      date: DateTime.now(),
      durationSeconds: _activeWorkoutSeconds,
      totalCalories: ((_activeWorkoutSeconds / 60) * 8.5).round(),
      totalVolumeKg: volume,
      completedSetsCount: sets,
    );

    _history.insert(0, completed);
    _workoutTimer?.cancel();
    _isWorkoutActive = false;
    _activeWorkout = null;
    _activeWorkoutSeconds = 0;
    _activeSets = {};
    notifyListeners();
  }

  void cancelWorkout() {
    _workoutTimer?.cancel();
    _isWorkoutActive = false;
    _activeWorkout = null;
    _activeWorkoutSeconds = 0;
    _activeSets = {};
    notifyListeners();
  }

  // --- 3. Rest & Interval / HIIT Zamanlayıcı ---
  Timer? _restCountdownTimer;
  int _restSecondsRemaining = 0;
  int _totalRestSeconds = 0;
  bool _isRestTimerRunning = false;

  int get restSecondsRemaining => _restSecondsRemaining;
  int get totalRestSeconds => _totalRestSeconds;
  bool get isRestTimerRunning => _isRestTimerRunning;

  void startRestTimer(int seconds) {
    _restCountdownTimer?.cancel();
    _totalRestSeconds = seconds;
    _restSecondsRemaining = seconds;
    _isRestTimerRunning = true;

    _restCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSecondsRemaining > 0) {
        _restSecondsRemaining--;
        notifyListeners();
      } else {
        _isRestTimerRunning = false;
        timer.cancel();
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void stopRestTimer() {
    _restCountdownTimer?.cancel();
    _isRestTimerRunning = false;
    _restSecondsRemaining = 0;
    notifyListeners();
  }

  void addRestSeconds(int add) {
    _restSecondsRemaining += add;
    _totalRestSeconds += add;
    notifyListeners();
  }

  // --- 4. Gerçek Yiyecek & İçecek Veritabanı (100g ve 100ml bazlı) ---
  final List<FoodItem> _foodDatabase = [
    // --- İÇECEKLER (ml bazlı) ---
    const FoodItem(
      id: 'bev_water',
      name: 'Doğal Kaynak Suyu',
      category: 'İçecek',
      unit: FoodUnit.ml,
      caloriesPer100: 0.0,
      proteinPer100: 0.0,
      carbsPer100: 0.0,
      fatPer100: 0.0,
      defaultAmount: 250.0,
      defaultPortionName: '1 Su Bardağı (250 ml)',
      isHydrating: true,
    ),
    const FoodItem(
      id: 'bev_milk_half',
      name: 'Yarım Yağlı Süt (%1.5)',
      category: 'İçecek',
      unit: FoodUnit.ml,
      caloriesPer100: 47.0,
      proteinPer100: 3.2,
      carbsPer100: 4.7,
      fatPer100: 1.5,
      defaultAmount: 200.0,
      defaultPortionName: '1 Bardak (200 ml)',
      isHydrating: true,
    ),
    const FoodItem(
      id: 'bev_ayran',
      name: 'Geleneksel Ayran',
      category: 'İçecek',
      unit: FoodUnit.ml,
      caloriesPer100: 37.0,
      proteinPer100: 2.0,
      carbsPer100: 2.8,
      fatPer100: 1.5,
      defaultAmount: 250.0,
      defaultPortionName: '1 Kutu / Bardak (250 ml)',
      isHydrating: true,
    ),
    const FoodItem(
      id: 'bev_protein_shake',
      name: 'Whey Protein Shake (Su ile)',
      category: 'İçecek',
      unit: FoodUnit.ml,
      caloriesPer100: 40.0,
      proteinPer100: 8.0,
      carbsPer100: 1.0,
      fatPer100: 0.5,
      defaultAmount: 300.0,
      defaultPortionName: '1 Shaker (300 ml - 24g Protein)',
      isHydrating: true,
    ),
    const FoodItem(
      id: 'bev_coffee_black',
      name: 'Filtre Kahve / Americano (Sade)',
      category: 'İçecek',
      unit: FoodUnit.ml,
      caloriesPer100: 2.0,
      proteinPer100: 0.2,
      carbsPer100: 0.0,
      fatPer100: 0.0,
      defaultAmount: 250.0,
      defaultPortionName: '1 Kupa (250 ml)',
      isHydrating: true,
    ),
    const FoodItem(
      id: 'bev_orange_juice',
      name: 'Taze Sıkılmış Portakal Suyu',
      category: 'İçecek',
      unit: FoodUnit.ml,
      caloriesPer100: 45.0,
      proteinPer100: 0.7,
      carbsPer100: 10.4,
      fatPer100: 0.2,
      defaultAmount: 200.0,
      defaultPortionName: '1 Bardak (200 ml)',
      isHydrating: true,
    ),
    const FoodItem(
      id: 'bev_mineral_water',
      name: 'Doğal Maden Suyu (Sade)',
      category: 'İçecek',
      unit: FoodUnit.ml,
      caloriesPer100: 0.0,
      proteinPer100: 0.0,
      carbsPer100: 0.0,
      fatPer100: 0.0,
      defaultAmount: 200.0,
      defaultPortionName: '1 Şişe (200 ml)',
      isHydrating: true,
    ),
    const FoodItem(
      id: 'bev_kefir',
      name: 'Sade Probiyotik Kefir',
      category: 'İçecek',
      unit: FoodUnit.ml,
      caloriesPer100: 53.0,
      proteinPer100: 3.4,
      carbsPer100: 4.0,
      fatPer100: 2.5,
      defaultAmount: 250.0,
      defaultPortionName: '1 Bardak (250 ml)',
      isHydrating: true,
    ),
    const FoodItem(
      id: 'bev_green_tea',
      name: 'Demleme Yeşil Çay (Şekersiz)',
      category: 'İçecek',
      unit: FoodUnit.ml,
      caloriesPer100: 1.0,
      proteinPer100: 0.1,
      carbsPer100: 0.2,
      fatPer100: 0.0,
      defaultAmount: 250.0,
      defaultPortionName: '1 Fincan (250 ml)',
      isHydrating: true,
    ),
    const FoodItem(
      id: 'bev_cola_zero',
      name: 'Kola Zero / Şekersiz Meşrubat',
      category: 'İçecek',
      unit: FoodUnit.ml,
      caloriesPer100: 0.3,
      proteinPer100: 0.0,
      carbsPer100: 0.0,
      fatPer100: 0.0,
      defaultAmount: 330.0,
      defaultPortionName: '1 Kutu (330 ml)',
      isHydrating: false,
    ),

    // --- YİYECEKLER (Gram bazlı) ---
    const FoodItem(
      id: 'food_chicken_breast',
      name: 'Izgara Tavuk Göğsü (Pişmiş)',
      category: 'Et & Tavuk',
      unit: FoodUnit.gram,
      caloriesPer100: 165.0,
      proteinPer100: 31.0,
      carbsPer100: 0.0,
      fatPer100: 3.6,
      defaultAmount: 180.0,
      defaultPortionName: '1 Porsiyon (180 g)',
    ),
    const FoodItem(
      id: 'food_boiled_egg',
      name: 'Haşlanmış Yumurta',
      category: 'Kahvaltılık',
      unit: FoodUnit.gram,
      caloriesPer100: 155.0,
      proteinPer100: 12.6,
      carbsPer100: 1.1,
      fatPer100: 10.6,
      defaultAmount: 100.0,
      defaultPortionName: '2 Adet Orta Boy (~100 g)',
    ),
    const FoodItem(
      id: 'food_oats',
      name: 'Yulaf Ezmesi',
      category: 'Tahıl & Karb',
      unit: FoodUnit.gram,
      caloriesPer100: 370.0,
      proteinPer100: 13.5,
      carbsPer100: 60.0,
      fatPer100: 7.0,
      defaultAmount: 60.0,
      defaultPortionName: '1 Kase (60 g)',
    ),
    const FoodItem(
      id: 'food_basmati_rice',
      name: 'Basmati Pirinç Pilavı (Pişmiş)',
      category: 'Tahıl & Karb',
      unit: FoodUnit.gram,
      caloriesPer100: 130.0,
      proteinPer100: 2.7,
      carbsPer100: 28.0,
      fatPer100: 0.4,
      defaultAmount: 200.0,
      defaultPortionName: '1 Tabak (200 g)',
    ),
    const FoodItem(
      id: 'food_banana',
      name: 'Taze Muz',
      category: 'Meyve',
      unit: FoodUnit.gram,
      caloriesPer100: 89.0,
      proteinPer100: 1.1,
      carbsPer100: 22.8,
      fatPer100: 0.3,
      defaultAmount: 120.0,
      defaultPortionName: '1 Adet Orta Boy (120 g)',
    ),
    const FoodItem(
      id: 'food_peanut_butter',
      name: 'Şekersiz Fıstık Ezmesi (%100 Fıstık)',
      category: 'Yağ & Kuruyemiş',
      unit: FoodUnit.gram,
      caloriesPer100: 588.0,
      proteinPer100: 25.0,
      carbsPer100: 20.0,
      fatPer100: 50.0,
      defaultAmount: 30.0,
      defaultPortionName: '1 Yemek Kaşığı (30 g)',
    ),
    const FoodItem(
      id: 'food_cottage_cheese',
      name: 'Yağsız / Düşük Yağlı Lor Peyniri',
      category: 'Süt Ürünü',
      unit: FoodUnit.gram,
      caloriesPer100: 98.0,
      proteinPer100: 18.0,
      carbsPer100: 2.5,
      fatPer100: 1.5,
      defaultAmount: 100.0,
      defaultPortionName: '1 Porsiyon (100 g)',
    ),
    const FoodItem(
      id: 'food_salmon',
      name: 'Fırında Somon Balığı',
      category: 'Balık & Deniz Ürünü',
      unit: FoodUnit.gram,
      caloriesPer100: 206.0,
      proteinPer100: 22.0,
      carbsPer100: 0.0,
      fatPer100: 12.3,
      defaultAmount: 200.0,
      defaultPortionName: '1 Fileto (200 g)',
    ),
    const FoodItem(
      id: 'food_almonds',
      name: 'Çiğ Badem',
      category: 'Yağ & Kuruyemiş',
      unit: FoodUnit.gram,
      caloriesPer100: 579.0,
      proteinPer100: 21.0,
      carbsPer100: 21.6,
      fatPer100: 49.9,
      defaultAmount: 25.0,
      defaultPortionName: '1 Avuç (25 g)',
    ),
    const FoodItem(
      id: 'food_olive_oil',
      name: 'Sızma Zeytinyağı',
      category: 'Yağ & Kuruyemiş',
      unit: FoodUnit.gram,
      caloriesPer100: 884.0,
      proteinPer100: 0.0,
      carbsPer100: 0.0,
      fatPer100: 100.0,
      defaultAmount: 15.0,
      defaultPortionName: '1 Yemek Kaşığı (15 g)',
    ),
    const FoodItem(
      id: 'food_greek_yogurt',
      name: 'Süzme Yoğurt (%2 Yağlı)',
      category: 'Süt Ürünü',
      unit: FoodUnit.gram,
      caloriesPer100: 73.0,
      proteinPer100: 9.0,
      carbsPer100: 3.8,
      fatPer100: 2.0,
      defaultAmount: 150.0,
      defaultPortionName: '1 Kase (150 g)',
    ),
  ];

  late final DailyNutritionSummary _dailyNutrition = DailyNutritionSummary(
    targetCalories: 2450,
    targetProtein: 165.0,
    targetCarbs: 270.0,
    targetFat: 68.0,
    targetWaterMl: 3200,
    currentWaterMl: 1750,
    meals: [
      MealItem(
        id: 'm_1',
        food: _foodDatabase[12], // Yulaf Ezmesi
        amount: 80.0,            // 80 gram
        mealType: MealType.kahvalti,
        loggedAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      MealItem(
        id: 'm_2',
        food: _foodDatabase[1],  // Yarım Yağlı Süt
        amount: 250.0,           // 250 ml
        mealType: MealType.kahvalti,
        loggedAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      MealItem(
        id: 'm_3',
        food: _foodDatabase[10], // Izgara Tavuk Göğsü
        amount: 220.0,           // 220 gram
        mealType: MealType.ogle,
        loggedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      MealItem(
        id: 'm_4',
        food: _foodDatabase[13], // Basmati Pirinç
        amount: 200.0,           // 200 gram
        mealType: MealType.ogle,
        loggedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      MealItem(
        id: 'm_5',
        food: _foodDatabase[2],  // Ayran
        amount: 300.0,           // 300 ml
        mealType: MealType.ogle,
        loggedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  );

  List<FoodItem> get foodDatabase => List.unmodifiable(_foodDatabase);
  DailyNutritionSummary get dailyNutrition => _dailyNutrition;

  void addFoodLog({
    required FoodItem food,
    required double amount,
    required MealType mealType,
    bool addToHydration = true,
  }) {
    final meal = MealItem(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      food: food,
      amount: amount,
      mealType: mealType,
      loggedAt: DateTime.now(),
    );

    _dailyNutrition.meals.add(meal);

    // Eğer sıvı ve hidrasyona katkı sağlıyorsa otomatik su tüketimine ekle
    if (addToHydration && (food.unit == FoodUnit.ml || food.isHydrating)) {
      addWater(amount.round());
    }

    notifyListeners();
  }

  void deleteMeal(String mealId) {
    _dailyNutrition.meals.removeWhere((item) => item.id == mealId);
    notifyListeners();
  }

  void addWater(int ml) {
    _dailyNutrition.currentWaterMl = (_dailyNutrition.currentWaterMl + ml).clamp(0, 8000);
    notifyListeners();
  }

  void resetWater() {
    _dailyNutrition.currentWaterMl = 0;
    notifyListeners();
  }

  // --- 5. Gelişim, Kilo ve Vücut Ölçüleri ---
  final List<WeightRecord> _weightHistory = [
    WeightRecord(date: DateTime.now().subtract(const Duration(days: 30)), weightKg: 81.4),
    WeightRecord(date: DateTime.now().subtract(const Duration(days: 21)), weightKg: 80.6),
    WeightRecord(date: DateTime.now().subtract(const Duration(days: 14)), weightKg: 79.9),
    WeightRecord(date: DateTime.now().subtract(const Duration(days: 7)), weightKg: 79.2),
    WeightRecord(date: DateTime.now(), weightKg: 78.5, note: 'Sabah aç karnına ölçüm'),
  ];

  final List<BodyMeasurement> _measurements = [
    BodyMeasurement(
      date: DateTime.now().subtract(const Duration(days: 30)),
      chestCm: 104.0,
      waistCm: 86.0,
      armsCm: 37.5,
      hipsCm: 99.0,
      thighsCm: 59.0,
    ),
    BodyMeasurement(
      date: DateTime.now(),
      chestCm: 106.0,
      waistCm: 82.5,
      armsCm: 38.5,
      hipsCm: 98.0,
      thighsCm: 60.5,
    ),
  ];

  List<WeightRecord> get weightHistory => List.unmodifiable(_weightHistory);
  List<BodyMeasurement> get measurements => List.unmodifiable(_measurements);

  void addWeight(double weight, {String? note}) {
    _weightHistory.add(WeightRecord(
      date: DateTime.now(),
      weightKg: weight,
      note: note,
    ));
    notifyListeners();
  }

  void addMeasurement(BodyMeasurement measurement) {
    _measurements.add(measurement);
    notifyListeners();
  }

  @override
  void dispose() {
    _workoutTimer?.cancel();
    _restCountdownTimer?.cancel();
    super.dispose();
  }
}
