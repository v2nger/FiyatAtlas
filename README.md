# fiyatatlas

MVP: Kullanıcıların barkod tarayarak fiyat girmesi ve doğrulama akışına göre
“özel” ve “doğrulanmış” kayıtları ayıran Flutter uygulaması.

## Özellikler

- Barkod tarama ekranı (placeholder)
- Gelişmiş Fiyat Girişi:
  - Market ve Şube filtreleme / arama
  - Listede olmayan marketi anında ekleme
  - Ürün arama (Autocomplete) ve barkod girişi
  - Stok Var/Yok durumu bildirimi
- Arama Ekranı: Ürün ve Market bazlı global arama
- Doğrulama durumları (özel/beklemede/doğrulandı)
- Yerel (in-memory) veri deposu

## Kurulum

1) Flutter SDK kurulu olmalı.
2) Bağımlılıkları indir:

flutter pub get

## Çalıştırma

flutter run

## Notlar

- Gerçek barkod tarama ve OCR modülü MVP sonrası eklenecek.
- Doğrulama mantığı şu an prototip seviyede; backend eklendiğinde güncellenecek.
