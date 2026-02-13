import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import 'package:fiyatatlas/app_state.dart';
import 'package:fiyatatlas/features/market/domain/market_branch.dart';
import 'package:fiyatatlas/features/product/domain/product.dart';

enum EntryType { product, campaign }

class PriceEntryScreen extends StatefulWidget {
  const PriceEntryScreen({super.key});

  @override
  State<PriceEntryScreen> createState() => _PriceEntryScreenState();
}

class _PriceEntryScreenState extends State<PriceEntryScreen> {
  // Mode Selection
  EntryType _entryType = EntryType.product;
  
  final _formKey = GlobalKey<FormState>();
  
  // Product Input
  final _productNameController = TextEditingController(); 
  final _campaignDescController = TextEditingController(); 
  Product? _selectedProduct; 

  // Availability & Price
  bool _isAvailable = true;
  final _priceController = TextEditingController();
  bool _hasReceipt = false;
  bool _initBarcode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initBarcode) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String && args.isNotEmpty) {
        _productNameController.text = args;
        // Eğer ürün biliniyorsa seç
        try {
           final appState = context.read<AppState>();
           _selectedProduct = appState.products.firstWhere((p) => p.barcode == args);
        } catch (_) {}
      }
      _initBarcode = true;
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _campaignDescController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Barkod veya Broşür Tarama
  Future<void> _handleBarcodeScan() async {
    // 1. Durum: KAMPANYA MODU (Broşür Tarama)
    // Şu an gerçek bir OCR (Resimden Yazı Okuma) kütüphanesi ekli olmadığı için
    // bu adımı "Simülasyon" olarak bırakıyorum. Gerçekte burada kamera açılıp
    // Google ML Kit Text Recognition çalışmalı.
    if (_entryType == EntryType.campaign) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Broşür Analiz Ediliyor...', style: TextStyle(color: Colors.white, decoration: TextDecoration.none)),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 2)); // Analiz simülasyonu
      if (!mounted) return;
      Navigator.pop(context); 

      setState(() {
        _campaignDescController.text = "HAFTANIN FIRSATI: 3 Al 2 Öde";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Broşürden metin algılandı (MVP Simülasyonu)')),
      );
      return;
    }

    // 2. Durum: ÜRÜN MODU (Barkod Tarama - Gerçek)
    String? res = await SimpleBarcodeScanner.scanBarcode(
      context,
      isShowFlashIcon: true,
      scanType: ScanType.barcode,
    );

    if (res != null && res != '-1' && mounted) {
       _handleProductLookup(res);
    }
  }

  Future<void> _handleProductLookup(String barcode) async {
    // Show Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    final appState = context.read<AppState>();
    final product = await appState.lookupProduct(barcode);

    if (!mounted) return;
    Navigator.pop(context); // Hide Loading

    if (product != null) {
      // Product Found!
      setState(() {
        _selectedProduct = product;
        _productNameController.text = product.name;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün bulundu: ${product.name}')),
      );
    } else {
      // Product Not Found -> Prompt to Add
      final shouldAdd = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ürün Bulunamadı'),
          content: Text('"$barcode" barkodlu ürün veritabanımızda yok. Eklemek ister misiniz?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Ekle')),
          ],
        ),
      );

      if (shouldAdd == true) {
        _showAddProductDialog(barcode);
      }
    }
  }

  void _showAddProductDialog(String barcode) {
    final nameController = TextEditingController();
    final brandController = TextEditingController();
    final categoryController = TextEditingController(text: 'Diğer');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yeni Ürün Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Barkod: $barcode', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Ürün Adı', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(labelText: 'Marka', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          FilledButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                 final newProduct = Product(
                   barcode: barcode,
                   name: nameController.text.trim(),
                   brand: brandController.text.trim(),
                   category: categoryController.text.trim(),
                   source: 'User',
                 );
                 
                 if (mounted) {
                   Navigator.pop(ctx);
                   setState(() {
                     _selectedProduct = newProduct;
                     _productNameController.text = newProduct.name;
                   });
                 }
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _submit(MarketBranch branch) async {
    if (!_formKey.currentState!.validate()) return;
    
    final productIdentifier = _selectedProduct?.barcode ?? _productNameController.text;
    
    context.read<AppState>().addPriceEntry(
      barcode: productIdentifier,
      marketBranchId: branch.id,
      price: _isAvailable ? double.parse(_priceController.text) : 0.0,
      hasReceipt: _hasReceipt,
      isAvailable: _isAvailable,
    );

    // Gamification: Başarı Dialogu
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Harika!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('+10 Puan Kazandın', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Devam Et'),
                )
              ],
            ),
          ),
        );
      },
    );

    // Formu temizle ve kullanıcıyı aynı ekranda tut (Seri giriş)
    setState(() {
      _productNameController.clear();
      _campaignDescController.clear();
      _priceController.clear();
      _selectedProduct = null;
      _isAvailable = true;
      _hasReceipt = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentBranch = appState.currentBranch; // Check-in olunmuş market

    // 1. Durum: Hiçbir markete check-in olunmamış
    if (currentBranch == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Giriş Yapılacak Yer')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Fiyat girmek için önce market seçiniz.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _MarketSelector(
                  onBranchSelected: (branch) {
                    // Check-in yap
                    context.read<AppState>().setCheckIn(branch);
                  },
                  onReset: () {}, // Burada reset zaten null demek
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Durum: Check-in yapılmış, hızlı giriş ekranı
    final isCampaign = _entryType == EntryType.campaign;
    final theme = Theme.of(context);

    // Mood Colors
    final bgColor = isCampaign ? Colors.orange.shade50 : Colors.grey.shade50;
    final primaryColor = isCampaign ? Colors.deepOrange : theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isCampaign ? Colors.orange.shade100 : null,
        title: Text(isCampaign ? 'Kampanya Bildir' : 'Fiyat Bildir'),
        actions: [
          // Aktif marketi değiştirme butonu
           TextButton.icon(
            onPressed: () {
               context.read<AppState>().setCheckIn(null);
            },
            icon: Icon(Icons.change_circle, color: isCampaign ? Colors.deepOrange : Colors.grey),
            label: Text('Değiştir', style: TextStyle(color: isCampaign ? Colors.deepOrange : Colors.grey)),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: bgColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Aktif Market Header (Bilet Görünümü)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.store, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'GİRİŞ YAPILAN ŞUBE',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentBranch.displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Type Selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SegmentedButton<EntryType>(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(BorderSide(color: primaryColor.withValues(alpha: 0.5))),
                  ),
                  segments: const [
                    ButtonSegment(
                      value: EntryType.product, 
                      label: Text('Ürün'), 
                      icon: Icon(Icons.shopping_bag_outlined),
                    ),
                    ButtonSegment(
                      value: EntryType.campaign, 
                      label: Text('Kampanya'), 
                      icon: Icon(Icons.local_offer_outlined),
                    ),
                  ],
                  selected: {_entryType},
                  onSelectionChanged: (Set<EntryType> newSelection) {
                    setState(() {
                      _entryType = newSelection.first;
                    });
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Empty State Visualization
                      if (_selectedProduct == null && _productNameController.text.isEmpty) 
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Column(
                              children: [
                                Opacity(
                                  opacity: 0.5,
                                  child: Icon(
                                    isCampaign ? Icons.campaign_sharp : Icons.qr_code_scanner, 
                                    size: 80, 
                                    color: primaryColor
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isCampaign ? 'Broşürü Tara, İndirimi Yakala' : 'Barkodu Tara, Fiyatı Gir',
                                  style: TextStyle(color: Colors.grey.shade600),
                                )
                              ],
                            ),
                          ),
                        ),

                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _handleBarcodeScan, 
                            icon: const Icon(Icons.camera_alt), 
                            label: Text(_entryType == EntryType.product 
                                ? 'Kamerayla Barkod Tara' 
                                : 'Kamerayla Broşür Tara'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      _ProductInput(
                        controller: _productNameController,
                        onProductSelected: (p) {
                          setState(() {
                            _selectedProduct = p;
                            _productNameController.text = p.name;
                          });
                        },
                      ),
                      
                      if (_entryType == EntryType.campaign) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _campaignDescController,
                          decoration: const InputDecoration(
                            labelText: 'Kampanya Açıklaması',
                            hintText: '3 Al 2 Öde, %50 İndirim vb.',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.description),
                          ),
                          validator: (v) => v?.isEmpty == true ? 'Açıklama giriniz' : null,
                        ),
                      ],

                      const SizedBox(height: 24),
                      
                      Row(
                        children: [
                          const Text('Bu ürün rafta var mı?', style: TextStyle(fontSize: 16)),
                          const Spacer(),
                          SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment(value: true, label: Text('VAR'), icon: Icon(Icons.check)),
                              ButtonSegment(value: false, label: Text('YOK'), icon: Icon(Icons.close)),
                            ],
                            selected: {_isAvailable},
                            onSelectionChanged: (newSelection) {
                              setState(() => _isAvailable = newSelection.first); 
                            },
                          ),
                        ],
                      ),
                      
                      if (_isAvailable) ...[
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                          labelText: 'Fiyat (₺)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.sell_outlined),
                          helperText: 'Etiket fiyatını giriniz',
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                           if (_entryType == EntryType.campaign && (value == null || value.isEmpty)) return null;
                           if (value == null || value.isEmpty) return 'Fiyat girin';
                           if (double.tryParse(value) == null) return 'Geçerli sayı girin';
                           return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        value: _hasReceipt,
                        onChanged: (v) => setState(() => _hasReceipt = v),
                        title: const Text('Doğrulama Kanıtı Var'),
                        subtitle: const Text('Fiş veya raf fotosu var mı? (Güven puanını artırır)'),
                        secondary: Icon(
                          Icons.receipt, 
                          color: _hasReceipt ? Colors.green : Colors.grey
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _submit(currentBranch),
                        icon: const Icon(Icons.save),
                        label: const Text('KAYDET ve YENİ EKLE', style: TextStyle(fontSize: 16)),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class _MarketSelector extends StatefulWidget {
  const _MarketSelector({
    required this.onBranchSelected,
    required this.onReset,
  });

  final ValueChanged<MarketBranch> onBranchSelected;
  final VoidCallback onReset;

  @override
  State<_MarketSelector> createState() => _MarketSelectorState();
}

class _MarketSelectorState extends State<_MarketSelector> {
  final _chainCtrl = TextEditingController();
  final _branchCtrl = TextEditingController();

  @override
  void dispose() {
    _chainCtrl.dispose();
    _branchCtrl.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final allBranches = context.watch<AppState>().branches;
    final chainQuery = _chainCtrl.text.trim().toLowerCase();
    final branchQuery = _branchCtrl.text.trim().toLowerCase();

    final filteredBranches = allBranches.where((b) {
      final matchChain = chainQuery.isEmpty ||
          b.chainName.toLowerCase().contains(chainQuery);
      final matchBranch = branchQuery.isEmpty ||
          b.branchName.toLowerCase().contains(branchQuery) ||
          b.district.toLowerCase().contains(branchQuery);
      return matchChain && matchBranch;
    }).toList();
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _chainCtrl,
                decoration: const InputDecoration(
                  labelText: 'Market',
                  hintText: 'Migros, BİM...',
                  prefixIcon: Icon(Icons.business),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() {}),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _branchCtrl,
                decoration: const InputDecoration(
                  labelText: 'Şube / Yer',
                  hintText: 'Kadıköy...',
                  prefixIcon: Icon(Icons.place),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: filteredBranches.isEmpty 
                ? _buildEmptyState(context)
                : ListView.builder(
                    itemCount: filteredBranches.length + 1, 
                    itemBuilder: (context, index) {
                      if (index == filteredBranches.length) {
                        return _buildAddNewButton(context);
                      }
                      final b = filteredBranches[index];
                      return ListTile(
                        title: Text(b.chainName),
                        subtitle: Text(' ()'),
                        leading: const Icon(Icons.storefront),
                        onTap: () => widget.onBranchSelected(b),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Kriterlere uygun market bulunamadı'),
          TextButton.icon(
            onPressed: () => _showAddMarketDialog(context),
            icon: const Icon(Icons.add_business),
            label: const Text('Yeni Market Ekle'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add_circle_outline, color: Colors.blue),
      title: const Text('Listede yok mu?'),
      subtitle: const Text('Yeni bir market ekleyin'),
      onTap: () => _showAddMarketDialog(context),
    );
  }

  void _showAddMarketDialog(BuildContext context) {
    final chainController = TextEditingController(text: _chainCtrl.text);
    final branchController = TextEditingController(text: _branchCtrl.text);
    final cityController = TextEditingController(text: 'İstanbul');
    final districtController = TextEditingController(text: 'Kadıköy');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yeni Market Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: chainController,
                decoration: const InputDecoration(labelText: 'Market Adı (Örn: A-101)'),
              ),
              TextField(
                controller: branchController,
                decoration: const InputDecoration(labelText: 'Şube / Yer Adı'),
              ),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'Şehir'),
              ),
              TextField(
                controller: districtController,
                decoration: const InputDecoration(labelText: 'İlçe'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              if (chainController.text.isNotEmpty && branchController.text.isNotEmpty) {
                 context.read<AppState>().addMarketBranch(
                   chainName: chainController.text,
                   branchName: branchController.text,
                   city: cityController.text,
                   district: districtController.text,
                 );
                 Navigator.pop(ctx);
                 setState(() {
                   _chainCtrl.clear();
                   _branchCtrl.clear();
                 });
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Market eklendi.')),
                 );
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}

class _ProductInput extends StatefulWidget {
  const _ProductInput({
    required this.controller,
    required this.onProductSelected,
  });

  final TextEditingController controller;
  final ValueChanged<Product> onProductSelected;

  @override
  State<_ProductInput> createState() => _ProductInputState();
}

class _ProductInputState extends State<_ProductInput> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete<Product>(
      displayStringForOption: (Product p) => p.name,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Product>.empty();
        }
        return context.read<AppState>().searchProducts(textEditingValue.text);
      },
      onSelected: (Product selection) {
        widget.onProductSelected(selection);
      },
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        if (widget.controller.text.isNotEmpty && textController.text.isEmpty) {
           textController.text = widget.controller.text;
        }
        textController.addListener(() {
          widget.controller.text = textController.text;
        });
        
        return TextFormField(
          controller: textController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Ürün Adı veya Barkod',
            hintText: 'Süt, 869...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.qr_code),
          ),
          validator: (val) {
             if (val == null || val.length < 2) return 'Ürün giriniz';
             return null;
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: SizedBox(
              width: 300,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    title: Text(option.name),
                    subtitle: Text(option.brand),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
