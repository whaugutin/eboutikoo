import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MyApp());

// ─── FAKE DATA ───────────────────────────────────────────────────────────────
Map<String, String> fakeDatabase = {"whitchyaugustin@gmail.com": "1234"};

List<String> panierList = [];
List<String> favorisList = [];

final Map<String, List<Map<String, String>>> categories = {
  "Kategori Kosmetik": [
    {"name": "Savon", "price": "500", "desc": "Savon ki fè po w bèl ki fèt ak myèl", "image": "assets/images/savon_miel.png"},
    {"name": "Krèm po", "price": "600", "desc": "Krèm ki kenbe po w frèch, pou li pa sèk", "image": "assets/images/lotion.png"},
  ],
  "Kategori Rad": [
    {"name": "Jile kou V", "price": "2000", "desc": "Jile kou V san manch", "image": "assets/images/v_vest.png"},
    {"name": "Chemiz karabela", "price": "1000", "desc": "Chemiz ki fè ak ", "image": "assets/images/karabella_shirt.png"},
    {"name": "Pantalon (JEANS)", "price": "900", "desc": "Pou po sansib", "image": "assets/images/black_jeans.png"},
  ],
};

// ─── MAIN APP ────────────────────────────────────────────────────────────────
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EBoutikoo',
      theme: ThemeData(
        primaryColor: const Color(0xFF00695C),          // deep teal
        scaffoldBackgroundColor: const Color(0xFFF5F9F8),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          accentColor: const Color(0xFFFFB300),        // warm amber
        ).copyWith(secondary: const Color(0xFFFFB300)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00695C),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFB300),
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFFB300), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        // CardThemeData is the correct type for newer Flutter SDKs
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── SPLASH ──────────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF004D40), Color(0xFF009688)],
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storefront_rounded, size: 110, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'EBoutikoo',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── LOGIN ───────────────────────────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Koneksyon")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_open_rounded, size: 80, color: Theme.of(context).primaryColor),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: "Imel",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Imel obligatwa";
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
                      return "Fòma imel pa bon";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Modpas",
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? "Modpas obligatwa" : null,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final email = _emailCtrl.text.trim();
                        if (fakeDatabase[email] == _passCtrl.text) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainWrapper()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Imel oswa modpas pa kòrèk")),
                          );
                        }
                      }
                    },
                    child: const Text("KONEKTE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage())),
                  child: const Text("Ou poko gen kont? Enskri", style: TextStyle(color: Color(0xFFFFB300))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── SIGN UP ─────────────────────────────────────────────────────────────────
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enskripsyon")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add_rounded, size: 80, color: Theme.of(context).primaryColor),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: "Imel",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Imel obligatwa";
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) return "Fòma imel pa bon";
                    if (fakeDatabase.containsKey(v.trim())) return "Imel sa deja itilize";
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Modpas",
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Modpas obligatwa";
                    if (v.length < 4) return "Omwen 4 karaktè";
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Konfime modpas",
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (v) => (v != _passCtrl.text) ? "Modpas yo pa menm" : null,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        fakeDatabase[_emailCtrl.text.trim()] = _passCtrl.text;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Kont kreye ak siksè!")),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("KREYE KONT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── MAIN WRAPPER ────────────────────────────────────────────────────────────
class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: const Color(0xFFFFB300),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 13,
        unselectedFontSize: 12,
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'Favori'),
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Akèy'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_rounded), label: 'Panye'),
        ],
      ),
    );
  }
}

// ─── PRODUCT CARD ────────────────────────────────────────────────────────────
class ProductCard extends StatelessWidget {
  final Map<String, String> product;
  final VoidCallback onToggleFavorite;

