# FitPulse - iOS Fitness & Antrenman Takip Uygulaması 🏋️‍♂️🔥

FitPulse, iOS (iPhone & iPad) odaklı, modern Cupertino & Material 3 tasarım dilini harmanlayan, Apple Fitness halkaları tarzı görselleştirmelere sahip kapsamlı bir Flutter fitness uygulamasıdır.

---

## 📱 Temel Özellikler

1. **Antrenman & Egzersiz Takibi**:
   - Push / Pull / Leg ve özel antrenman programları
   - Canlı seans takibi: Set, tekrar, ağırlık (kg) kaydetme ve tek dokunuşla tamamlama
   - Kas grubu ve ekipman filtreli zengin Egzersiz Kütüphanesi
   - Toplam kaldırılan hacim (Volume Kg) ve yakılan kalori hesaplama

2. **Zamanlayıcı & Kronometre**:
   - Otomatik Set Dinlenme Sayacı (30s, 60s, 90s, 120s hızlı seçimler)
   - HIIT / Tabata İnterval Sayacı (Çalışma süresi, dinlenme süresi, tur sayısı ve dinamik ses/renk fazları)

3. **Beslenme, Makro ve Su Takibi**:
   - Günlük kalori bütçesi (Alınan / Kalan kalori hesabı)
   - Makro besin göstergeleri (Protein, Karbonhidrat, Sağlıklı Yağlar)
   - Günlük su tüketimi (Hidrasyon) takibi (+250 ml, +500 ml hızlı ekleme)
   - Öğün ve yiyecek ekleme / silme yönetimi

4. **Gelişim Takibi & Vücut Ölçüleri**:
   - Kilo değişim trendi ve görsel sütun grafiği
   - Vücut ölçüleri matrisi (Göğüs, Bel, Kol, Bacak) ve önceki ölçümle kıyaslama
   - Tamamlanan antrenmanların detaylı geçmiş günlüğü

---

## 📁 Proje Dizin Yapısı

```
fitpulse/
├── lib/
│   ├── main.dart                          # Ana başlatıcı ve tema yapılandırması
│   ├── theme/
│   │   └── app_theme.dart                 # iOS Apple Fitness renk paleti & karanlık tema
│   ├── models/
│   │   ├── exercise.dart                  # Egzersiz ve set veri modelleri
│   │   ├── workout.dart                   # Antrenman planı ve geçmiş modelleri
│   │   ├── nutrition.dart                 # Kalori, makro ve öğün modelleri
│   │   └── body_stat.dart                 # Kilo ve vücut ölçü modelleri
│   ├── providers/
│   │   └── fitness_provider.dart          # Tüm modüllerin reaktif state yöneticisi
│   ├── screens/
│   │   ├── main_navigation_screen.dart    # iOS bulanık cam efektli alt menü
│   │   ├── workout_screen.dart            # Antrenman ana ekranı & halkalar
│   │   ├── active_workout_screen.dart     # Canlı seans ve set kontrol ekranı
│   │   ├── timer_screen.dart              # Dinlenme & Tabata interval ekranı
│   │   ├── nutrition_screen.dart          # Beslenme & hidrasyon ekranı
│   │   └── progress_screen.dart           # Kilo grafiği & vücut ölçüleri
│   └── widgets/
│       ├── activity_ring.dart             # Apple Fitness halkaları CustomPainter
│       ├── stat_card.dart                 # Modern iOS istatistik kartları
│       └── macro_progress_bar.dart        # Makro ilerleme çubukları
├── ios/
│   └── Runner/
│       └── Info.plist                     # HealthKit ve iOS izin tanımlamaları
└── pubspec.yaml                           # Bağımlılıklar ve paket konfigürasyonu
```

---

## 🚀 Windows Ortamında Flutter Kurulumu ve Çalıştırma

### 1. Flutter SDK Kurulumu (Eğer sisteminizde yüklü değilse)
Windows terminalinde `winget` ile Flutter'ı hızlıca kurabilirsiniz:
```powershell
winget install Google.Flutter
```
Veya [flutter.dev](https://flutter.dev) adresinden Flutter SDK zip dosyasını indirip `C:\src\flutter` konumuna çıkartın ve PATH değişkenine ekleyin.

### 2. Bağımlılıkları İndirme
```powershell
cd C:\Users\husey\.gemini\antigravity\scratch\fitpulse
flutter pub get
```

### 3. Windows veya Tarayıcıda Anında Önizleme
Windows üzerinde geliştirme yaparken arayüzü anında görmek için:
```powershell
flutter run -d chrome
# veya
flutter run -d windows
```

---

## 📲 iOS Cihaza (iPhone) Yükleme Yolları

1. **Mac Bilgisayar ile:**
   - Projeyi Mac ortamına aktarın veya Git ile çekin.
   - Terminalde `open ios/Runner.xcworkspace` komutuyla Xcode'u açın.
   - Geliştirici Apple ID'nizi `Signing & Capabilities` sekmesinde seçin.
   - iPhone'unuzu kabloyla bağlayıp **Run** (Cmd + R) butonuna basarak doğrudan telefonunuza yükleyin.

2. **Windows Üzerinden Mac Olmadan Bulut CI/CD ile (Codemagic / GitHub Actions):**
   - Ücretsiz GitHub Actions veya Codemagic iş akışı ile Flutter projeniz doğrudan Apple TestFlight'a veya imzalı `.ipa` çıktısına dönüştürülebilir.
