import 'package:flutter/material.dart';

class MenuLateralItem {
  const MenuLateralItem({
    required this.titulo,
    required this.icono,
    required this.onTap,
    this.subtitulo,
    this.color,
  });

  final String titulo;
  final String? subtitulo;
  final IconData icono;
  final VoidCallback onTap;
  final Color? color;
}

/// Lista de módulos del taller usada en la sección "Más".
class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key, required this.items, this.titulo});

  final String? titulo;
  final List<MenuLateralItem> items;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (titulo != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(
                titulo!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: tema.hintColor,
                ),
              ),
            ),
          for (var i = 0; i < items.length; i++) ...[
            ListTile(
              onTap: items[i].onTap,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: (items[i].color ?? tema.colorScheme.primary)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  items[i].icono,
                  size: 20,
                  color: items[i].color ?? tema.colorScheme.primary,
                ),
              ),
              title: Text(
                items[i].titulo,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: items[i].subtitulo == null
                  ? null
                  : Text(
                      items[i].subtitulo!,
                      style: TextStyle(fontSize: 11.5, color: tema.hintColor),
                    ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: tema.hintColor,
                size: 20,
              ),
            ),
            if (i != items.length - 1)
              Divider(
                height: 1,
                indent: 70,
                color: tema.dividerTheme.color,
              ),
          ],
        ],
      ),
    );
  }
}
