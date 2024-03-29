import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Model/Produto.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



final List<Produto> _carrinho = [];

class Produtos extends StatefulWidget {
  const Produtos({Key? key}) : super(key: key);

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
        listaProdutos.add(Produto.fromJson(e));
      }
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Produtos'),
        ),
        body: ListView.builder(
            itemCount: listaProdutos.length,
            itemBuilder: (BuildContext context, int index) {
              Produto produto = listaProdutos[index];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 5)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ID Produto : ${produto.idProduto}"),
                              Text("Nome: ${produto.nome}"),
                              Text("Valor de Custo ${produto.valorCusto}"),
                              Text("Valor de Venda ${produto.valorVenda}"),
                              Text("Validade ${produto.validade}"),
                              Text("ID Fabricante : ${produto.idFabricante}"),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Icon(Icons.add),
                            SizedBox(height: 35),
                            Icon(Icons.remove)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
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
