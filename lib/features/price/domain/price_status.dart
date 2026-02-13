enum PriceVerificationStatus {
  pendingPrivate,
  awaitingConsensus,
  verifiedPublic,
}

extension PriceVerificationStatusX on PriceVerificationStatus {
  String get label {
    switch (this) {
      case PriceVerificationStatus.pendingPrivate:
        return 'Özel (Doğrulama Bekliyor)';
      case PriceVerificationStatus.awaitingConsensus:
        return 'Topluluk Doğrulaması Bekliyor';
      case PriceVerificationStatus.verifiedPublic:
        return 'Doğrulandı (Yayınlandı)';
    }
  }

  String get shortLabel {
    switch (this) {
      case PriceVerificationStatus.pendingPrivate:
        return 'Özel';
      case PriceVerificationStatus.awaitingConsensus:
        return 'Beklemede';
      case PriceVerificationStatus.verifiedPublic:
        return 'Doğrulandı';
    }
  }
}
