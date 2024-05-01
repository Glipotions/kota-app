part of '../profile.dart';

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.balance,
    required this.title,
    required this.onTap,
  });

  final double balance;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 343 / 180,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Daha yuvarlak köşeler
        ),
        color: context.primary.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.s.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined, // Bakiye ikonu
                    color: context.primary,
                    size: 24,
                  ),
                  SizedBox(width: ModulePadding.xxs.value),
                  Text(
                    'Bakiye',
                    style: context.titleLarge,
                  ),
                ],
              ),
              SizedBox(width: ModulePadding.s.value),
              Text(
                balance.formatPrice(),
                style: context.headlineMedium.copyWith(
                  // fontSize: 32, // Daha büyük ve okunaklı tutar
                  fontWeight: FontWeight.bold,
                  color: balance >= 0
                      ? Colors.green
                      : context.error, // Bakiye durumuna göre renk
                ),
              ),
              SizedBox(width: ModulePadding.xxxs.value),
              Text(
                title,
                style: context.titleMedium.copyWith(
                  // color: context.primary.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(),
              Divider(
                  color: context.primary.withOpacity(0.25),), // Ayırıcı çizgi
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onTap, // Butona tıklama olayı
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // İçerikleri sıkıştır
                    children: [
                      Text('Detaylar', style: context.bodyMedium),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
