import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/exercise.dart';
import '../theme/app_theme.dart';

class ExerciseVideoScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseVideoScreen({Key? key, required this.exercise}) : super(key: key);

  @override
  State<ExerciseVideoScreen> createState() => _ExerciseVideoScreenState();
}

class _ExerciseVideoScreenState extends State<ExerciseVideoScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.exercise.videoUrl),
    )..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      }).catchError((error) {
        debugPrint('Video yüklenirken hata oluştu: $error');
      });

    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Text(
          e.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Video Oynatıcı Alanı (16:9 Aspect Ratio)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isInitialized)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showControls = !_showControls;
                          });
                        },
                        child: VideoPlayer(_controller),
                      )
                    else
                      Container(
                        color: const Color(0xFF151518),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: AppTheme.greenNeon),
                              SizedBox(height: 12),
                              Text(
                                'Video yükleniyor...',
                                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Kontroller Katmanı
                    if (_isInitialized && _showControls)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showControls = !_showControls;
                          });
                        },
                        child: Container(
                          color: Colors.black38,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(height: 10),
                              // Orta Oynat / Duraklat Butonu
                              IconButton(
                                iconSize: 56,
                                icon: Icon(
                                  _controller.value.isPlaying
                                      ? CupertinoIcons.pause_circle_fill
                                      : CupertinoIcons.play_circle_fill,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  });
                                },
                              ),
                              // Alt Süre Çubuğu
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      _formatDuration(_controller.value.position),
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    Expanded(
                                      child: VideoProgressIndicator(
                                        _controller,
                                        allowScrubbing: true,
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        colors: const VideoProgressColors(
                                          playedColor: AppTheme.greenNeon,
                                          bufferedColor: Colors.white24,
                                          backgroundColor: Colors.white10,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(_controller.value.duration),
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 2. Egzersiz Başlık ve Hedef Kas Bilgileri
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.redPulse.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.redPulse.withOpacity(0.4)),
                        ),
                        child: Text(
                          e.category.toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.redPulse,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.gauge, color: AppTheme.greenNeon, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Hedef: ${e.defaultSets} Set × ${e.defaultReps} Tekrar',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    e.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hedef Kas: ${e.targetMuscle} • Ekipman: ${e.equipment}',
                    style: const TextStyle(color: AppTheme.greenNeon, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    e.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                  ),

                  const SizedBox(height: 24),

                  // 3. Adım Adım Doğru Form Talimatları
                  const Text(
                    'Adım Adım Doğru Form (Nasıl Yapılır?)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...e.executionSteps.asMap().entries.map((step) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cardSecondary),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppTheme.greenNeon.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${step.key + 1}',
                              style: const TextStyle(
                                color: AppTheme.greenNeon,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              step.value,
                              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  // 4. Sık Yapılan Hatalar & Önlemler
                  if (e.commonMistakes.isNotEmpty) ...[
                    const Text(
                      'Kaçınılması Gereken Hatalar ⚠️',
                      style: TextStyle(
                        color: AppTheme.redPulse,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...e.commonMistakes.map((mistake) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF220A0A),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.redPulse.withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(CupertinoIcons.xmark_circle_fill, color: AppTheme.redPulse, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                mistake,
                                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],

                  const SizedBox(height: 36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
