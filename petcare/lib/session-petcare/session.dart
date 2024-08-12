import 'package:petcare/model-petcare/appointment.dart';
import 'package:petcare/model-petcare/cart-item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static SessionManager? _instance;
  factory SessionManager() => _instance ??= SessionManager._();
  SessionManager._();

  SharedPreferences? _preferences;

  int? userId;
  List<CartItem> cartItems = [];

  // Save the user ID to the session
  void setUserId(int id) {
    _preferences?.setInt('userId', id);
  }

  // Get the user ID from the session
  int? getUserId() {
    return _preferences?.getInt('userId');
  }

  // Initialize the session manager
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Add a cart item to the cart
  void addToCart(CartItem cartItem) {
    // Check if the product is already in the cart
    final existingItemIndex = cartItems.indexWhere(
      (item) =>
          item.itemType == cartItem.itemType &&
          ((item.product != null &&
                  cartItem.product != null &&
                  item.product!.productId == cartItem.product!.productId) ||
              (item.service != null &&
                  cartItem.service != null &&
                  item.service!.serviceId == cartItem.service!.serviceId)),
    );

    if (existingItemIndex != -1) {
      // Product already in the cart, increase its quantity
      cartItems[existingItemIndex].quantity++;
    } else {
      // Product not in the cart, add it as a new item
      cartItems.add(cartItem);
    }
  }

  // Get the cart items
  List<CartItem> getCart() {
    return cartItems;
  }

  // Clear the cart
  void clearCart() {
    cartItems.clear();
  }

  //apppointment
  List<Appointment> appointments = [];
// Add an appointment to the session
  void addAppointment(Appointment appointment) {
    appointments.add(appointment);
  }

  //logout
  // Clear user session data (logout)
  void clearSession() {
    _preferences?.clear();
  }
}
