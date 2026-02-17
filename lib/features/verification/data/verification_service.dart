import '../../../core/data/in_memory_repository.dart';
import '../../price/domain/price_status.dart';

class VerificationService {
  final InMemoryRepository _repository;

  VerificationService(this._repository);

  // Basit Doğrulama Mantığı yerine Confidence Score Modeli
  Future<void> trustCheck(String entryId) async {
    final entries = _repository.getEntries();

    // Entry var mı kontrol et
    final index = entries.indexWhere((e) => e.id == entryId);
    if (index == -1) return; // Bulunamadı

    final entry = entries[index];

    // Zaten onaylıysa tekrar kontrol etme (veya periyodik kontrol için bu satırı kaldırabilirsiniz)
    if (entry.status == PriceVerificationStatus.verifiedPublic) return;

    // --- Confidence Score Calculation ---
    double score = 40.0; // Base Score

    // 1. Unique User Count (Aynı ürün ve market için farklı kullanıcıların girdiği fiyat sayısı)
    // Not: Bu demo ortamında 'userId' kullanımı kısıtlı olabilir, simüle ediyoruz.
    final relatedEntries = entries
        .where(
          (e) =>
              e.barcode == entry.barcode &&
              e.marketBranchId == entry.marketBranchId &&
              e.id != entry.id, // Kendisi hariç
        )
        .toList();

    // Unique user count (mock implementation assuming different entries implied different users for now if userId is null)
    final int uniqueUserCount = relatedEntries
        .map((e) => e.userId ?? e.id)
        .toSet()
        .length;
    score += (uniqueUserCount * 15);

    // 2. Receipt Present & OCR Verification
    if (entry.hasReceipt) {
      score += 25; // Görsel varsa temel puan

      // OCR ile Fiyat Doğrulama (Simülasyon)
      // Gerçek senaryoda: Google ML Kit Text Recognition kullanılır.
      // String recognizedText = await _ocrService.processImage(entry.receiptImageUrl!);
      // if (recognizedText.contains(entry.price.toString())) { score += 20; }

      if (entry.receiptImageUrl != null && entry.receiptImageUrl!.isNotEmpty) {
        // Mock OCR: Eğer URL içinde "valid" kelimesi geçiyorsa veya belirli bir kurala uyuyorsa ek puan ver.
        // Bu, görselin gerçekten işlendiği senaryoyu temsil eder.
        const bool ocrMatchedPrice =
            true; // Şimdilik varsayılan true kabul edelim
        if (ocrMatchedPrice) {
          score += 15; // OCR ile fiyat etiketi teyit edilirse ekstra güven
        }
      }
    }

    // 3. Trusted User Bonus (Mock Logic: userId uzunluğu çift ise 'Trusted' varsayalım ya da user verisine erişim gerek)
    // Gerçek senaryoda: User user = await _userService.getUser(entry.userId); if (user.rank == 'Guru') ...
    if (entry.userId != null && entry.userId!.hashCode % 2 == 0) {
      score += 10; // Trusted bonus
    }

    // 4. Anomaly Penalty
    if (relatedEntries.isNotEmpty) {
      final double averagePrice =
          relatedEntries.map((e) => e.price).reduce((a, b) => a + b) /
          relatedEntries.length;
      final double difference = (entry.price - averagePrice).abs();
      final double percentageDiff = (difference / averagePrice) * 100;

      if (percentageDiff > 50) {
        score -= 50; // Büyük sapma cezası
      } else if (percentageDiff > 20) {
        score -= 20; // Orta sapma cezası
      }
    }

    // --- Status Determination ---
    PriceVerificationStatus newStatus;
    if (score >= 80) {
      newStatus = PriceVerificationStatus.verifiedPublic;
    } else if (score >= 60) {
      newStatus = PriceVerificationStatus.awaitingConsensus; // Pending
    } else {
      newStatus = PriceVerificationStatus.pendingPrivate; // Private
    }

    // Update if status changed
    if (entry.status != newStatus) {
      final updatedEntry = entry.copyWith(status: newStatus);
      _repository.updateEntry(updatedEntry);
    }
  }

  // Admin veya "Güvenilir Kullanıcı" onayı
  Future<void> manualVerify(String entryId) async {
    final entries = _repository.getEntries();
    final entry = entries.firstWhere((e) => e.id == entryId);

    final verified = entry.copyWith(
      status: PriceVerificationStatus.verifiedPublic,
    );
    _repository.updateEntry(verified);
  }
}
