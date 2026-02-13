# CI/CD Pipeline Documentation

Bu proje GitHub Actions kullanılarak otomatik test ve derleme süreçlerine (CI/CD) sahiptir.

## İş Akışı (.github/workflows/flutter_ci.yml)

Bu iş akışı `main` dalına yapılan her `push` ve `pull request` işleminde tetiklenir.

### Adımlar:
1.  **Checkout:** Kod deposunu çeker.
2.  **Setup Java & Flutter:** Android derlemesi ve Flutter komutları için gerekli ortamı kurar.
3.  **Install Dependencies:** `flutter pub get` ile kütüphaneleri yükler.
4.  **Codegen:** `build_runner` çalıştırarak Riverpod vb. için gerekli kodları üretir.
5.  **Analyze:** Kod kalitesini ve hatalarını `flutter analyze` ile kontrol eder.
6.  **Test:** Birim ve widget testlerini `flutter test` ile çalıştırır.
7.  **Build APK:** Projenin hatasız derlendiğini doğrulamak için `flutter build apk` komutunu çalıştırır.
8.  **Artifact Upload:** Başarılı derleme sonrası APK dosyasını GitHub Actions "Artifacts" sekmesine yükler.

## Nasıl Kullanılır?

GitHub'a kodunuzu gönderdiğinizde (Push), "Actions" sekmesinden sürecin ilerleyişini takip edebilirsiniz.
