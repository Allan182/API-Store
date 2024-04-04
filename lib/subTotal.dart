import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Model/ItemCarrinho.dart';
import 'package:flutter_application_1/Model/Produto.dart';
import 'package:flutter_application_1/produtos.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarrinhoSubTotal extends StatefulWidget {
  final List<ItemCarrinho> carrinho;
  const CarrinhoSubTotal({Key? key, required this.carrinho}) : super(key: key);

  @override
  CarrinhoSubTotalState createState() => CarrinhoSubTotalState();
}

class CarrinhoSubTotalState extends State<CarrinhoSubTotal> {
  List<int> quantidades = [];
  @override
  void initState() {
    super.initState();
  }

  double calculaSubTotal() {
    double subTotal = 0;
    for (var e in widget.carrinho) {
      subTotal += e.qtd * e.produto.valorVenda;
    }
    return subTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: ListView.builder(
        itemCount: widget.carrinho.length,
        itemBuilder: (BuildContext context, int index) {
          Produto produto = widget.carrinho[index].produto;
          ItemCarrinho item = widget.carrinho[index];
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID : ${produto.idProduto}"),
                Text("Nome: ${produto.nome}"),
                Text("Valor de Custo: ${produto.valorCusto}"),
                Text("Validade: $produto.validade}"),
                Text("Valor de Venda: ${produto.valorVenda}"),
                Text("Quantidade : ${item.qtd}")
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.green,
        child: ListTile(
          title: Row(
            children: [Text("SubTotal : R\$${calculaSubTotal().toStringAsFixed(2)}")],
          ),
        ),
      ),
    );
  }
}
