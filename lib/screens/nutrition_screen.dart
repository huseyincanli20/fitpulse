import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../models/nutrition.dart';
import '../theme/app_theme.dart';
import '../widgets/macro_progress_bar.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FitnessProvider>(context);
    final nutrition = provider.dailyNutrition;

    final waterLiters = (nutrition.currentWaterMl / 1000).toStringAsFixed(2);
    final targetWaterLiters = (nutrition.targetWaterMl / 1000).toStringAsFixed(1);
    final waterPercent = (nutrition.currentWaterMl / nutrition.targetWaterMl).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Beslenme & Hidrasyon'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.plus_circle_fill, color: AppTheme.orangeGlow, size: 28),
            onPressed: () => _showAddFoodModal(context, provider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Kalori Genel Özeti Kartı
            _buildCalorieCard(nutrition),

            const SizedBox(height: 20),

            // 2. Makro Besinler (Protein, Karbonhidrat, Yağ)
            _buildMacrosCard(nutrition),

            const SizedBox(height: 20),

            // 3. Su Tüketimi (Hidrasyon) Takibi
            _buildWaterCard(context, provider, waterLiters, targetWaterLiters, waterPercent),

            const SizedBox(height: 24),

            // 4. Günlük Öğünler Başlığı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tüketilen Yiyecek & İçecekler',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showAddFoodModal(context, provider),
                  child: const Text('+ Hesapla & Ekle', style: TextStyle(color: AppTheme.orangeGlow, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Öğün Listesi
            if (nutrition.meals.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Bugün henüz bir yiyecek veya içecek kaydetmediniz.',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              )
            else
              ...nutrition.meals.map((meal) => _buildMealTile(provider, meal)),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieCard(DailyNutritionSummary n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.cardSecondary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GÜNLÜK KALORİ DENGESİ',
                style: TextStyle(
                  color: AppTheme.orangeGlow,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${n.remainingCalories}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'kcal kaldı',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Hedef: ${n.targetCalories} kcal • Alınan: ${n.consumedCalories} kcal',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.orangeGlow.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(CupertinoIcons.flame_fill, color: AppTheme.orangeGlow, size: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildMacrosCard(DailyNutritionSummary n) {
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
            'MAKRO BESİN DAĞILIMI',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          MacroProgressBar(
            label: 'Protein (Kuvvet & Onarım)',
            current: n.consumedProtein,
            target: n.targetProtein,
            color: AppTheme.redPulse,
          ),
          const SizedBox(height: 16),
          MacroProgressBar(
            label: 'Karbonhidrat (Enerji)',
            current: n.consumedCarbs,
            target: n.targetCarbs,
            color: AppTheme.greenNeon,
          ),
          const SizedBox(height: 16),
          MacroProgressBar(
            label: 'Sağlıklı Yağlar (Hormonal Denge)',
            current: n.consumedFat,
            target: n.targetFat,
            color: AppTheme.orangeGlow,
          ),
        ],
      ),
    );
  }

  Widget _buildWaterCard(
    BuildContext context,
    FitnessProvider provider,
    String waterLiters,
    String targetWaterLiters,
    double waterPercent,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.cardSecondary),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.blueCyan.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(CupertinoIcons.drop_fill, color: AppTheme.blueCyan, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'HİDRASYON & SU TAKİBİ',
                        style: TextStyle(
                          color: AppTheme.blueCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$waterLiters / $targetWaterLiters Litre',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '%${(waterPercent * 100).toInt()}',
                style: const TextStyle(
                  color: AppTheme.blueCyan,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: waterPercent,
              minHeight: 10,
              backgroundColor: AppTheme.cardSecondary,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.blueCyan),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWaterQuickButton('+250 ml', () => provider.addWater(250)),
              _buildWaterQuickButton('+500 ml', () => provider.addWater(500)),
              _buildWaterQuickButton('Sıfırla', () => provider.resetWater(), isDestructive: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaterQuickButton(String label, VoidCallback onTap, {bool isDestructive = false}) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: isDestructive ? AppTheme.cardSecondary : const Color(0xFF0F323D),
      borderRadius: BorderRadius.circular(16),
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: isDestructive ? AppTheme.textSecondary : AppTheme.blueCyan,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMealTile(FitnessProvider provider, MealItem meal) {
    final isLiquid = meal.unit == FoodUnit.ml;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardSecondary.withOpacity(0.7)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isLiquid ? AppTheme.blueCyan : AppTheme.orangeGlow).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isLiquid ? CupertinoIcons.drop_fill : Icons.restaurant,
              color: isLiquid ? AppTheme.blueCyan : AppTheme.orangeGlow,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      meal.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: (isLiquid ? AppTheme.blueCyan : AppTheme.greenNeon).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${meal.amount.toInt()} ${meal.unitSymbol}',
                        style: TextStyle(
                          color: isLiquid ? AppTheme.blueCyan : AppTheme.greenNeon,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${meal.mealType.displayName} • P: ${meal.proteinGrams.toStringAsFixed(1)}g | K: ${meal.carbsGrams.toStringAsFixed(1)}g | Y: ${meal.fatGrams.toStringAsFixed(1)}g',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${meal.calories} kcal',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: () => provider.deleteMeal(meal.id),
                child: const Text('Sil', style: TextStyle(color: Colors.redAccent, fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- GERÇEK YİYECEK & İÇECEK ML / GRAM KALORİ HESAPLAYICI MODAL ---
  void _showAddFoodModal(BuildContext context, FitnessProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return _FoodCalculatorModal(provider: provider);
      },
    );
  }
}

class _FoodCalculatorModal extends StatefulWidget {
  final FitnessProvider provider;

  const _FoodCalculatorModal({Key? key, required this.provider}) : super(key: key);

  @override
  State<_FoodCalculatorModal> createState() => _FoodCalculatorModalState();
}

class _FoodCalculatorModalState extends State<_FoodCalculatorModal> {
  late FoodItem _selectedFood;
  double _amount = 100.0;
  MealType _selectedMealType = MealType.ogle;
  String _categoryFilter = 'Tümü'; // 'Tümü', 'İçecekler (ml)', 'Yiyecekler (g)'
  bool _addToHydration = true;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedFood = widget.provider.foodDatabase.first;
    _amount = _selectedFood.defaultAmount;
    _amountController.text = _amount.toInt().toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onFoodSelected(FoodItem food) {
    setState(() {
      _selectedFood = food;
      _amount = food.defaultAmount;
      _amountController.text = _amount.toInt().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLiquid = _selectedFood.unit == FoodUnit.ml;
    final unitSymbol = _selectedFood.unit.symbol;

    final calculatedCalories = _selectedFood.calculateCalories(_amount);
    final calculatedProtein = _selectedFood.calculateProtein(_amount);
    final calculatedCarbs = _selectedFood.calculateCarbs(_amount);
    final calculatedFat = _selectedFood.calculateFat(_amount);

    final filteredFoods = widget.provider.foodDatabase.where((item) {
      if (_categoryFilter == 'İçecekler (ml)') return item.unit == FoodUnit.ml;
      if (_categoryFilter == 'Yiyecekler (g)') return item.unit == FoodUnit.gram;
      return true;
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
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
            const SizedBox(height: 16),
            const Text(
              'Gerçek Besin & Kalori Hesaplayıcı',
              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Yiyecek veya içeceği seçip net gram/ml girerek tam besin değerlerini hesaplayın.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),

            const SizedBox(height: 16),

            // Kategori Filtre Butonları
            Row(
              children: ['Tümü', 'İçecekler (ml)', 'Yiyecekler (g)'].map((filter) {
                final isSelected = _categoryFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(filter),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    backgroundColor: AppTheme.cardSecondary,
                    selectedColor: isSelected && filter.contains('ml') ? AppTheme.blueCyan : AppTheme.orangeGlow,
                    checkmarkColor: Colors.black,
                    onSelected: (_) {
                      setState(() {
                        _categoryFilter = filter;
                        if (filteredFoods.isNotEmpty) {
                          _onFoodSelected(filteredFoods.first);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // Yiyecek / İçecek Seçici Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.cardSecondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardTertiary),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<FoodItem>(
                  value: filteredFoods.contains(_selectedFood) ? _selectedFood : filteredFoods.first,
                  isExpanded: true,
                  dropdownColor: AppTheme.cardSecondary,
                  icon: const Icon(CupertinoIcons.chevron_down, color: Colors.white70, size: 18),
                  items: filteredFoods.map((f) {
                    final isLiq = f.unit == FoodUnit.ml;
                    return DropdownMenuItem<FoodItem>(
                      value: f,
                      child: Row(
                        children: [
                          Icon(
                            isLiq ? CupertinoIcons.drop_fill : Icons.restaurant,
                            color: isLiq ? AppTheme.blueCyan : AppTheme.orangeGlow,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              f.name,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '100${f.unit.symbol} = ${f.caloriesPer100.round()} kcal',
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newFood) {
                    if (newFood != null) _onFoodSelected(newFood);
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tüketilen Miktar Girişi (Slider ve Metin Kutusu)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tüketilen Miktar ($unitSymbol)',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppTheme.cardSecondary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixText: unitSymbol,
                            suffixStyle: TextStyle(
                              color: isLiquid ? AppTheme.blueCyan : AppTheme.orangeGlow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onChanged: (val) {
                            final parsed = double.tryParse(val) ?? 0;
                            setState(() {
                              _amount = parsed.clamp(0, 3000);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                // Hızlı Porsiyon Butonları
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hızlı Porsiyon', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                    const SizedBox(height: 6),
                    Row(
                      children: isLiquid
                          ? [
                              _quickPortionBtn('100 ml', 100),
                              const SizedBox(width: 6),
                              _quickPortionBtn('250 ml (Bardak)', 250),
                              const SizedBox(width: 6),
                              _quickPortionBtn('330 ml', 330),
                            ]
                          : [
                              _quickPortionBtn('50 g', 50),
                              const SizedBox(width: 6),
                              _quickPortionBtn('100 g', 100),
                              const SizedBox(width: 6),
                              _quickPortionBtn('200 g', 200),
                            ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            // CANLI HESAPLAMA SONUÇ KARTLARI
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isLiquid
                      ? [const Color(0xFF072733), const Color(0xFF0F323D)]
                      : [const Color(0xFF2E1C0A), const Color(0xFF241505)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isLiquid ? AppTheme.blueCyan.withOpacity(0.4) : AppTheme.orangeGlow.withOpacity(0.4),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_amount.toInt()} $unitSymbol ${_selectedFood.name}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                '$calculatedCalories',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('kcal', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isLiquid ? AppTheme.blueCyan : AppTheme.orangeGlow).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isLiquid ? CupertinoIcons.drop_fill : CupertinoIcons.flame_fill,
                          color: isLiquid ? AppTheme.blueCyan : AppTheme.orangeGlow,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _calcMacroItem('Protein', '${calculatedProtein}g', AppTheme.redPulse),
                      _calcMacroItem('Karb', '${calculatedCarbs}g', AppTheme.greenNeon),
                      _calcMacroItem('Yağ', '${calculatedFat}g', AppTheme.orangeGlow),
                    ],
                  ),
                ],
              ),
            ),

            if (isLiquid) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  CupertinoSwitch(
                    value: _addToHydration,
                    activeColor: AppTheme.blueCyan,
                    onChanged: (v) => setState(() => _addToHydration = v),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Bu içeceği günlük su (hidrasyon) tüketimine otomatik ekle',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),

            // Kaydet Butonu
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                color: isLiquid ? AppTheme.blueCyan : AppTheme.orangeGlow,
                borderRadius: BorderRadius.circular(16),
                onPressed: () {
                  if (_amount > 0) {
                    widget.provider.addFoodLog(
                      food: _selectedFood,
                      amount: _amount,
                      mealType: _selectedMealType,
                      addToHydration: _addToHydration,
                    );
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  'Öğünü Günlüğe Ekle ($calculatedCalories kcal)',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickPortionBtn(String label, double val) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _amount = val;
          _amountController.text = val.toInt().toString();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.cardTertiary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _calcMacroItem(String title, String val, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          val,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
