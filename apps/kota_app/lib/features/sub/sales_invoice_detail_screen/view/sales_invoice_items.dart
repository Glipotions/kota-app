import 'package:api/api.dart';
import 'package:flutter/material.dart';

class SalesInvoiceItems extends StatefulWidget {
  const SalesInvoiceItems({required this.items, super.key});

  final List<SalesInvoiceDetailItemModel> items;

  @override
  State<SalesInvoiceItems> createState() => _SalesInvoiceItemsState();
}

class _SalesInvoiceItemsState extends State<SalesInvoiceItems> {
  late List<SalesInvoiceDetailItemModel> _filteredItems;
  String _searchQuery = '';
  String _sortBy = 'name'; // 'name', 'code', 'amount'
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
    _sortItems();
  }

  void _sortItems() {
    setState(() {
      _filteredItems.sort((a, b) {
        int comparison;
        switch (_sortBy) {
          case 'name':
            comparison = (a.productName ?? '').compareTo(b.productName ?? '');
            break;
          case 'code':
            comparison = (a.code ?? '').compareTo(b.code ?? '');
            break;
          case 'amount':
            comparison = (a.tutar ?? 0).compareTo(b.tutar ?? 0);
            break;
          default:
            comparison = 0;
        }
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      _filteredItems = widget.items.where((item) {
        final productName = item.productName?.toLowerCase() ?? '';
        final code = item.code?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return productName.contains(searchLower) || code.contains(searchLower);
      }).toList();
      _sortItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search Bar
        TextField(
          decoration: InputDecoration(
            hintText: 'Ürün Ara...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          onChanged: _filterItems,
        ),
        const SizedBox(height: 16),
        // Sort Controls
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSortChip('İsim', 'name'),
              const SizedBox(width: 8),
              _buildSortChip('Kod', 'code'),
              const SizedBox(width: 8),
              _buildSortChip('Tutar', 'amount'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Product List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredItems.length,
          itemBuilder: (context, index) {
            return _buildProductCard(_filteredItems[index], context);
          },
        ),
      ],
    );
  }

  Widget _buildSortChip(String label, String sortValue) {
    final isSelected = _sortBy == sortValue;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (isSelected)
            Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
            ),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          if (_sortBy == sortValue) {
            _sortAscending = !_sortAscending;
          } else {
            _sortBy = sortValue;
            _sortAscending = true;
          }
          _sortItems();
        });
      },
    );
  }

  Widget _buildProductCard(SalesInvoiceDetailItemModel item, BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Handle tap for viewing details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.productName ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     IconButton(
                  //       icon: const Icon(Icons.edit, color: Colors.blue),
                  //       onPressed: () {
                  //         // Handle edit
                  //       },
                  //       tooltip: 'Düzenle',
                  //     ),
                  //     IconButton(
                  //       icon: const Icon(Icons.delete, color: Colors.red),
                  //       onPressed: () {
                  //         // Handle delete
                  //       },
                  //       tooltip: 'Sil',
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Kod: ${item.code ?? ''}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const Divider(height: 16),
              _buildDetailRow('Miktar:', item.miktar?.toString() ?? '-'),
              _buildDetailRow('Birim Fiyat:', 
                '₺${item.birimFiyat?.toStringAsFixed(2) ?? '-'}'),
              _buildDetailRow('KDV Oranı:', '${item.kdvOrani?.toString() ?? '-'}%'),
              _buildDetailRow('KDV Tutarı:', 
                '₺${item.kdvTutari?.toStringAsFixed(2) ?? '-'}'),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Toplam: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₺${item.tutar?.toStringAsFixed(2) ?? '-'}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
