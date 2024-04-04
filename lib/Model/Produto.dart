class Produto {
  int idProduto;
  String nome;
  double valorCusto;
  double valorVenda;
  DateTime validade;
  int idFabricante;

  Produto(
      {required this.idProduto,
      required this.nome,
      required this.valorCusto,
      required this.valorVenda,
      required this.validade,
      required this.idFabricante});

  Produto.fromJson(Map<String, dynamic> dataJson)
      : idProduto = int.parse(dataJson["idproduto"]),
        nome = dataJson["nome"],
        valorCusto = double.parse(dataJson["valorCusto"]),
        valorVenda = double.parse(dataJson["valorVenda"]),
        validade = DateTime.parse(dataJson["validade"]),
        idFabricante = int.parse(dataJson["fabricante_idfabricante"]);

  @override
  String toString() {
    return "$nome";
  }
}
