import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/fitness_provider.dart';
import '../models/body_stat.dart';
import '../models/workout.dart';
import '../theme/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);
    final weightHistory = provider.weightHistory;
    final measurements = provider.measurements;
    final currentWeight = weightHistory.isNotEmpty ? weightHistory.last.weightKg : 0.0;
    final startWeight = weightHistory.isNotEmpty ? weightHistory.first.weightKg : 0.0;
    final weightDiff = currentWeight - startWeight;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Gelişim & İstatistikler'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add, color: AppTheme.purpleNeon),
            onPressed: () => _showAddWeightDialog(context, provider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Kilo Değişim Özeti Kartı
            _buildWeightSummaryCard(context, provider, currentWeight, weightDiff),

            const SizedBox(height: 20),

            // 2. Kilo Geçmişi Görsel Grafiği
            _buildWeightChart(weightHistory),

            const SizedBox(height: 24),

            // 3. Vücut Ölçüleri Matrisi
            _buildMeasurementsSection(context, provider, measurements),

            const SizedBox(height: 24),

            // 4. Tamamlanan Antrenman Geçmişi
            _buildWorkoutHistorySection(provider.workoutHistory),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightSummaryCard(
    BuildContext context,
    FitnessProvider provider,
    double currentWeight,
    double diff,
  ) {
    final isLoss = diff <= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.cardSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'GÜNCEL VÜCUT AĞIRLIĞI',
                style: TextStyle(
                  color: AppTheme.purpleNeon,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showAddWeightDialog(context, provider),
                child: const Text('+ Kilo Ekle', style: TextStyle(color: AppTheme.purpleNeon, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                currentWeight.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'kg',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: (isLoss ? AppTheme.greenNeon : AppTheme.redPulse).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isLoss ? CupertinoIcons.arrow_down_right : CupertinoIcons.arrow_up_right,
                      color: isLoss ? AppTheme.greenNeon : AppTheme.redPulse,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${diff.abs().toStringAsFixed(1)} kg',
                      style: TextStyle(
                        color: isLoss ? AppTheme.greenNeon : AppTheme.redPulse,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChart(List<WeightRecord> history) {
    if (history.isEmpty) return const SizedBox.shrink();

    final maxW = history.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b);
    final minW = history.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b);
    final span = (maxW - minW) == 0 ? 1.0 : (maxW - minW);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.cardSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'KİLO DEĞİŞİM GRAFİĞİ',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: history.map((record) {
                final ratio = ((record.weightKg - minW) / span).clamp(0.2, 1.0);
                final formattedDate = DateFormat('dd MMM').format(record.date);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${record.weightKg}',
                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 28,
                      height: 70 * ratio,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.purpleNeon, Color(0xFF673AB7)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formattedDate,
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 10),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementsSection(
    BuildContext context,
    FitnessProvider provider,
    List<BodyMeasurement> list,
  ) {
    final latest = list.isNotEmpty ? list.last : null;
    final previous = list.length > 1 ? list.first : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.cardSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'VÜCUT ÖLÇÜLERİ (CM)',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const Icon(CupertinoIcons.chart_bar_square, color: AppTheme.purpleNeon, size: 18),
            ],
          ),
          const SizedBox(height: 16),
          if (latest != null) ...[
            _measurementRow('Göğüs', latest.chestCm, previous?.chestCm),
            const Divider(color: AppTheme.cardSecondary, height: 16),
            _measurementRow('Bel', latest.waistCm, previous?.waistCm, isWaist: true),
            const Divider(color: AppTheme.cardSecondary, height: 16),
            _measurementRow('Kol (Biceps)', latest.armsCm, previous?.armsCm),
            const Divider(color: AppTheme.cardSecondary, height: 16),
            _measurementRow('Bacak (Uyluk)', latest.thighsCm, previous?.thighsCm),
          ],
        ],
      ),
    );
  }

  Widget _measurementRow(String label, double current, double? prev, {bool isWaist = false}) {
    final diff = prev != null ? current - prev : 0.0;
    // Bel için küçülme olumlu, diğer kas grupları için büyüme olumludur
    final isGood = isWaist ? diff <= 0 : diff >= 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
        Row(
          children: [
            Text(
              '${current.toStringAsFixed(1)} cm',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            if (prev != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isGood ? AppTheme.greenNeon : AppTheme.redPulse).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(1)} cm',
                  style: TextStyle(
                    color: isGood ? AppTheme.greenNeon : AppTheme.redPulse,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildWorkoutHistorySection(List<CompletedWorkout> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Geçmiş Antrenmanlar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        if (history.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Tamamlanan antrenman bulunmuyor.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
          )
        else
          ...history.map((h) {
            final dateStr = DateFormat('dd MMMM, HH:mm').format(h.date);
            final durationMins = (h.durationSeconds ~/ 60);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.cardSecondary),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.redPulse.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(CupertinoIcons.checkmark_seal_fill, color: AppTheme.redPulse, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h.title,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$dateStr • $durationMins dk',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${h.totalCalories} kcal',
                        style: const TextStyle(color: AppTheme.redPulse, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${h.totalVolumeKg.toStringAsFixed(0)} kg hacim',
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  void _showAddWeightDialog(BuildContext context, FitnessProvider provider) {
    final ctrl = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Yeni Kilo Kaydı'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            controller: ctrl,
            placeholder: 'Örn: 78.2',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('İptal'),
            onPressed: () => Navigator.pop(ctx),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Kaydet'),
            onPressed: () {
              final w = double.tryParse(ctrl.text);
              if (w != null && w > 30) {
                provider.addWeight(w);
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
