import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/ItemCarrinho.dart';
import 'package:flutter_application_1/Model/Produto.dart';
import 'package:flutter_application_1/subTotal.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final List<Produto> _carrinho = [];

class Produtos extends StatefulWidget {
  final int idPerfil;
  const Produtos({super.key, required this.idPerfil});

  @override
  State<Produtos> createState() => _ProdutosState();
}

class _ProdutosState extends State<Produtos> {
  List listaProdutos = [];
  List<ItemCarrinho> carrinho = [];

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
    setState(() {});
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
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  var itemCarrinho = carrinho.firstWhere(
                                      (item) =>
                                          item.produto.idProduto ==
                                          produto.idProduto,
                                      orElse: () => ItemCarrinho(
                                          produto: produto, qtd: 0));

                                  if (itemCarrinho.qtd == 0) {
                                    carrinho.add(itemCarrinho);
                                  }
                                  itemCarrinho.qtd += 1;
                                });
                              },
                              icon: const Icon(Icons.add)),
                          const SizedBox(height: 35),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  var itemCarrinho = carrinho.firstWhere(
                                      (item) =>
                                          item.produto.idProduto ==
                                          produto.idProduto,
                                      orElse: () => ItemCarrinho(
                                          produto: produto, qtd: -1));

                                  if (itemCarrinho.qtd != -1) {
                                    itemCarrinho.qtd -= 1;

                                    if (itemCarrinho.qtd == 0) {
                                      carrinho.remove(itemCarrinho);
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Este Produto Não Existe no seu Carrinho!")));
                                  }
                                });
                              },
                              icon: const Icon(Icons.remove))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.green,
        child: IconTheme(
            data: IconThemeData(color: Colors.green),
            child: Row(
                children: <Widget>[SizedBox(height: 64), Text('IFES Store')])),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (carrinho.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CarrinhoSubTotal(carrinho: carrinho)),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Adicione um Produto no Carrinho!")));
            }
          },
          tooltip: 'Carrinho de compras',
          child: Badge(
            label: Text('${carrinho.length}'),
            child: const Icon(Icons.shopping_basket),
          )),
    );
  }
}

class ProdutoDetalhe extends StatelessWidget {
  final Produto produto;

  const ProdutoDetalhe({super.key, required this.produto});

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
            const Wrap(
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
