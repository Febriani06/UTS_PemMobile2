// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_final_fields, sized_box_for_whitespace, unnecessary_string_interpolations, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import '../service/storage_service.dart';
import '../model/product.dart';
import 'input_screen.dart';
import 'list_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    PageList(),
    PageProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Gudang'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product>? products;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _loadData();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    List<Product> loadedProducts = await StorageService.getProducts();
    setState(() {
      products = loadedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (products == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (products!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Belum ada data pada aplikasi ini.',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageInput(),
                  ),
                );
              },
              child: Text('Klik Disini untuk Isi Data'),
            ),
          ],
        ),
      );
    }

    Map<String, List<Product>> groupedProducts =
        StorageService.groupProductsByCategory(products ?? []);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200.0,
            margin: EdgeInsets.all(24),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {});
              },
              itemCount: products!.length > 3 ? 3 : products!.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  products![index].imageUrl,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Selamat datang di E-Gudang',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Ini adalah halaman utama, disini akan ditampilkan gambar dan judulnya dengan filter kategori, kata yang bertuliskan tebal (bold) adalah kategori dan kata dibawah gambar adalah judul/nama.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: groupedProducts.keys.length,
              itemBuilder: (BuildContext context, int index) {
                String category = groupedProducts.keys.elementAt(index);
                List<Product> categoryProducts = groupedProducts[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        '$category',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150.0,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: categoryProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GridItem(product: categoryProducts[index]);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final Product product;

  GridItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            product.imageUrl,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8.0),
          Text(
            product.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
