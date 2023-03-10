import 'package:flutter/material.dart';

class VisibilityWidget extends StatelessWidget {
  final bool visibility;
  final String text;
  final IconData icon;
  final Color iconColor;

  const VisibilityWidget({
    Key? key,
    required this.visibility,
    required this.text,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.3,
          left: 15,
          right: 15,
        ),
        child: FittedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    'As tarefas $text',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Icon(
                    icon,
                    size: 35,
                    color: iconColor,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'São listados aqui!!',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
