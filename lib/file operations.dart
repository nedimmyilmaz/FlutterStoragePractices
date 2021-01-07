import 'dart:async';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class FileOperations extends StatefulWidget {
  @override
  _FileOperationsState createState() => _FileOperationsState();
}

class _FileOperationsState extends State<FileOperations> {
  var myTextController = TextEditingController();

  // klasör yolu
  Future<String> get folderPath async {
    Directory folder = await getApplicationDocumentsDirectory();
    debugPrint(folder.path.toString());
    return folder.path;
  }

// dosya oluşturma
  Future<File> get createFile async {
    var file = await folderPath;
    return File(file + "/myFile.txt");
  }

  Future<String> readFile() async {
    try {
      var myFile = await createFile;
      String content = await myFile.readAsString();
      return content;
    } catch (exception) {
      return "Hata" + exception;
    }
  }

  Future<File> writeFile(String value) async {
    var myFile = await createFile;
    return myFile.writeAsString(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("File Operations")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: myTextController,
                decoration: InputDecoration(hintText: "Dosyaya kaydedilecek"),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton.icon(
                    onPressed: _dosyaYaz,
                    icon: Icon(Icons.save),
                    label: Text("Kaydet"),
                    color: Colors.green,
                  ),
                  RaisedButton.icon(
                    onPressed: _dosyaOku,
                    icon: Icon(Icons.now_widgets),
                    label: Text("Göster"),
                    color: Colors.yellow,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _dosyaOku() async {
    readFile().then((value) => debugPrint(value));
  }

  void _dosyaYaz() {
    writeFile(myTextController.text.toString());
  }
}
