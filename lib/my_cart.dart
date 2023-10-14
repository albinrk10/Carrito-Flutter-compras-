import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_sqlite/models.dart';
import 'package:prueba_sqlite/notifier.dart';
import 'package:prueba_sqlite/shop_database.dart';

class MyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartNotifier>(
      builder: (context, cart, child) {
        return FutureBuilder(
            future: ShopDatabase.instance.getAllItems(),
            builder:
                (BuildContext context, AsyncSnapshot<List<CartItem>> snapshot) {
              if (snapshot.hasData) {
                List<CartItem> cartItems = snapshot.data!;
                return cartItems.isEmpty
                    ? const Center(
                        child: Text(
                          "No hay productos en tu carro",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              color: Colors.yellow[800],
                              child: _CartItem(cartItems[index]));
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                              height: 10,
                            ),
                        itemCount: cartItems.length);
              } else {
                return const Center(
                  child: Text(
                    "No hay productos en tu carro",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
            });
      },
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartItem cartItem;

  const _CartItem(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 20, color: Colors.white),
        child: Row(
          children: [
            Image.asset(
              'assets/images/toyota1.png',
              
              width: 100,
            ),
            
              
            // ),
            //cartItem.image  != null ? Image.asset(cartItem.image) : SizedBox.shrink(),
          //  cartItem.image,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(cartItem.name),
                  Text("\$" + cartItem.price.toString()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(cartItem.quantity.toString() + " unidades"),
                      ElevatedButton(
                        onPressed: () async {
                          cartItem.quantity++;
                          await ShopDatabase.instance.update(cartItem);
                          Provider.of<CartNotifier>(context, listen: false)
                              .shouldRefresh();
                        },
                        child: const Text("+"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          minimumSize: Size.zero,
                          primary: Colors.green[300],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          cartItem.quantity--;
                          if (cartItem.quantity == 0) {
                            await ShopDatabase.instance.delete(cartItem.id);
                          } else {
                            await ShopDatabase.instance.update(cartItem);
                          }
                          Provider.of<CartNotifier>(context, listen: false)
                              .shouldRefresh();
                        },
                        child: const Text("-"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          minimumSize: Size.zero,
                          primary: Colors.green[300],
                        ),
                      )
                    ],
                  ),
                  Text("Total: \$" + cartItem.totalPrice.toString()),
                  ElevatedButton(
                    onPressed: () async {
                      await ShopDatabase.instance.delete(cartItem.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Producto eliminado!"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      Provider.of<CartNotifier>(context, listen: false)
                          .shouldRefresh();
                    },
                    child: const Text("Eliminar"),
                    style: ElevatedButton.styleFrom(primary: Colors.red[400]),
                  ),
                  //buton de compra online
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Tarjeta'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Form(
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Número de tarjeta',
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Fecha de vencimiento',
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Código de seguridad',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Lógica para procesar el pago con tarjeta de crédito
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Compra realizada con tarjeta de crédito!"),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Text('Pagar'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text('Pagar'),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