  const ProductCard({super.key, required this.product, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    final name = product["name"]!;
    final imagePath = product["image"] ?? 'assets/images/placeholder.jpg';

    return ProductCardBase(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 150,
                color: Colors.teal.shade100,
                child: const Icon(Icons.image_not_supported, size: 60, color: Colors.teal),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  "${product["price"]} HTG",
                  style: TextStyle(
                    color: Colors.teal.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart_rounded, color: Color(0xFFFFB300)),
                      onPressed: () {
                        panierList.add(name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$name ajoute nan panye")),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        favorisList.contains(name) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: favorisList.contains(name) ? Colors.red : Colors.grey,
                      ),
                      onPressed: onToggleFavorite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper to avoid code duplication
class ProductCardBase extends StatelessWidget {
  final Widget child;

  const ProductCardBase({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

// ─── HOME SCREEN ─────────────────────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EBoutikoo")),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...categories.keys.map((cat) => _categoryTile(context, cat)),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Text("Pwodwi ki pi popilè", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 4,
              itemBuilder: (context, i) {
                final all = categories.values.expand((e) => e).toList();
                if (i >= all.length) return const SizedBox.shrink();
                final p = all[i];
                return GestureDetector(
                  child: ProductCard(
                    product: p,
                    onToggleFavorite: () {
                      final name = p["name"]!;
                      if (favorisList.contains(name)) {
                        favorisList.remove(name);
                      } else {
                        favorisList.add(name);
                      }
                      // The analyzer warns about calling setState on another State instance
                      // (it's allowed at runtime here). Suppress the specific lint to reduce noise.
                      // ignore: invalid_use_of_protected_member
                      context.findAncestorStateOfType<_MainWrapperState>()?.setState(() {});
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _categoryTile(BuildContext context, String name) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(categoryName: name))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF009688), Color(0xFF00796B)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            // withOpacity is deprecated in newer SDKs; use withAlpha to avoid precision loss
            BoxShadow(color: Colors.teal.withAlpha((0.3 * 255).round()), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

// ─── CATEGORY SCREEN ─────────────────────────────────────────────────────────
class CategoryScreen extends StatelessWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final products = categories[categoryName] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, i) {
          final p = products[i];
          return ProductCard(
            product: p,
            onToggleFavorite: () {
              final name = p["name"]!;
              if (favorisList.contains(name)) favorisList.remove(name);
              else favorisList.add(name);
              // ignore: invalid_use_of_protected_member
              context.findAncestorStateOfType<_MainWrapperState>()?.setState(() {});
            },
          );
        },
      ),
    );
  }
}

// ─── FAVORITES & CART (unchanged logic, just theme adapted) ──────────────────
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favori m yo")),
      body: favorisList.isEmpty
          ? const Center(child: Text("Ou poko gen okenn pwodui favori", style: TextStyle(fontSize: 18)))
          : ListView.builder(
        itemCount: favorisList.length,
        itemBuilder: (context, i) {
          final item = favorisList[i];
          return ListTile(
            leading: const Icon(Icons.favorite_rounded, color: Colors.red),
            title: Text(item),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: () => setState(() => favorisList.removeAt(i)),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panye mwen")),
      body: panierList.isEmpty
          ? const Center(child: Text("Panye ou vid", style: TextStyle(fontSize: 18)))
          : ListView.builder(
        itemCount: panierList.length,
        itemBuilder: (context, i) {
          final item = panierList[i];
          return ListTile(
            leading: const Icon(Icons.shopping_bag_rounded, color: Color(0xFFFFB300)),
            title: Text(item),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: () => setState(() => panierList.removeAt(i)),
            ),
          );
        },
      ),
    );
  }
}

// ─── DRAWER ──────────────────────────────────────────────────────────────────
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF009688)),
            accountName: const Text("EBoutikoo", style: TextStyle(fontSize: 22)),
            accountEmail: const Text("Byenveni"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.storefront_rounded, size: 40, color: Color(0xFF009688)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.grid_view_rounded),
            title: const Text("Tout pwodwi yo"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AllProductsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text("Dekonekte"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// ─── ALL PRODUCTS ────────────────────────────────────────────────────────────
class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final allProducts = categories.values.expand((e) => e).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Tout pwodwi yo")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: allProducts.length,
        itemBuilder: (context, i) {
          final p = allProducts[i];
          return ProductCard(
            product: p,
            onToggleFavorite: () {
              final name = p["name"]!;
              setState(() {
                if (favorisList.contains(name)) {
                  favorisList.remove(name);
                } else {
                  favorisList.add(name);
                }
              });
            },
          );
        },
      ),
    );
  }
}