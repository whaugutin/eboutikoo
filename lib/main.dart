import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MyApp());

// ─── FAKE DATA ───────────────────────────────────────────────────────────────
Map<String, String> fakeDatabase = {"test@example.com": "1234"};

List<String> panierList = [];
List<String> favorisList = [];

final Map<String, List<Map<String, String>>> categories = {
  "Kategori Elektwonik": [
    {"name": "Laptop Dell", "price": "85000", "desc": "Bon laptop pou travay"},
    {"name": "iPhone 15 Pro", "price": "650000", "desc": "Pi nouvo modèl"},
  ],
  "Kategori Rad": [
    {"name": "Chemiz Lakou", "price": "3500", "desc": "Koton bon kalite"},
    {"name": "Wòb Tradisyonèl", "price": "12000", "desc": "Handmade ayisyen"},
    {"name": "Savon Natirèl", "price": "800", "desc": "Pou po sansib"},
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
        primaryColor: const Color(0xFF0D2A5B),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF5E81F4)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5E81F4)),
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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Icon(Icons.shopping_bag_rounded, size: 100, color: Color(0xFF5E81F4))),
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
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Koneksyon")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: "Imel", border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Imel obligatwa";
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
                    return "Imel pa bon (eg: non@gmail.com)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Modpas", border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? "Modpas obligatwa" : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (fakeDatabase[_email.text.trim()] == _pass.text) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainWrapper()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Imel oswa modpas pa kòrèk")),
                        );
                      }
                    }
                  },
                  child: const Text("KONEKTE"),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage())),
                child: const Text("Enskri yon kont"),
              ),
            ],
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
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _passConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enskripsyon")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: "Imel", border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Imel obligatwa";
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) return "Imel pa bon";
                  if (fakeDatabase.containsKey(v.trim())) return "Imel sa deja itilize";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Modpas", border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Modpas obligatwa";
                  if (v.length < 4) return "Omwen 4 karaktè";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passConfirm,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Konfime modpas", border: OutlineInputBorder()),
                validator: (v) => (v != _pass.text) ? "Modpas yo pa menm" : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      fakeDatabase[_email.text.trim()] = _pass.text;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Kont kreye ! Ou ka konekte kounye a")),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("KREYE KONT"),
                ),
              ),
            ],
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
  int _index = 0;

  final _pages = [
    const HomeScreen(),
    const FavoritesScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: const Color(0xFF5E81F4),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Panye'),
        ],
      ),
    );
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
            ...categories.keys.map((cat) => _categoryCard(context, cat)),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text("Top Pwodwi",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 4,
              itemBuilder: (context, i) {
                final all = categories.values.expand((e) => e).toList();
                if (i >= all.length) return const SizedBox.shrink();
                return _productCard(context, all[i]);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(BuildContext context, String name) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(
              builder: (_) => CategoryScreen(categoryName: name))),
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFF0D2A5B),
            borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.center,
        child: Text(name, style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _productCard(BuildContext context, Map<String, String> p) {
    final name = p["name"]!;
    final imagePath = p["image"] ??
        'assets/images/placeholder.jpg'; // fallback if missing

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 140,
                  color: const Color(0xFF0D2A5B),
                  child: const Icon(
                      Icons.image_not_supported, color: Colors.white, size: 60),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "${p["price"]} gourdes",
                  style: const TextStyle(color: Colors.green, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(
                          Icons.add_shopping_cart, color: Color(0xFF5E81F4)),
                      onPressed: () {
                        panierList.add(name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$name ajoute nan panye")),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        favorisList.contains(name) ? Icons.favorite : Icons
                            .favorite_border,
                        color: favorisList.contains(name) ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() { // ← make sure this is inside a StatefulWidget
                          if (favorisList.contains(name)) {
                            favorisList.remove(name);
                          } else {
                            favorisList.add(name);
                          }
                        });
                      },
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
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, i) => HomeScreen()._productCard(context, products[i]),
      ),
    );
  }
}

// ─── FAVORITES ───────────────────────────────────────────────────────────────
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favoris")),
      body: favorisList.isEmpty
          ? const Center(child: Text("Ou poko gen favori"))
          : ListView.builder(
        itemCount: favorisList.length,
        itemBuilder: (context, i) {
          final item = favorisList[i];
          return ListTile(
            title: Text(item),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => setState(() => favorisList.removeAt(i)),
            ),
          );
        },
      ),
    );
  }
}

// ─── CART ────────────────────────────────────────────────────────────────────
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panye")),
      body: panierList.isEmpty
          ? const Center(child: Text("Panye vid"))
          : ListView.builder(
        itemCount: panierList.length,
        itemBuilder: (context, i) {
          final item = panierList[i];
          return ListTile(
            title: Text(item),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => setState(() => panierList.removeAt(i)),
            ),
          );
        },
      ),
    );
  }
}

// ======================= Drawer ===================================================
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF5E81F4)),
            accountName: Text("EBoutikoo"),
            accountEmail: Text("Itilizatè"),
          ),
          ListTile(
            leading: const Icon(Icons.grid_view),
            title: const Text("Lis tout pwodwi"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AllProductsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("logout"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}

// ─── ALL PRODUCTS SCREEN ─────────────────────────────────────────────────────
class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final allProducts = categories.values.expand((list) => list).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("All products")),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: allProducts.length,
        itemBuilder: (context, i) {
          final p = allProducts[i];
          final name = p["name"]!;
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Expanded(child: Container(decoration: const BoxDecoration(color: Color(
                    0xFF8BADE7), borderRadius: BorderRadius.vertical(top: Radius.circular(12))))),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      Text("${p["price"]} gourdes", style: const TextStyle(color: Colors.green)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF5E81F4)),
                            onPressed: () {
                              panierList.add(name);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name in cart")));
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              favorisList.contains(name) ? Icons.favorite : Icons.favorite_border,
                              color: favorisList.contains(name) ? Colors.red : null,
                            ),
                            onPressed: () {
                              setState(() {
                                if (favorisList.contains(name)) {
                                  favorisList.remove(name);
                                } else {
                                  favorisList.add(name);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}