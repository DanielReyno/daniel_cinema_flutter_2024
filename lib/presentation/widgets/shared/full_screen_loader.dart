import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';


class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  

  Stream<String> getLoadingMessages() {
    const List<String> loadingMessages = [
      "Preparando las peliculas",
      "Ve a por palomitas",
      "Cargando populares",
      "Ya casi terminamos",
      "Esto esta demorando mas de lo normal"
    ];

    return Stream.periodic(const Duration(milliseconds: 1200), (step){
      return loadingMessages[step];
    }).take(loadingMessages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Cargando Recursos"),
          const SizedBox(height: 10,),
          const CircularProgressIndicator(strokeWidth: 2,),
          const SizedBox(height: 10,),
          StreamBuilder(
            stream: getLoadingMessages(), 
            builder: (context,snapshot) {
              if(!snapshot.hasData){
                return const Text("Cargando...");
              }
              return FadeIn(child: Text(snapshot.data!));
            })
        ],
      ),
    );
  }
}