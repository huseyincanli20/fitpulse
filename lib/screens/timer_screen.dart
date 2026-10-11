import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../theme/app_theme.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

enum IntervalPhase { idle, getReady, work, rest, finished }

class _TimerScreenState extends State<TimerScreen> with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0; // 0: Dinlenme Sayacı, 1: HIIT / Tabata

  // HIIT / Tabata Değişkenleri
  int _workDuration = 30; // saniye
  int _restDuration = 15; // saniye
  int _totalRounds = 8;
  int _currentRound = 1;
  int _secondsLeft = 30;
  IntervalPhase _phase = IntervalPhase.idle;
  Timer? _intervalTimer;

  @override
  void dispose() {
    _intervalTimer?.cancel();
    super.dispose();
  }

  void _startIntervalTimer() {
    _intervalTimer?.cancel();
    setState(() {
      _currentRound = 1;
      _phase = IntervalPhase.getReady;
      _secondsLeft = 5;
    });

    _intervalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _advancePhase();
      }
    });
  }

  void _advancePhase() {
    if (_phase == IntervalPhase.getReady) {
      setState(() {
        _phase = IntervalPhase.work;
        _secondsLeft = _workDuration;
      });
    } else if (_phase == IntervalPhase.work) {
      setState(() {
        _phase = IntervalPhase.rest;
        _secondsLeft = _restDuration;
      });
    } else if (_phase == IntervalPhase.rest) {
      if (_currentRound < _totalRounds) {
        setState(() {
          _currentRound++;
          _phase = IntervalPhase.work;
          _secondsLeft = _workDuration;
        });
      } else {
        setState(() {
          _phase = IntervalPhase.finished;
          _intervalTimer?.cancel();
        });
      }
    }
  }

  void _pauseIntervalTimer() {
    _intervalTimer?.cancel();
    setState(() {
      _phase = IntervalPhase.idle;
    });
  }

  void _resetIntervalTimer() {
    _intervalTimer?.cancel();
    setState(() {
      _phase = IntervalPhase.idle;
      _currentRound = 1;
      _secondsLeft = _workDuration;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fitnessProvider = Provider.of<FitnessProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Zamanlayıcı & Sayaç'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // iOS Tarzı Segmented Control
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton('Set Dinlenme', 0),
                  ),
                  Expanded(
                    child: _buildTabButton('HIIT / Tabata', 1),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (_selectedTabIndex == 0)
              _buildRestTimerView(fitnessProvider)
            else
              _buildIntervalTimerView(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.cardSecondary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // --- 1. Dinlenme Sayacı Görünümü ---
  Widget _buildRestTimerView(FitnessProvider provider) {
    final seconds = provider.restSecondsRemaining;
    final total = provider.totalRestSeconds > 0 ? provider.totalRestSeconds : 90;
    final progress = total > 0 ? (seconds / total) : 0.0;

    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        const SizedBox(height: 10),
        // Büyük Dairesel Sayaç
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 230,
              height: 230,
              child: CircularProgressIndicator(
                value: provider.isRestTimerRunning ? progress : 1.0,
                strokeWidth: 14,
                backgroundColor: AppTheme.cardSecondary,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.greenNeon),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  provider.isRestTimerRunning ? '$mins:$secs' : '01:30',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.isRestTimerRunning ? 'DİNLENME SÜRESİ' : 'HAZIR',
                  style: const TextStyle(
                    color: AppTheme.greenNeon,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 36),

        // Hızlı Butonlar (30s, 60s, 90s, 120s)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [30, 60, 90, 120].map((s) {
            return CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
              onPressed: () => provider.startRestTimer(s),
              child: Text(
                '${s}s',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        // Başlat / Durdur Kontrolleri
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (provider.isRestTimerRunning) ...[
              CupertinoButton(
                color: AppTheme.cardSecondary,
                borderRadius: BorderRadius.circular(30),
                onPressed: () => provider.addRestSeconds(30),
                child: const Text('+30 sn Ekle', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 14),
              CupertinoButton(
                color: AppTheme.redPulse,
                borderRadius: BorderRadius.circular(30),
                onPressed: () => provider.stopRestTimer(),
                child: const Text('Durdur', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ] else ...[
              CupertinoButton(
                color: AppTheme.greenNeon,
                borderRadius: BorderRadius.circular(30),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                onPressed: () => provider.startRestTimer(90),
                child: const Text(
                  'Sayacı Başlat (90s)',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // --- 2. HIIT & Tabata Sayaç Görünümü ---
  Widget _buildIntervalTimerView() {
    Color phaseColor;
    String phaseText;

    switch (_phase) {
      case IntervalPhase.getReady:
        phaseColor = AppTheme.orangeGlow;
        phaseText = 'HAZIRLAN';
        break;
      case IntervalPhase.work:
        phaseColor = AppTheme.greenNeon;
        phaseText = 'ÇALIŞ! (WORK)';
        break;
      case IntervalPhase.rest:
        phaseColor = AppTheme.redPulse;
        phaseText = 'DİNLEN (REST)';
        break;
      case IntervalPhase.finished:
        phaseColor = AppTheme.blueCyan;
        phaseText = 'TAMAMLANDI!';
        break;
      case IntervalPhase.idle:
      default:
        phaseColor = AppTheme.textSecondary;
        phaseText = 'BAŞLAMAYA HAZIR';
        break;
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        // Faz ve Tur Göstergesi
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: phaseColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: phaseColor.withOpacity(0.5)),
          ),
          child: Text(
            phaseText,
            style: TextStyle(color: phaseColor, fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ),

        const SizedBox(height: 20),

        // Zaman Sayacı
        Text(
          '$_secondsLeft',
          style: TextStyle(
            color: phaseColor == AppTheme.textSecondary ? Colors.white : phaseColor,
            fontSize: 84,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
          ),
        ),

        Text(
          'TUR $_currentRound / $_totalRounds',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 30),

        // Ayarlar (Sadece Duraklatılmış/Boşta iken değiştirilebilir)
        if (_phase == IntervalPhase.idle) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.cardSecondary),
            ),
            child: Column(
              children: [
                _buildIntervalSlider('Çalışma Süresi', '$_workDuration sn', _workDuration.toDouble(), 10, 60, (v) {
                  setState(() {
                    _workDuration = v.toInt();
                    _secondsLeft = _workDuration;
                  });
                }),
                const Divider(color: AppTheme.cardSecondary),
                _buildIntervalSlider('Dinlenme Süresi', '$_restDuration sn', _restDuration.toDouble(), 5, 45, (v) {
                  setState(() => _restDuration = v.toInt());
                }),
                const Divider(color: AppTheme.cardSecondary),
                _buildIntervalSlider('Toplam Tur Sayısı', '$_totalRounds Tur', _totalRounds.toDouble(), 3, 20, (v) {
                  setState(() => _totalRounds = v.toInt());
                }),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Başlat / Duraklat / Sıfırla Butonları
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_phase == IntervalPhase.idle)
              CupertinoButton(
                color: AppTheme.greenNeon,
                borderRadius: BorderRadius.circular(30),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                onPressed: _startIntervalTimer,
                child: const Text(
                  'HIIT Başlat',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )
            else ...[
              CupertinoButton(
                color: AppTheme.cardSecondary,
                borderRadius: BorderRadius.circular(30),
                onPressed: _resetIntervalTimer,
                child: const Text('Sıfırla', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 16),
              CupertinoButton(
                color: AppTheme.redPulse,
                borderRadius: BorderRadius.circular(30),
                onPressed: _pauseIntervalTimer,
                child: const Text('Durdur', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildIntervalSlider(String label, String valueLabel, double val, double min, double max, ValueChanged<double> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        Text(valueLabel, style: const TextStyle(color: AppTheme.greenNeon, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
