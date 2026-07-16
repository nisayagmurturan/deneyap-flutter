import 'package:flutter/material.dart';

void main() {
  runApp(const FamilyShoppingApp());
}

class FamilyShoppingApp extends StatefulWidget {
  const FamilyShoppingApp({Key? key}) : super(key: key);

  @override
  State<FamilyShoppingApp> createState() => _FamilyShoppingAppState();
}

class _FamilyShoppingAppState extends State<FamilyShoppingApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alışveriş Listemiz',
      debugShowCheckedModeBanner: false,
      // 🧊 Açık Tema (Mat Pudra Mavisi Esintili)
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(
          0xFFEBF1F6,
        ), // Yumuşak, mat buz mavisi arka plan
        primaryColor: const Color.fromARGB(
          255,
          86,
          138,
          175,
        ), // Koyu mat pastel mavi (Başlıklar)
        cardColor: Colors.white,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color.fromARGB(255, 53, 94, 130),
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(color: Color.fromARGB(255, 71, 99, 125)),
        ),
      ),
      // 🌙 Karanlık Tema (Mat Derin Gece Mavisi - Yenilendi!)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(
          0xFF1A222D,
        ), // Çok daha temiz ve mat derin gece mavisi arka planı
        primaryColor: const Color(0xFF8CAAC2), // Yumuşak açık mat mavi vurgu
        cardColor: const Color(
          0xFF242F3D,
        ), // Kartlar için arka planla uyumlu, şık mat slate mavi
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(color: Color(0xFFBAC5D0)),
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: ShoppingListScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

// Ürün Modeli
class ShoppingItem {
  final String id;
  final String name;
  bool isCompleted;

  ShoppingItem({
    required this.id,
    required this.name,
    this.isCompleted = false,
  });
}

class ShoppingListScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const ShoppingListScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _inputController = TextEditingController();
  final List<ShoppingItem> _items = [];

  // Ürün Ekleme
  void _addItem() {
    final String text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _items.insert(0, ShoppingItem(id: DateTime.now().toString(), name: text));
      _inputController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  // Alındı/Alınacak Değişimi
  void _toggleItemStatus(ShoppingItem item) {
    setState(() {
      item.isCompleted = !item.isCompleted;
    });
  }

  // Ürün Silme
  void _deleteItem(String id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toBuyItems = _items.where((item) => !item.isCompleted).toList();
    final completedItems = _items.where((item) => item.isCompleted).toList();

    final theme = Theme.of(context);

    // 🎨 Yeni Mat Açık Mavi Renk Paleti Atamaları
    final primaryBlue = widget.isDarkMode
        ? const Color(0xFF8CAAC2)
        : const Color.fromARGB(255, 68, 111, 142);
    final accentBlue = widget.isDarkMode
        ? const Color(0xFF7AA0BC)
        : const Color(0xFF628096);
    final deleteRed = widget.isDarkMode
        ? const Color(0xFFE57373)
        : const Color(0xFFD32F2F);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: Text(
          'Alışveriş Listemiz',
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          // Tema Değiştirme Butonu (Güneş / Ay)
          IconButton(
            icon: Icon(
              widget.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color: primaryBlue,
              size: 26,
            ),
            onPressed: widget.onThemeChanged,
            tooltip: 'Temayı Değiştir',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Ürün Ekleme Giriş Kutusu
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              widget.isDarkMode ? 0.15 : 0.03,
                            ),
                            spreadRadius: 1,
                            blurRadius:
                                8, // Mat bitiş hissi için daha yumuşak gölge
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _inputController,
                        onSubmitted: (_) => _addItem(),
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.shopping_basket_outlined,
                            color: Colors.grey[400],
                          ),
                          hintText: 'Ne lazım? (Örn: Ekmek, Süt...)',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Mat Mavi Ekleme Butonu
                  GestureDetector(
                    onTap: _addItem,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: widget.isDarkMode
                            ? const Color.fromARGB(255, 56, 90, 137)
                            : const Color.fromARGB(255, 107, 148, 178),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add,
                        color: widget.isDarkMode
                            ? const Color(0xFF8CAAC2)
                            : Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. Dinamik Liste Alanı
            Expanded(
              child: _items.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: [
                        // ALINACAKLAR BÖLÜMÜ
                        if (toBuyItems.isNotEmpty)
                          _buildSectionCard(
                            title: 'Alınacaklar',
                            icon: Icons.shopping_bag_outlined,
                            itemsCount: toBuyItems.length,
                            accentColor: accentBlue,
                            theme: theme,
                            child: Column(
                              children: toBuyItems
                                  .map(
                                    (item) => _buildItemRow(
                                      item,
                                      accentBlue,
                                      theme,
                                      deleteRed,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),

                        // ALINANLAR BÖLÜMÜ
                        if (completedItems.isNotEmpty)
                          _buildSectionCard(
                            title: 'Alınanlar',
                            icon: Icons.check_circle_outline,
                            itemsCount: 0,
                            isCompletedSection: true,
                            accentColor: accentBlue,
                            theme: theme,
                            child: Column(
                              children: completedItems
                                  .map(
                                    (item) => _buildItemRow(
                                      item,
                                      accentBlue,
                                      theme,
                                      deleteRed,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),

                        const SizedBox(height: 20),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Boş Ekran Tasarımı
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.playlist_add,
            size: 80,
            color: Colors.grey.withOpacity(widget.isDarkMode ? 0.15 : 0.35),
          ),
          const SizedBox(height: 16),
          Text(
            'Listeniz şu an boş.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.isDarkMode
                  ? Colors.white70
                  : const Color.fromARGB(255, 117, 153, 188),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yukarıdan ekleme yaparak başlayabilirsiniz!',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // Bölüm Kartı
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required int itemsCount,
    required Color accentColor,
    required ThemeData theme,
    required Widget child,
    bool isCompletedSection = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(widget.isDarkMode ? 0.1 : 0.02),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isCompletedSection ? Colors.grey[400] : accentColor,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isCompletedSection
                        ? Colors.grey[400]
                        : (theme.textTheme.titleLarge?.color),
                  ),
                ),
                const Spacer(),
                // Aktif ürün sayısı rozeti
                if (itemsCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$itemsCount ürün',
                      style: TextStyle(
                        color: widget.isDarkMode
                            ? const Color(0xFF1A222D)
                            : Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  // Ürün Satırı Tasarımı
  Widget _buildItemRow(
    ShoppingItem item,
    Color accentColor,
    ThemeData theme,
    Color deleteRed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () => _toggleItemStatus(item),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              // Checkbox dairesi
              item.isCompleted
                  ? Icon(Icons.check_circle, color: accentColor, size: 24)
                  : Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: accentColor, width: 2),
                      ),
                    ),
              const SizedBox(width: 14),
              // Ürün İsmi
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: item.isCompleted
                        ? Colors.grey[450]
                        : (theme.textTheme.bodyMedium?.color),
                    decoration: item.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              // Ürün silme ikonu
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: deleteRed.withOpacity(
                    0.8,
                  ), // Mat duruş için hafif opaklaştırıldı
                  size: 20,
                ),
                onPressed: () => _deleteItem(item.id),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
