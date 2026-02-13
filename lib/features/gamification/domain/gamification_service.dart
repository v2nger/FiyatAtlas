import '../../auth/domain/user.dart';
import '../../price/domain/price_entry.dart';
import '../../product/domain/product.dart';
import '../../market/domain/market_branch.dart';

class GamificationService {
  /// Evaluates the user's current status and the new entry to determine
  /// if any new badges should be awarded.
  /// 
  /// Returns a list of NEW badge IDs earned with this action.
  List<String> checkBadges({
    required User user,
    required PriceEntry newEntry,
    required List<Product> allProducts,
    required List<MarketBranch> allBranches,
    required List<PriceEntry> userPastEntries,
  }) {
    final currentBadges = user.earnedBadgeIds;
    final newBadges = <String>[];

    // Helper: Add if not already owned and not already added in this session
    void unlock(String badgeId) {
      if (!currentBadges.contains(badgeId) && !newBadges.contains(badgeId)) {
        newBadges.add(badgeId);
      }
    }

    // --- 1. Level & Entry Count (Rank) ---
    // Note: user.entryCount is the count BEFORE this new entry usually, 
    // or updated just before calling this. 
    // Let's assume we are passing the UPDATED count or calculating based on history length.
    // For safety, let's use userPastEntries.length + 1 (the new one).
    final totalEntries = userPastEntries.length + 1;

    if (totalEntries >= 1) unlock('acemi_kasif');
    if (totalEntries >= 10) unlock('cirak');
    if (totalEntries >= 50) unlock('kalfa');
    if (totalEntries >= 100) unlock('usta');
    if (totalEntries >= 250) unlock('ustat');
    if (totalEntries >= 500) unlock('efsane');
    if (totalEntries >= 1000) unlock('fiyat_makinesi');
    if (totalEntries >= 5000) unlock('atlas_efendisi');

    // --- 3. Technology & Evidence ---
    if (newEntry.barcode.length > 3) {
      final barcodeCount = userPastEntries.where((e) => e.barcode.length > 3).length + 1;
      if (barcodeCount >= 10) unlock('barkodcu');
      if (barcodeCount >= 100) unlock('lazer_goz');
    } else {
      unlock('manuel_giris');
    }

    if (newEntry.hasReceipt) {
      final receiptCount = userPastEntries.where((e) => e.hasReceipt).length + (newEntry.hasReceipt ? 1 : 0);
      if (receiptCount >= 10) unlock('fis_toplayici');
      if (receiptCount >= 50) unlock('foto_muhabiri');
    }

    // --- 4. Time Zones ---
    final hour = newEntry.entryDate.hour;
    if (hour >= 5 && hour < 8) unlock('erkenci_kus');
    if (hour >= 23 || hour < 5) unlock('gece_kusu');
    if (hour >= 12 && hour < 14) unlock('ogle_arasi');

    final weekday = newEntry.entryDate.weekday;
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      unlock('hafta_sonu'); 
    }
    
    if (newEntry.entryDate.month == 2 && newEntry.entryDate.day == 12) {
      unlock('dogum_gunu');
    }

    // --- 5. Category Expertise ---
    try {
      final product = allProducts.firstWhere(
        (p) => p.barcode == newEntry.barcode, 
        orElse: () => Product(barcode: '', name: '', brand: '', category: '', source: ''),
      );
      
      if (product.barcode.isNotEmpty) {
        final cat = product.category.toLowerCase();
        
        if (cat.contains('süt') || cat.contains('peynir') || cat.contains('yoğurt')) unlock('sutcu');
        if (cat.contains('et') || cat.contains('tavuk') || cat.contains('kıyma')) unlock('kasap');
        if (cat.contains('meyve') || cat.contains('sebze') || cat.contains('domates')) unlock('manav');
        if (cat.contains('ekmek') || cat.contains('pasta') || cat.contains('un')) unlock('firinci');
        if (cat.contains('çikolata') || cat.contains('cips') || cat.contains('bisküvi') || cat.contains('abur')) unlock('keyifci');
        if (cat.contains('bebek') || cat.contains('mama') || cat.contains('bez')) unlock('bebek_dostu');
        if (cat.contains('deterjan') || cat.contains('temiz') || cat.contains('sabun')) unlock('titiz');
        if (cat.contains('şampuan') || cat.contains('krem') || cat.contains('diş') || cat.contains('kozmetik')) unlock('bakimli');
        if (cat.contains('su ') || cat.contains('gazoz') || cat.contains('ola') || cat.contains('içecek')) unlock('icecek_uzmani');
        if (cat.contains('kalem') || cat.contains('defter') || cat.contains('kağıt') || cat.contains('ofis')) unlock('kirtasiyeci');
        if (cat.contains('giyim') || cat.contains('pantolon') || cat.contains('tişört') || cat.contains('tekstil')) unlock('modaci');
        if (cat.contains('kedi') || cat.contains('köpek') || cat.contains('mama') || cat.contains('pet')) unlock('pati_dostu');
        if (cat.contains('pil') || cat.contains('şarj') || cat.contains('telefon') || cat.contains('elektronik')) unlock('teknoloji_kurdu');
        if (cat.contains('benzin') || cat.contains('mazot') || cat.contains('lpg') || cat.contains('akaryakıt')) unlock('sofor');
      }
    } catch (_) {}

    // --- 6. Economy ---
    if (newEntry.price.toString().endsWith('.99') || newEntry.price.toString().endsWith('.90')) {
       unlock('indirim_avcisi');
    }

    // --- 7. Location Discovery ---
    // Need to check unique chains in history + this one
    final historicalChains = userPastEntries.map((e) {
       try {
         return allBranches.firstWhere((b) => b.id == e.marketBranchId).chainName;
       } catch (_) {
         return 'unknown';
       }
    }).toSet();
    
    // Add current one
    try {
      final currentChain = allBranches.firstWhere((b) => b.id == newEntry.marketBranchId).chainName;
      historicalChains.add(currentChain);
    } catch(_) {}
    
    historicalChains.remove('unknown');
    
    if (historicalChains.length >= 5) unlock('zincir_kiran');

    return newBadges;
  }
}
