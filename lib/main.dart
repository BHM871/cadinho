import 'package:cadinho/config/database_config.dart';
import 'package:cadinho/repositories/item_repository.dart';
import 'package:cadinho/repositories/lista_repository.dart';
import 'package:cadinho/services/serializer_service.dart';
import 'package:cadinho/services/share_service.dart';
import 'package:cadinho/viewmodels/item_view_model.dart';
import 'package:cadinho/viewmodels/lista_view_model.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseConfig.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ListaRepository listaRepository = ListaRepository();
    const ItemRepository itemRepository = ItemRepository();

    const ListaViewModel listaViewModel = ListaViewModel(
      repository: listaRepository, 
      itemRepository: itemRepository,
      serializerService: SerializerService(),
      shareService: ShareService(),
    );
    const ItemViewModel itemViewModel = ItemViewModel(
      repository: itemRepository,
    );

    return MaterialApp(
      title: 'Cadinho',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Montserrat',
      ),
      home: const HomePage(
        viewModel: listaViewModel,
        itemViewModel: itemViewModel,
      ),
    );
  }
}
