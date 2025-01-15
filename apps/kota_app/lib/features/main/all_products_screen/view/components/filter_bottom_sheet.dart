import 'package:flutter/material.dart';
import 'package:kota_app/features/main/all_products_screen/controller/all_products_controller.dart';
import 'package:kota_app/features/main/all_products_screen/model/product_category.dart';
import 'package:kota_app/features/main/all_products_screen/model/product_filter.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    required this.controller,
    super.key,
  });

  final AllProductsController controller;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late ProductFilter _filter;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  ProductCategory? _selectedMainCategory;
  ProductCategory? _selectedSubCategory;

  @override
  void initState() {
    super.initState();
    _filter = widget.controller.currentFilter;
    _selectedMainCategory = _filter.category;
    _minPriceController.text = _filter.minPrice?.toString() ?? '';
    _maxPriceController.text = _filter.maxPrice?.toString() ?? '';
  }

  void _updateCategory(ProductCategory? category, {bool isMainCategory = false}) {
    setState(() {
      if (isMainCategory) {
        _selectedMainCategory = category;
        _selectedSubCategory = null;
      } else {
        _selectedSubCategory = category;
      }
      final selectedCategory = _selectedSubCategory ?? _selectedMainCategory;
      _filter = _filter.copyWith(category: selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.m.value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar for dragging
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtrele',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 24),
              
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categories Section
                      Text(
                        'Kategori',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Main categories
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('Tümü'),
                            selected: _filter.category == null,
                            onSelected: (_) {
                              setState(() {
                                _selectedMainCategory = null;
                                _selectedSubCategory = null;
                                _filter = _filter.copyWith(category: null);
                              });
                            },
                            showCheckmark: false,
                            avatar: _filter.category == null
                              ? const Icon(Icons.check_circle, size: 18)
                              : const Icon(Icons.circle_outlined, size: 18),
                          ),
                          ...widget.controller.categories.map((category) {
                            final isSelected = _selectedMainCategory?.id == category.id;
                            return FilterChip(
                              label: Text(category.name),
                              selected: isSelected,
                              onSelected: (selected) {
                                _updateCategory(selected ? category : null, isMainCategory: true);
                              },
                              showCheckmark: false,
                              avatar: isSelected
                                ? const Icon(Icons.check_circle, size: 18)
                                : const Icon(Icons.circle_outlined, size: 18),
                            );
                          }).toList(),
                        ],
                      ),
                      
                      // Sub categories
                      if (_selectedMainCategory?.hasSubCategories ?? false) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Text(
                              _selectedMainCategory!.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilterChip(
                              label: Text('Tüm ${_selectedMainCategory!.name}'),
                              selected: _filter.category?.id == _selectedMainCategory!.id,
                              onSelected: (selected) {
                                _updateCategory(selected ? _selectedMainCategory : null);
                              },
                              showCheckmark: false,
                              avatar: _filter.category?.id == _selectedMainCategory!.id
                                ? const Icon(Icons.check_circle, size: 18)
                                : const Icon(Icons.circle_outlined, size: 18),
                            ),
                            ..._selectedMainCategory!.subCategories.map((subCategory) {
                              final isSelected = _filter.category?.id == subCategory.id;
                              return FilterChip(
                                label: Text(subCategory.name),
                                selected: isSelected,
                                onSelected: (selected) {
                                  _updateCategory(selected ? subCategory : null);
                                },
                                showCheckmark: false,
                                avatar: isSelected
                                  ? const Icon(Icons.check_circle, size: 18)
                                  : const Icon(Icons.circle_outlined, size: 18),
                              );
                            }).toList(),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Price Range Section
                      Text(
                        'Fiyat Aralığı',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _minPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Min Fiyat',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    '₺',
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _maxPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Max Fiyat',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    '₺',
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Sorting Section
                      Text(
                        'Sıralama',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildSortChip(
                            'Fiyat Artan',
                            Icons.arrow_upward,
                            ProductSortType.priceAsc,
                          ),
                          _buildSortChip(
                            'Fiyat Azalan',
                            Icons.arrow_downward,
                            ProductSortType.priceDesc,
                          ),
                          _buildSortChip(
                            'İsim A-Z',
                            Icons.sort_by_alpha,
                            ProductSortType.nameAsc,
                          ),
                          _buildSortChip(
                            'İsim Z-A',
                            Icons.sort_by_alpha,
                            ProductSortType.nameDesc,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const Divider(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        widget.controller.clearFilters();
                        if (mounted) Navigator.pop(context);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Temizle'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final minPrice = double.tryParse(_minPriceController.text);
                        final maxPrice = double.tryParse(_maxPriceController.text);
                        
                        final newFilter = ProductFilter(
                          minPrice: minPrice,
                          maxPrice: maxPrice,
                          category: _filter.category,
                          sortType: _filter.sortType,
                        );
                        
                        widget.controller.applyFilter(newFilter);
                        if (mounted) Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Uygula'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

  Widget _buildSortChip(String label, IconData icon, ProductSortType sortType) {
    final isSelected = _filter.sortType == sortType;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.white : null,
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filter = _filter.copyWith(
            sortType: selected ? sortType : null,
          );
        });
      },
      showCheckmark: false,
    );
  }
}
