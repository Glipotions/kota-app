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
    print('InitState - Current filter category: ${_filter.category?.id}');
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
      print('Updating category to: ${selectedCategory?.id}');
      _filter = _filter.copyWith(category: selectedCategory);
      print('Filter category after update: ${_filter.category?.id}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ModulePadding.m.value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Filtrele',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          const Text('Kategori'),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ana kategoriler
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Tümü'),
                        selected: _filter.category == null,
                        onSelected: (selected) {
                          if (selected) {
                            _updateCategory(null);
                          }
                        },
                      ),
                      ...widget.controller.categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(category.name),
                            selected: _selectedMainCategory?.id == category.id,
                            onSelected: (selected) {
                              _updateCategory(selected ? category : null, isMainCategory: true);
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                
                // Alt kategoriler (seçili ana kategori varsa)
                if (_selectedMainCategory?.hasSubCategories ?? false) ...[
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ChoiceChip(
                          label: Text('Tüm ${_selectedMainCategory!.name}'),
                          selected: _filter.category?.id == _selectedMainCategory!.id,
                          onSelected: (selected) {
                            _updateCategory(selected ? _selectedMainCategory : null);
                          },
                        ),
                        ..._selectedMainCategory!.subCategories.map((subCategory) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(subCategory.name),
                              selected: _filter.category?.id == subCategory.id,
                              onSelected: (selected) {
                                _updateCategory(selected ? subCategory : null);
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
                
                // Alt-alt kategoriler (seçili alt kategori varsa)
                if (_selectedSubCategory?.hasSubCategories ?? false) ...[
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ChoiceChip(
                          label: Text('Tüm ${_selectedSubCategory!.name}'),
                          selected: _filter.category?.id == _selectedSubCategory!.id,
                          onSelected: (selected) {
                            _updateCategory(selected ? _selectedSubCategory : null);
                          },
                        ),
                        ..._selectedSubCategory!.subCategories.map((subSubCategory) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(subSubCategory.name),
                              selected: _filter.category?.id == subSubCategory.id,
                              onSelected: (selected) {
                                _updateCategory(selected ? subSubCategory : null);
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Min Fiyat',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Max Fiyat',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Sıralama'),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Fiyat Artan'),
                selected: _filter.sortType == ProductSortType.priceAsc,
                onSelected: (selected) {
                  setState(() {
                    _filter = _filter.copyWith(
                      sortType: selected ? ProductSortType.priceAsc : null,
                    );
                  });
                },
              ),
              ChoiceChip(
                label: const Text('Fiyat Azalan'),
                selected: _filter.sortType == ProductSortType.priceDesc,
                onSelected: (selected) {
                  setState(() {
                    _filter = _filter.copyWith(
                      sortType: selected ? ProductSortType.priceDesc : null,
                    );
                  });
                },
              ),
              ChoiceChip(
                label: const Text('İsim A-Z'),
                selected: _filter.sortType == ProductSortType.nameAsc,
                onSelected: (selected) {
                  setState(() {
                    _filter = _filter.copyWith(
                      sortType: selected ? ProductSortType.nameAsc : null,
                    );
                  });
                },
              ),
              ChoiceChip(
                label: const Text('İsim Z-A'),
                selected: _filter.sortType == ProductSortType.nameDesc,
                onSelected: (selected) {
                  setState(() {
                    _filter = _filter.copyWith(
                      sortType: selected ? ProductSortType.nameDesc : null,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    widget.controller.clearFilters();
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text('Filtreleri Temizle'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final minPrice = double.tryParse(_minPriceController.text);
                    final maxPrice = double.tryParse(_maxPriceController.text);
                    
                    // Use the current filter's category
                    print('Applying filter - Current category: ${_filter.category?.id}');
                    
                    final newFilter = ProductFilter(
                      minPrice: minPrice,
                      maxPrice: maxPrice,
                      category: _filter.category,
                      sortType: _filter.sortType,
                    );
                    
                    print('New filter category: ${newFilter.category?.id}');
                    widget.controller.applyFilter(newFilter);
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text('Uygula'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
