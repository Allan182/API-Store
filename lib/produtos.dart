import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Produto {
  final String nome;
  final double valorCusto;
  final double valorVenda;
  final DateFormat validade;
  final int idFabricante;
  final int idProduto;  

  const Produto(this.idProduto, this.nome, this.valorCusto, this.valorVenda,
      this.validade, this.idFabricante);
}

final List<Produto> _carrinho = [];

class Produtos extends StatefulWidget {
  Produtos({Key? key}) : super(key: key);

  @override
  State<Produtos> createState() => _ProdutosState();
}

class _ProdutosState extends State<Produtos> {
  List listaProdutos = [];

  @override
  void initState() {
    super.initState();
    _produtos();
  }

  Future<void> _produtos() async {
    final response =
        await http.get(Uri.parse("http://localhost/flutterconn/produtos.php"));

    var data = json.decode(response.body);

    if (data.length != 0) {
      for (var e in data) {
        listaProdutos.add(Produto(e["idproduto"], e["nome"], e["valorCusto"],
            e["valorVenda"], e["validade"], e["fabricante_idfabricante:"]));
      }
    }
//    print(listaProdutos);
  }

  @override
  Widget build(BuildContext context) {
    var c = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: ListView.builder(
          itemCount: listaProdutos.length,
          itemBuilder: (BuildContext context, int index) {
            final noCarrinho = _carrinho.contains(listaProdutos[index]);

            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProdutoDetalhe(produto: listaProdutos[index])));
              },
              title: Text(listaProdutos[index].nome),
              subtitle: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: listaProdutos[index]
                    .tags
                    .map((tag) => Chip(label: Text('#$tag')))
                    .toList(),
              ),
              trailing: Text(c.format(listaProdutos[index].preco)),
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    if (noCarrinho) {
                      _carrinho.remove(listaProdutos[index]);
                    } else {
                      _carrinho.add(listaProdutos[index]);
                    }
                  });
                },
                icon: noCarrinho
                    ? const Icon(Icons.add_circle, color: Colors.red)
                    : const Icon(Icons.add_circle_outlined),
              ),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_carrinho.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CarrinhoSubTotal(produto: _carrinho)),
              );
            }
          },
          tooltip: 'Carrinho de compras',
          child: Badge(
            label: Text('${_carrinho.length}'),
            child: const Icon(Icons.shopping_basket),
          )),
    );
  }
}

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
    quantidades = List<int>.filled(_carrinho.length, 1);
  }

  @override
  Widget build(BuildContext context) {
    void calculaSubTotal(List produtos) {
      subtotal = 0.0;
      for (int i = 0; i < produtos.length; i++) {
        subtotal += produtos[i].preco * quantidades[i];
      }
    }

    calculaSubTotal(_carrinho);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: ListView.builder(
        itemCount: _carrinho.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProdutoDetalhe(produto: _carrinho[index]),
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
                            _carrinho.remove(_carrinho[index]);
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
                              widget.produto[index].idFabricante) {
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
                    widget.produto[index].idFabricante * quantidades[index])),
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

class ProdutoDetalhe extends StatelessWidget {
  final Produto produto;

  const ProdutoDetalhe({Key? key, required this.produto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noCarrinho = _carrinho.contains(produto);
    var c = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

    return Scaffold(
        appBar: AppBar(
          title: Text(produto.nome),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(produto.nome),
            const SizedBox(height: 16),
            Text(c.format(produto.idFabricante)),
            const SizedBox(height: 16),
            noCarrinho ? const Text('No carrinho!') : const Text(''),
            Wrap(
              spacing: 8,
              runSpacing: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Voltar')),
          ]),
        ));
  }
}
