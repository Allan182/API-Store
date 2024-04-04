import 'package:flutter_application_1/Model/Produto.dart';

class ItemCarrinho {
  double qtd;
  Produto produto;

  ItemCarrinho({required this.produto, required this.qtd});

  @override
  String toString() {
    return "$produto : $qtd";
  }
}
