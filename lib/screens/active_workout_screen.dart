import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../models/exercise.dart';
import '../theme/app_theme.dart';
import 'exercise_video_screen.dart';

class ActiveWorkoutScreen extends StatelessWidget {
  const ActiveWorkoutScreen({Key? key}) : super(key: key);

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);
    final workout = provider.activeWorkout;

    if (workout == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Aktif Antrenman')),
        body: const Center(child: Text('Şu an aktif bir antrenman bulunmuyor.')),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workout.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Süre: ${_formatTime(provider.activeWorkoutSeconds)}',
              style: const TextStyle(fontSize: 13, color: AppTheme.greenNeon),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _showFinishDialog(context, provider);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.redPulse,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Bitir',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Dinlenme Sayacı Bildirim Çubuğu (Eğer çalışıyorsa)
          if (provider.isRestTimerRunning)
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.greenNeon.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.greenNeon.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(CupertinoIcons.timer, color: AppTheme.greenNeon),
                      const SizedBox(width: 8),
                      Text(
                        'Dinlenme Sayacı: ${_formatTime(provider.restSecondsRemaining)}',
                        style: const TextStyle(
                          color: AppTheme.greenNeon,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add, color: AppTheme.greenNeon),
                        onPressed: () => provider.addRestSeconds(30),
                        tooltip: '+30s',
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => provider.stopRestTimer(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workout.exercises.length,
              itemBuilder: (context, index) {
                final exercise = workout.exercises[index];
                final sets = provider.activeSets[exercise.id] ?? [];

                return _ExerciseWorkoutCard(
                  exercise: exercise,
                  sets: sets,
                  onToggleSet: (setIdx) {
                    provider.toggleSetCompletion(exercise.id, setIdx);
                  },
                  onAddSet: () {
                    provider.addSetToExercise(exercise.id);
                  },
                  onUpdateSet: (setIdx, reps, weight) {
                    provider.updateSet(exercise.id, setIdx, reps: reps, weight: weight);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFinishDialog(BuildContext context, FitnessProvider provider) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Antrenmanı Tamamla'),
        content: const Text('Harika bir seanstı! Antrenman verilerini kaydetmek istiyor musunuz?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Vazgeç', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(ctx);
              provider.cancelWorkout();
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Kaydet ve Bitir'),
            onPressed: () {
              provider.finishWorkout();
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _ExerciseWorkoutCard extends StatelessWidget {
  final Exercise exercise;
  final List<WorkoutSet> sets;
  final Function(int) onToggleSet;
  final VoidCallback onAddSet;
  final Function(int, int?, double?) onUpdateSet;

  const _ExerciseWorkoutCard({
    Key? key,
    required this.exercise,
    required this.sets,
    required this.onToggleSet,
    required this.onAddSet,
    required this.onUpdateSet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.cardSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
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
                icon: const Icon(CupertinoIcons.play_circle_fill, color: AppTheme.greenNeon, size: 26),
                tooltip: 'Formu Videolu İzle',
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => ExerciseVideoScreen(exercise: exercise)),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Başlık satırı
          const Row(
            children: [
              SizedBox(width: 36, child: Text('SET', style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold))),
              Expanded(child: Center(child: Text('AĞIRLIK (KG)', style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text('TEKRAR', style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold)))),
              SizedBox(width: 44, child: Center(child: Text('TAMAM', style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold)))),
            ],
          ),
          const Divider(color: AppTheme.cardSecondary, height: 16),

          // Set Satırları
          ...sets.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      '#${item.setNumber}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.cardSecondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${item.weightKg.toStringAsFixed(1)} kg',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.cardSecondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${item.reps} rep',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 44,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => onToggleSet(idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: item.isCompleted ? AppTheme.greenNeon : AppTheme.cardTertiary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: item.isCompleted ? Colors.black : Colors.white54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 10),
          GestureDetector(
            onTap: onAddSet,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme.cardSecondary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppTheme.redPulse, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '+ Set Ekle',
                    style: TextStyle(
                      color: AppTheme.redPulse,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
