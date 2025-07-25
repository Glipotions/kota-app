/// Enums that represnt key values for caching
enum CacheKey {
  /// Key that holds current user token
  token,

  /// Key that holds if user logged in or not
  loggedIn,

  /// Key that holds selected current colorCode
  colorCode,

  /// Key that holds selected current lanCode
  lanCode,
  isRemember,
  /// Key that holds user roles
  userRoles,

  /// Key that holds cart discount rate for logged-in users
  cartDiscountRate,

  /// Key that holds cart description for logged-in users
  cartDescription,
}


enum SecuredCacheKey { username, password }
