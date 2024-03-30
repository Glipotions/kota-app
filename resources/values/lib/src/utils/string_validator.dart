import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// written for validate the characters in edit text
/// written this Extensions for String class
class StringValidator {
  ///Generates [StringValidator]
  StringValidator(this.context);

  ///Context for localization
  final BuildContext context;

  ///for validate Email
  String? isMail(String? value) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return AppLocalization.getLabels(context).requiredText;
    }
    else if (!regExp.hasMatch(value)) {
      return AppLocalization.getLabels(context).invalidMailText;
    }
    return null;
  }

  ///Checks desired lenght
  String? lenghtChecker(String? value, int desiredLenght) {
    if (value == null || value.isEmpty) {
      return AppLocalization.getLabels(context).requiredText;
    }
     else if (value.length < desiredLenght) {
      return AppLocalization.getLabels(context)
          .atLeastLenghtText(desiredLenght);
    }
    return null;
  }

  ///for validate name
  String? isName(String? value) {
    const pattern =
        // ignore: lines_longer_than_80_chars
        r"^[a-zA-ZüğişçöĞÜİŞÇÖıIZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð]+(([',. -][a-zA-ZüğişçöĞÜİŞÇÖıIZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ])?[a-zA-ZüğişçöĞÜİŞÇÖıIZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð]*)*$";
    final regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return AppLocalization.getLabels(context).requiredText;
    }
    else if (value.length == 1 || !regExp.hasMatch(value)) {
      return AppLocalization.getLabels(context).invalidNameText;
    }
    return null;
  }

  ///To check if string is not empty
  String? isNotEmptyController(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalization.getLabels(context).requiredText;
    }
    return null;
  }

  ///To validate credit card number
  String? isCreditCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalization.getLabels(context).requiredText;
    }
    else if (value.length < 16) {
      return AppLocalization.getLabels(context).invalidCreditCardNumberText;
    }
    return null;
  }

  ///To validate credit card date
  String? isCreditCardDate(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalization.getLabels(context).requiredText;
    }
    else if (value.length < 4 ||
        int.parse(value.substring(0, 2)) > 12 ||
        int.parse(value.substring(2)) < 21) {
      return AppLocalization.getLabels(context).invalidCreditCardDateText;
    }
    return null;
  }

  ///To validate credit card cvv
  String? isCreditCardCVV(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalization.getLabels(context).requiredText;
    }
    else if (value.length < 3) {
      return AppLocalization.getLabels(context).invalidCreditCardCvvText;
    }
    return null;
  }
}
