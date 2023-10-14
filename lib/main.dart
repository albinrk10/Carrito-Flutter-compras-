
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_sqlite/my_cart.dart';
import 'package:prueba_sqlite/notifier.dart';
import 'package:prueba_sqlite/ui/product_list.dart';

void main() {
  runApp(const HomeScreen());
}

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title:'Flutter Demo',
        theme: ThemeData(
        primarySwatch: Colors.blue,
        ),
        home : ChangeNotifierProvider(
        create: (context) => CartNotifier(),
        child: const MyHomePage(),
      ),
    );
    
    
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Abexa store'),
      ),
      body:_selectedIndex == 0 ? ProductScreen() : MyCart(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Compras',
          ),


          BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'My carrito',
          ),

          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index){
            setState(() {
              _selectedIndex=index;
            });
          },
          ),

    );
  }
}

