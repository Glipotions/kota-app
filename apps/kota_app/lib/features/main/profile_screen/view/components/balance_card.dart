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
    final labels = AppLocalization.getLabels(context);
    return AspectRatio(
      aspectRatio: 343 / 180,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 4,
          shadowColor: context.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: context.primary.withOpacity(0.1),
              width: 1,
            ),
          ),
          color: context.primary.withOpacity(0.05),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.primary.withOpacity(0.05),
                  context.primary.withOpacity(0.1),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(ModulePadding.s.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          color: context.primary,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: ModulePadding.xs.value),
                      Text(
                        labels.balance,
                        style: context.titleLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: context.primary.withOpacity(0.5),
                        size: 16,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        balance.formatPrice(),
                        style: context.headlineMedium.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: balance >= 0
                              ? Colors.green.shade700
                              : context.error,
                        ),
                      ),
                      SizedBox(height: ModulePadding.xxs.value),
                      Text(
                        title,
                        style: context.titleMedium.copyWith(
                          color: context.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
