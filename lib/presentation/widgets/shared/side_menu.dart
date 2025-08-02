import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moviedb_app/presentation/providers/theme/theme_provider.dart';


class SideMenu extends ConsumerWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final themeMode = ref.watch(themeProvider);

    return NavigationDrawer(
      
      children: [
        const NavigationDrawerDestination(
          icon: Icon(Icons.home), 
          label: Text("Home")
          ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.color_lens), 
          label: Text("Temas")
          ),
        const ListTile(
          title: Text("Config"),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ListTile(
            onTap: () {
              ref.watch(themeProvider.notifier).state = !themeMode;
            },
            leading: themeMode
            ?const Icon(Icons.dark_mode)
            :const Icon(Icons.light_mode),
            title: themeMode
            ?const Text("Dark mode enabled")
            :const Text("Light mode enabled"),
          ),
        )

      ]
      );
  }
}

// return NavigationDrawer(
//       onDestinationSelected: (value) {
//         setState(() {
//           _selectedIndex = value;
//         });
//       },
//       selectedIndex: _selectedIndex,
//       children: const [
//         NavigationDrawerDestination(
//           icon: Icon(Icons.home), 
//           label: Text("Pagina Principal")
//         ),
//         NavigationDrawerDestination(
//           icon: Icon(Icons.info), 
//           label: Text("Informaciones")
//         ),
//         NavigationDrawerDestination(
//           icon: Icon(Icons.monetization_on), 
//           label: Text("Compras")
//         ),
//       ]
//       );