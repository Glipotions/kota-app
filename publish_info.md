# Çoklu Şirket Yapılandırması Rehberi

Bu rehber, Kota Tekstil uygulamasının farklı şirketler için nasıl yapılandırılacağını ve yayınlanacağını açıklamaktadır.

## İçindekiler

1. [Genel Bakış](#genel-bakış)
2. [Şirket Yapılandırması](#şirket-yapılandırması)
3. [Android Yapılandırması](#android-yapılandırması)
4. [iOS Yapılandırması](#ios-yapılandırması)
5. [Yeni Bir Şirket Ekleme](#yeni-bir-şirket-ekleme)
6. [Derleme ve Yayınlama](#derleme-ve-yayınlama)
7. [Sorun Giderme](#sorun-giderme)

## Genel Bakış

Bu proje, tek bir kod tabanı kullanarak farklı şirketler için özelleştirilmiş mobil uygulamalar oluşturmanıza olanak tanır. Her şirket için aşağıdaki öğeler özelleştirilebilir:

- Uygulama adı
- Logo
- Tema renkleri
- API endpoint'leri
- Paket/Bundle ID'leri

Proje, SOLID prensiplerine uygun olarak tasarlanmıştır:

- **Single Responsibility Principle (SRP)**: Her sınıf tek bir sorumluluğa sahiptir.
- **Open/Closed Principle (OCP)**: Kod, genişletmeye açık ancak değiştirmeye kapalıdır.
- **Liskov Substitution Principle (LSP)**: Alt sınıflar, üst sınıfların yerine geçebilir.
- **Interface Segregation Principle (ISP)**: İstemciler, kullanmadıkları arayüzlere bağımlı olmamalıdır.
- **Dependency Inversion Principle (DIP)**: Yüksek seviyeli modüller, düşük seviyeli modüllere bağımlı olmamalıdır.

## Şirket Yapılandırması

Şirket yapılandırması, `CompanyConfigModel` sınıfı kullanılarak tanımlanır. Bu sınıf, şirketle ilgili tüm bilgileri içerir:

```dart
CompanyConfigModel(
  companyId: 'company_id',
  companyName: 'Şirket Adı',
  appDisplayName: 'Uygulama Adı',
  logoUrl: 'https://example.com/logo.jpg',
  primaryColor: Color(0xFF4CAF50),
  secondaryColor: Color(0xFF2196F3),
  apiBaseUrl: 'api.example.com',
  androidPackageId: 'com.example.app',
  iosAppId: 'com.example.app',
)
```

Önceden tanımlanmış şirket yapılandırmaları `PredefinedCompanies` sınıfında bulunur. Yeni bir şirket eklemek için bu sınıfı güncelleyebilirsiniz.

Şirket yapılandırmalarını oluşturmak için `CompanyConfigFactory` sınıfı kullanılır. Bu, Factory Method tasarım desenini uygular.

## Android Yapılandırması

Android için, her şirket ve ortam kombinasyonu için flavor'lar tanımlanmıştır. Bu, `build.gradle` dosyasında yapılır:

```gradle
flavorDimensions "environment", "company"
productFlavors {
    // Ortam boyutu
    development {
        dimension "environment"
        applicationIdSuffix ".development"
        versionNameSuffix " Dev"
    }

    product {
        dimension "environment"
    }

    // Şirket boyutu
    kotaTekstil {
        dimension "company"
    }

    company1 {
        dimension "company"
        applicationIdSuffix ".company1"
        resValue "string", "app_name", "Company 1"
    }

    // Birleşik flavor'lar
    developmentCompany1 {
        dimension "environment"
        matchingFallbacks = ["development", "company1"]
    }

    productCompany1 {
        dimension "environment"
        matchingFallbacks = ["product", "company1"]
    }
}
```

## iOS Yapılandırması

iOS için, her şirket için ayrı bir xcconfig dosyası oluşturulmuştur:

- `KotaTekstil.xcconfig`
- `Company1.xcconfig`
- `Company2.xcconfig`

Bu dosyalar, uygulama adı ve bundle ID gibi şirket özelliklerini tanımlar:

```
// Company1.xcconfig
APP_DISPLAY_NAME=Company 1
PRODUCT_BUNDLE_IDENTIFIER=com.glipotions.company1.app
```

Bu xcconfig dosyaları, `Debug.xcconfig` ve `Release.xcconfig` dosyalarında içe aktarılır. Kullanmak istediğiniz şirket yapılandırmasını seçmek için ilgili satırın yorumunu kaldırın:

```
// Include company-specific configuration
// Uncomment the one you want to use
#include "KotaTekstil.xcconfig"
//#include "Company1.xcconfig"
//#include "Company2.xcconfig"
```

## Yeni Bir Şirket Ekleme

Yeni bir şirket eklemek için aşağıdaki adımları izleyin:

1. `PredefinedCompanies` sınıfına yeni bir şirket yapılandırması ekleyin:

```dart
static final CompanyConfigModel newCompany = CompanyConfigModel(
  companyId: 'new_company',
  companyName: 'New Company',
  appDisplayName: 'New Company App',
  logoUrl: 'https://example.com/new_company/logo.jpg',
  primaryColor: const Color(0xFF4CAF50),
  secondaryColor: const Color(0xFF2196F3),
  apiBaseUrl: 'api.newcompany.com',
  androidPackageId: 'com.glipotions.newcompany_app',
  iosAppId: 'com.glipotions.newcompany.app',
);
```

2. `CompanyConfigFactory` sınıfına yeni bir factory metodu ekleyin:

```dart
static CompanyConfigModel createNewCompany() {
  return PredefinedCompanies.newCompany;
}
```

3. `apps/kota_app/lib/companies/` dizini altında yeni bir şirket dizini oluşturun:

```
mkdir -p apps/kota_app/lib/companies/new_company
```

4. Bu dizine `main_development.dart` ve `main_production.dart` dosyalarını ekleyin.

5. Android için `build.gradle` dosyasına yeni flavor'lar ekleyin:

```gradle
newCompany {
    dimension "company"
    applicationIdSuffix ".newcompany"
    resValue "string", "app_name", "New Company"
}

developmentNewCompany {
    dimension "environment"
    matchingFallbacks = ["development", "newCompany"]
}

productNewCompany {
    dimension "environment"
    matchingFallbacks = ["product", "newCompany"]
}
```

6. iOS için yeni bir xcconfig dosyası oluşturun:

```
// NewCompany.xcconfig
APP_DISPLAY_NAME=New Company
PRODUCT_BUNDLE_IDENTIFIER=com.glipotions.newcompany.app
```

7. `melos.yaml` dosyasına yeni derleme komutları ekleyin:

```yaml
build:newcompany:all:
  run: |
    melos run build:newcompany_build_apk_dev && \
    melos run build:newcompany_build_apk_prod && \
    melos run build:newcompany_build_apb_dev && \
    melos run build:newcompany_build_apb_prod
  description: Build apk and appbundle for New Company app.

build:newcompany_build_apk_dev:
  run: melos exec -- flutter build apk --release --flavor developmentNewCompany lib/companies/new_company/main_development.dart --no-tree-shake-icons
  packageFilters:
    scope: 'kota_app'
```

## Derleme ve Yayınlama

Uygulamaları derlemek ve yayınlamak için aşağıdaki komutları kullanabilirsiniz:

### Kota Tekstil

```bash
# Geliştirme APK
melos run build:kota_app_build_apk_dev

# Üretim APK
melos run build:kota_app_build_apk_prod

# Geliştirme App Bundle
melos run build:kota_app_build_apb_dev

# Üretim App Bundle
melos run build:kota_app_build_apb_prod

# Tüm Kota Tekstil derlemeleri
melos run build:all
```

### Company 1

```bash
# Geliştirme APK
melos run build:company1_build_apk_dev

# Üretim APK
melos run build:company1_build_apk_prod

# Geliştirme App Bundle
melos run build:company1_build_apb_dev

# Üretim App Bundle
melos run build:company1_build_apb_prod

# Tüm Company 1 derlemeleri
melos run build:company1:all
```

### Company 2

```bash
# Geliştirme APK
melos run build:company2_build_apk_dev

# Üretim APK
melos run build:company2_build_apk_prod

# Geliştirme App Bundle
melos run build:company2_build_apb_dev

# Üretim App Bundle
melos run build:company2_build_apb_prod

# Tüm Company 2 derlemeleri
melos run build:company2:all
```

## Sorun Giderme

### Yaygın Hatalar ve Çözümleri

#### 1. CompanyConfigModel Çakışması

Eğer `CompanyConfigModel` sınıfı ile ilgili çakışma hataları alıyorsanız, aşağıdaki adımları izleyin:

- İlgili dosyada `common` paketini import ederken `CompanyColors` sınıfını gizleyin:

```dart
import 'package:common/common.dart' hide CompanyColors;
```

- Kendi `CompanyColors` sınıfınızı kullanın:

```dart
import 'package:kota_app/product/theme/company_colors.dart';
```

#### 2. Tema Yöneticisi Sorunları

Eğer tema ile ilgili sorunlar yaşıyorsanız:

- Doğru tema yöneticisinin kullanıldığından emin olun:

```dart
if (config.companyConfig != null) {
  final companyThemeManager = Get.put(
    CompanyThemeManager(companyConfig: config.companyConfig),
    permanent: true,
  );
  await companyThemeManager.init();
} else {
  final themeManager = Get.put(ThemeManager(), permanent: true);
  await themeManager.init();
}
```

#### 3. Logo URL Sorunları

Eğer şirket logosu doğru görüntülenmiyorsa, `getLogoUrl()` fonksiyonunun doğru çalıştığından emin olun:

```dart
String getLogoUrl() {
  try {
    if (Get.isRegistered<CompanyThemeManager>()) {
      final companyThemeManager = Get.find<CompanyThemeManager>();
      return companyThemeManager.companyConfig?.logoUrl ?? defaultLogoUrl;
    }
    return defaultLogoUrl;
  } catch (e) {
    return defaultLogoUrl;
  }
}
```

---

Bu rehber, çoklu şirket yapılandırması için temel bilgileri sağlar. Daha fazla bilgi veya yardım için lütfen geliştirici ekibiyle iletişime geçin.
