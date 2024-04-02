import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Model/Produto.dart';
import 'package:flutter_application_1/produtos.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarrinhoSubTotal extends StatefulWidget {
  final List<Produto> produto;
  const CarrinhoSubTotal({Key? key, required this.produto}) : super(key: key);

  @override
  CarrinhoSubTotalState createState() => CarrinhoSubTotalState();
}

class CarrinhoSubTotalState extends State<CarrinhoSubTotal> {
  final NumberFormat c = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
  List<int> quantidades = [];
  var subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    quantidades = List<int>.filled(widget.produto.length, 1);
  }

  @override
  Widget build(BuildContext context) {
    void calculaSubTotal(List produtos) {
      subtotal = 0.0;
      for (int i = 0; i < produtos.length; i++) {
        subtotal += produtos[i].preco * quantidades[i];
      }
    }

    calculaSubTotal(widget.produto);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: ListView.builder(
        itemCount: widget.produto.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProdutoDetalhe(produto: widget.produto[index]),
                ),
              );
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          if (quantidades[index] > 1) {
                            quantidades[index]--;
                          } else {
                            widget.produto.remove(widget.produto[index]);
                          }
                        });
                      },
                    ),
                    Text(quantidades[index].toString()),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          if (quantidades[index] >=
                              widget.produto[index].idProduto) {
                            quantidades[index] =
                                widget.produto[index].idFabricante;
                          } else {
                            quantidades[index]++;
                          }
                        });
                      },
                    ),
                  ],
                ),
                Text(widget.produto[index].nome),
                Text(c.format(
                    widget.produto[index].idProduto * quantidades[index])),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.green,
        child: IconTheme(
          data: const IconThemeData(color: Colors.green),
          child: Row(
            children: <Widget>[
              const SizedBox(height: 64),
              Text('Subtotal: ${c.format(subtotal)}',
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
