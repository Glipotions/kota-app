import 'package:flutter/material.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';

class CurrentAccountInformationCard extends StatelessWidget {
  const CurrentAccountInformationCard({
    Key? key,
    required this.onTap,
    this.cariHesapAdi,
    required this.caseType,
    this.code,
    this.aciklama,
    this.balance,
    this.foreignBalance,
    required this.id,
  }) : super(key: key);

  final Function(int, String) onTap;
  final String? cariHesapAdi;
  final String caseType;
  final String? code;
  final String? aciklama;
  final double? balance;
  final double? foreignBalance;
  final int id;

  @override
  Widget build(BuildContext context) {
    // final String iconAsset = enterpriseIcon;

    // String formattedBalance = balance != null ? balance!.formatCurrency() : '-';
    // String formattedForeignBalance = foreignBalance != null
    //     ? 'Döviz: ${foreignBalance!.formatNumber()}'
    //     : '';

    // Color balanceColor;
    // if (balance == null) {
    //   balanceColor = AppColor.disabled;
    // } else if (balance! >= 0) {
    //   balanceColor = AppColor.success;
    // } else {
    //   balanceColor = AppColor.error;
    // }

    Color cardAccentColor = balance != null && balance! >= 0
        ? Color(0xFF0D9488) // Teal for positive balance
        : Color.fromARGB(255, 183, 41, 60); // Purple for negative/null balance

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: ModulePadding.xxs.value, horizontal: ModulePadding.m.value),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (cariHesapAdi != null && cariHesapAdi!.isNotEmpty) {
              onTap(id, cariHesapAdi!);
            }
          },
          borderRadius: BorderRadius.circular(ModuleRadius.m.value),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ModuleRadius.m.value),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ModuleRadius.m.value),
              child: Stack(
                children: [
                  // Decorative accent
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            cardAccentColor,
                            cardAccentColor.withOpacity(0.7)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(ModulePadding.m.value),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with Account Name and Code
                        Row(
                          children: [
                            // Container(
                            //   padding: EdgeInsets.all(ModulePadding.xs.value),
                            //   decoration: BoxDecoration(
                            //     color: cardAccentColor.withOpacity(0.1),
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            //   child: SvgPicture.asset(
                            //     iconAsset,
                            //     width: 20,
                            //     height: 20,
                            //     colorFilter: ColorFilter.mode(
                            //         cardAccentColor, BlendMode.srcIn),
                            //     semanticsLabel:
                            //         caseType.toLowerCase() == "bakiye"
                            //             ? 'Bakiye Icon'
                            //             : 'Kredi Kartı Icon',
                            //   ),
                            // ),
                            SizedBox(width: ModulePadding.s.value),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cariHesapAdi?.isNotEmpty == true
                                        ? cariHesapAdi!
                                        : "----------------",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (code != null && code!.isNotEmpty) ...[
                                    SizedBox(height: 2),
                                    Text(
                                      code!,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Description Section
                        if (aciklama != null && aciklama!.isNotEmpty) ...[
                          SizedBox(height: ModulePadding.m.value),
                          Container(
                            padding: EdgeInsets.all(ModulePadding.s.value),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius:
                                  BorderRadius.circular(ModuleRadius.m.value),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    size: 16, color: Colors.grey[600]),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    aciklama!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Balance Section
                        SizedBox(height: ModulePadding.m.value),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           'Bakiye',
                        //           style: s13W500Dark()
                        //               .copyWith(color: Colors.grey[600]),
                        //         ),
                        //         SizedBox(height: 4),
                        //         Text(
                        //           formattedBalance,
                        //           style: s20W700Dark().copyWith(
                        //             color: balanceColor,
                        //             letterSpacing: -0.5,
                        //           ),
                        //         ),
                        //         if (foreignBalance != null) ...[
                        //           SizedBox(height: 2),
                        //           Text(
                        //             formattedForeignBalance,
                        //             style: s14W500Dark().copyWith(
                        //               color: balanceColor.withOpacity(0.8),
                        //             ),
                        //           ),
                        //         ],
                        //       ],
                        //     ),
                        //     Container(
                        //       padding: EdgeInsets.symmetric(
                        //           horizontal: 16, vertical: 8),
                        //       decoration: BoxDecoration(
                        //         color: cardAccentColor.withOpacity(0.1),
                        //         borderRadius: BorderRadius.circular(20),
                        //         border: Border.all(
                        //           color: cardAccentColor.withOpacity(0.2),
                        //           width: 1,
                        //         ),
                        //       ),
                        //       child: Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           Icon(
                        //             caseType.toLowerCase() == "bakiye"
                        //                 ? Icons.account_balance_wallet_outlined
                        //                 : Icons.credit_card_outlined,
                        //             size: 16,
                        //             color: cardAccentColor,
                        //           ),
                        //           SizedBox(width: 6),
                        //           Text(
                        //             caseType,
                        //             style: s13W500Dark()
                        //                 .copyWith(color: cardAccentColor),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
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
