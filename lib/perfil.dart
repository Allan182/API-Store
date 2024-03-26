import 'package:flutter/material.dart';
import 'package:flutter_application_1/produtos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class perfil extends StatefulWidget {
  final int idlogin;

  const perfil({super.key, required this.idlogin});

  @override
  State<perfil> createState() => _perfilState();
}

class _perfilState extends State<perfil> {
  String msg = "";
  TextEditingController controlNome = TextEditingController();
  TextEditingController controlSobrenome = TextEditingController();
  TextEditingController controlSite = TextEditingController();
  TextEditingController controlTelefone = TextEditingController();

  Future<void> _perfil() async {
    final response = await http
        .post(Uri.parse("http://localhost/flutterconn/perfil.php"), body: {
      "login_idlogin": widget.idlogin.toString(),
    });

    var data = json.decode(response.body);

    if (data.length != 0) {
      setState(() {
        controlNome.text = data[0]["nome"];
        controlSobrenome.text = data[0]["sobrenome"];
        controlTelefone.text = data[0]["telefone"];
        controlSite.text = data[0]["site"];
      });
    }
  }

  Future<void> _atualizaDados() async {
    final response = await http.post(
        Uri.parse("http://localhost/flutterconn/perfilatualiza.php"),
        body: {
          "login_idlogin": widget.idlogin.toString(),
          "nome": controlNome.text,
          "sobrenome": controlSobrenome.text,
          "site": controlSite.text,
          "telefone": controlTelefone.text
        });

    //var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        msg = "Dados Atualizados com Sucesso!";
      });
    } else {
      setState(() {
        msg = "Tente Novamente, algum problema com sua aplicação!";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _perfil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: Text("Perfil"),
      ),
      body: Container(
        child: Column(
          children: [
            Text("ID"),
            TextFormField(
              initialValue: '${widget.idlogin}',
              enabled: false,
            ),
            Text("Nome"),
            TextFormField(
              controller: controlNome,
            ),
            Text("Sobrenome"),
            TextFormField(
              controller: controlSobrenome,
            ),
            Text("Site"),
            TextFormField(
              controller: controlSite,
            ),
            Text("Telefone"),
            TextFormField(
              controller: controlTelefone,
            ),
            SizedBox(height: 15),
            MaterialButton(
              // shape: ,
              padding: EdgeInsets.all(5),
              color: Colors.green,
              textTheme: ButtonTextTheme.primary,
              onPressed: () {
                _atualizaDados();
              },
              child: Text("Atualizar"),
            ),
            SizedBox(height: 15),
            MaterialButton(
              padding: EdgeInsets.all(5),
              color: Colors.green,
              textTheme: ButtonTextTheme.primary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Produtos()),
                );
              },
              child: Text("Produtos"),
            ),
             SizedBox(height: 15),
            Text(msg),
          ],
        ),
      ),
    );
  }
}
