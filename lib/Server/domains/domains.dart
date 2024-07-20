class AppLink {
  static const String server = "https://ustore.ps/login/api/";
// ================================= Auth ========================== //
  static const String signUp = "${server}register";
  static const String login = "${server}login";
  static const String sentOtp = "${server}send-otp";
  static const String contactUs = "${server}contact-us";
  static const String logout = "${server}logout";
  static const String customers = "${server}Customers";
  static const String ordersWithUserID =
      "${server}get_orders_depend_on_user_id";

// ================================= general ========================== //
  static const String homeData = "${server}homepagetalabat";
  static const String storeDetails = "${server}restaurants";
  static const String addOrder = "${server}add_order_talabat";
}
