import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import '../theme/app_theme.dart';
import '../widgets/activity_ring.dart';
import 'active_workout_screen.dart';
import 'exercise_video_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  String _selectedCategory = 'Tümü';
  final List<String> _categories = ['Tümü', 'Göğüs', 'Sırt', 'Bacak', 'Omuz', 'Kol', 'Karın'];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);

    final filteredExercises = _selectedCategory == 'Tümü'
        ? provider.exerciseDatabase
        : provider.exerciseDatabase.where((e) => e.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Antrenman'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.flame_fill, color: AppTheme.redPulse),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Günlük Aktivite Özeti & Halka
            _buildActivityHeader(provider),

            const SizedBox(height: 24),

            // 2. Devam Eden Antrenman Banner'ı
            if (provider.isWorkoutActive) ...[
              _buildActiveWorkoutBanner(context, provider),
              const SizedBox(height: 24),
            ],

            // 3. Antrenman Planları
            const Text(
              'Günün Programları',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            ...provider.workoutPlans.map((plan) => _buildPlanCard(context, provider, plan)),

            const SizedBox(height: 28),

            // 4. Egzersiz Kütüphanesi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Egzersiz Kütüphanesi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  '${filteredExercises.length} Hareket',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Kategori Filtreleri
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      backgroundColor: AppTheme.cardBackground,
                      selectedColor: AppTheme.greenNeon,
                      checkmarkColor: Colors.black,
                      side: BorderSide(
                        color: isSelected ? AppTheme.greenNeon : AppTheme.cardSecondary,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 14),

            // Egzersiz Listesi
            ...filteredExercises.map((exercise) => _buildExerciseTile(context, exercise)),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityHeader(FitnessProvider provider) {
    final caloriesBurned = provider.workoutHistory.isNotEmpty
        ? provider.workoutHistory.fold<int>(0, (s, w) => s + w.totalCalories)
        : 450;
    final moveProgress = (caloriesBurned / 650.0).clamp(0.0, 1.2);
    final exerciseProgress = 0.75;
    final standProgress = (provider.dailyNutrition.currentWaterMl / 3000.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.cardSecondary),
      ),
      child: Row(
        children: [
          ActivityRingsWidget(
            moveProgress: moveProgress,
            exerciseProgress: exerciseProgress,
            standProgress: standProgress,
            size: 110,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRingMetric('HAREKET', '$caloriesBurned / 650 kcal', AppTheme.redPulse),
                const SizedBox(height: 8),
                _buildRingMetric('EGZERSİZ', '45 / 60 dk', AppTheme.greenNeon),
                const SizedBox(height: 8),
                _buildRingMetric(
                  'HİDRASYON',
                  '${(provider.dailyNutrition.currentWaterMl / 1000).toStringAsFixed(1)} / 3.0 L',
                  AppTheme.blueCyan,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRingMetric(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveWorkoutBanner(BuildContext context, FitnessProvider provider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => const ActiveWorkoutScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E0808), Color(0xFF1F0505)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.redPulse.withOpacity(0.6), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppTheme.redPulse,
                shape: BoxShape.circle,
              ),
              child: const Icon(CupertinoIcons.play_arrow_solid, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ANTRENMAN SÜRÜYOR',
                    style: TextStyle(
                      color: AppTheme.redPulse,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    provider.activeWorkout?.title ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(CupertinoIcons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, FitnessProvider provider, WorkoutPlan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cardSecondary),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.redPulse.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.fitness_center, color: AppTheme.redPulse, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${plan.estimatedMinutes} dk • ${plan.estimatedCalories} kcal • ${plan.exercises.length} hareket',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.cardSecondary,
            borderRadius: BorderRadius.circular(20),
            onPressed: () {
              provider.startWorkout(plan);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const ActiveWorkoutScreen()),
              );
            },
            child: const Text(
              'Başla',
              style: TextStyle(
                color: AppTheme.greenNeon,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseTile(BuildContext context, Exercise exercise) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => ExerciseVideoScreen(exercise: exercise)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardSecondary.withOpacity(0.6)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.greenNeon.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(CupertinoIcons.play_arrow_solid, color: AppTheme.greenNeon, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${exercise.category} • ${exercise.targetMuscle}',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.play_circle_fill, color: AppTheme.greenNeon, size: 24),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => ExerciseVideoScreen(exercise: exercise)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showExerciseDetail(BuildContext context, Exercise exercise) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.cardTertiary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                exercise.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${exercise.category} | ${exercise.targetMuscle}',
                style: const TextStyle(color: AppTheme.greenNeon, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(
                exercise.description,
                style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoBadge('Ekipman', exercise.equipment),
                  _infoBadge('Varsayılan Set', '${exercise.defaultSets} Set'),
                  _infoBadge('Varsayılan Tekrar', '${exercise.defaultReps} Rep'),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: AppTheme.greenNeon,
                  borderRadius: BorderRadius.circular(16),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => ExerciseVideoScreen(exercise: exercise)),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.play_arrow_solid, color: Colors.black, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Videolu Anlatımı İzle',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _infoBadge(String label, String val) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}
