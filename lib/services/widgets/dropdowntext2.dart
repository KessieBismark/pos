import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'extension.dart';
import 'waiting.dart';

class DropDownTextTwo extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validate;
  final List<String> list;
  final Function(String?)? onChange;

  const DropDownTextTwo(
      {Key? key,
      required this.hint,
      required this.label,
      required this.controller,
      this.validate,
      this.onChange,
      required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      // dropdownDecoratorProps: DropDownDecoratorProps(
      //   dropdownSearchDecoration: InputDecoration(
      //     hintText: hint,
      //     labelText: hint,
      //     border: OutlineInputBorder(
      //       gapPadding: 20,
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //   ),
      // ),
      popupProps: PopupProps.menu(
        title: hint.toLabel(),
        showSearchBox: true,
        searchFieldProps: const TextFieldProps(
          autofocus: true,
        ),
      ),
      onChanged: onChange,
      validator: validate,
      selectedItem: controller.text,
      items: list,
    );
  }
}

class ServiceDrop extends StatelessWidget {
  final String hint;
  final String label;
  final bool isLoading;
  final SalesModel? controller;
  final String? Function(SalesModel?)? validate;
  final List<SalesModel> list;
  final Function(SalesModel?)? onChange;

  const ServiceDrop(
      {Key? key,
      required this.hint,
      required this.label,
      this.controller,
      this.isLoading = false,
      this.validate,
      this.onChange,
      required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const MWaiting()
        : DropdownSearch<SalesModel>(
            // dropdownDecoratorProps: DropDownDecoratorProps(
            //   dropdownSearchDecoration: InputDecoration(
            //     hintText: hint,
            //     labelText: hint,
            //     border: OutlineInputBorder(
            //       gapPadding: 20,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            // ),
            popupProps: PopupProps.menu(
              title: hint.toLabel(),
              showSearchBox: true,
              searchFieldProps: const TextFieldProps(
                autofocus: true,
              ),
            ),
            selectedItem: controller,
            validator: validate,
            onChanged: onChange,
            items: list,
            itemAsString: (SalesModel u) => u.name,
          );
  }
}

class SalesModel {
  final String id;
  final String name;
  final String? sub;
  final double price;
  final int quantity;

  SalesModel(
      {required this.id, required this.name, this.sub,required this.quantity, required this.price});
}
