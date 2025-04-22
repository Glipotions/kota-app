import 'package:values/src/company/company_config_model.dart';
import 'package:values/src/company/predefined_companies.dart';

/// Factory class for creating company configurations
/// This follows the Factory Method pattern to create company configurations
class CompanyConfigFactory {
  CompanyConfigFactory._();

  /// Create a company configuration by ID
  static CompanyConfigModel createByCompanyId(String companyId) {
    return PredefinedCompanies.getCompanyById(companyId);
  }

  /// Create a company configuration for Kota Tekstil
  static CompanyConfigModel createKotaTekstil() {
    return PredefinedCompanies.kotaTekstil;
  }

  /// Create a company configuration for Company 1
  static CompanyConfigModel createCompany1() {
    return PredefinedCompanies.company1;
  }

  /// Create a company configuration for Company 2
  static CompanyConfigModel createCompany2() {
    return PredefinedCompanies.company2;
  }
}
