import 'package:api/api.dart';
import 'package:flutter/material.dart';

class CurrentAccountCard extends StatelessWidget {
  final GetCurrentAccount account;
  final VoidCallback onTap;

  const CurrentAccountCard({
    Key? key,
    required this.account,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      account.firma ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    account.kod ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              if (account.aciklama != null && account.aciklama!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  account.aciklama!,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bakiye: ${account.bakiye?.toStringAsFixed(2) ?? '0.00'} ₺',
                    style: TextStyle(
                      color: (account.bakiye ?? 0) >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (account.dovizliBakiye != null)
                    Text(
                      'Dövizli Bakiye: ${account.dovizliBakiye?.toStringAsFixed(2) ?? '0.00'} \$',
                      style: TextStyle(
                        color: (account.dovizliBakiye ?? 0) >= 0
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
