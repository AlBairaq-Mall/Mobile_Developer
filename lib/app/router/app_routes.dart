class AppRoutes {
  AppRoutes._();

  // Customer
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const password = "/password";
  static const register = '/register';
  static const otp = '/otp';
  static const home = '/home';
  static const search = '/search';
  static const categories = '/categories';
  static const cart = '/cart';
  static const orders = '/orders';
  static const myOrders = "/my-orders";
  static const orderDetails = "/orders/details";
  static const profile = '/profile';
  static const checkout = '/checkout';
  static const favorites = '/favorites';
  static const notifications = '/notifications';
  static const addresses = '/addresses';
  static const product = '/product';
  static const settings = '/settings';
  static const orderSuccess = '/order-success';
  static const orderTracking = '/order-tracking/:orderNumber';

  // Static Info
  static const aboutUs = '/about-us';
  static const contactUs = '/contact-us';
  static const faq = '/faq';
  static const privacyPolicy = '/privacy-policy';
  static const termsOfUse = '/terms-of-use';

  // Admin
  static const adminLogin = '/admin/login';
  static const adminDashboard = '/admin/dashboard';
  static const adminOrders = '/admin/orders';
  static const adminProducts = '/admin/products';
  static const adminUsers = '/admin/users';
  static const adminDelivery = '/admin/delivery';
  static const adminReports = '/admin/reports';
  static const adminSettings = '/admin/settings';
  static const adminAds = '/admin/ads';
  static const adminOffers = '/admin/offers';

  // Delivery Driver
  static const deliveryLogin = '/delivery/login';
  static const deliveryHome = '/delivery/home';
  static const deliveryEarnings = '/delivery/earnings';
}
