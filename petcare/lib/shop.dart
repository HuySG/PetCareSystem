import 'package:flutter/material.dart';
import 'package:petcare/InsightPageView.dart';
import 'package:petcare/cart.dart';
import 'package:petcare/home.dart';
import 'package:petcare/insight.dart';
import 'package:petcare/model-petcare/cart-item.dart';
import 'package:petcare/model-petcare/product.dart';
import 'package:petcare/model-petcare/service.dart';
import 'package:petcare/api-petcare/api.dart';
import 'package:petcare/productdetail.dart';
import 'package:petcare/servicedetail.dart';
import 'package:petcare/session-petcare/session.dart';
import 'package:petcare/userprofile.dart';

class shop extends StatefulWidget {
  final int initialTabIndex; // Add this line
  const shop({super.key, this.initialTabIndex = 0}); // Add this parameter
  @override
  State<shop> createState() => _shopState();
}

class _shopState extends State<shop> with TickerProviderStateMixin {
  // Use TickerProviderStateMixin
  late AnimationController _controller;
  late TabController _tabController;

  int numberOfItemsInCart = 1; // Số lượng đơn hàng trong giỏ hàng
  int _currentIndex = 1; // Index for the selected tab
  int _currentIndexx = 0; // Index for the selected tab
  final List<Widget> _screens = [];
  int currentPage = 0;
  final int itemsPerPage = 4;

  late List<Product> listProduct = [];
  late List<Service> listService = [];

  List<CartItem> cartItems = [];

  //search
  String searchQuery = ""; // Initialize search query

  void loadProducts() async {
    List<Product> loadedProducts = await API.getProducts();
    setState(() {
      listProduct = loadedProducts;
    });
  }

  void loadServices() async {
    List<Service> loadedServices = await API.getServices();
    setState(() {
      listService = loadedServices;
    });
  }

  @override
  void initState() {
    super.initState();
    // Load data for both products and services
    loadProducts();
    loadServices();
    _controller = AnimationController(vsync: this);
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex, // Use the initialTabIndex
    );

    cartItems = SessionManager().getCart() ?? [];
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose(); // Dispose of the TabController
    super.dispose();
  }

  List<Product> getProductsForPage(int page, List<Product> products) {
    final startIndex = page * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return products.sublist(
      startIndex,
      endIndex < products.length ? endIndex : products.length,
    );
  }

  List<Service> getServicesForPage(int page, List<Service> services) {
    final startIndex = page * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return services.sublist(
      startIndex,
      endIndex < services.length ? endIndex : services.length,
    );
  }

  // Create a filtered list of products based on the search query
  List<Product> getFilteredProducts() {
    return listProduct.where((product) {
      final productName = product.productName!.toLowerCase();
      final query = searchQuery.toLowerCase();
      return productName.contains(query);
    }).toList();
  }

  // Create a filtered list of services based on the search query
  List<Service> getFilteredServices() {
    return listService.where((service) {
      final serviceName = service.serviceName!.toLowerCase();
      final query = searchQuery.toLowerCase();
      return serviceName.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // final totalPagesForProducts = (listProduct.length / itemsPerPage).ceil();
    // final totalPagesForServices = (listService.length / itemsPerPage).ceil();

    final filteredProducts = getFilteredProducts(); // Get filtered products
    final filteredServices = getFilteredServices(); // Get filtered services

    int totalPagesForProducts = (filteredProducts.length / itemsPerPage).ceil();
    int totalPagesForServices = (filteredServices.length / itemsPerPage).ceil();
    return WillPopScope(
      onWillPop: () async {
        // You can implement your logic here to decide whether to allow back navigation or not.
        // Return false to prevent the user from going back.

        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 12.0), // Adjust content padding
                          hintText:
                              'Search Product or Service', // Văn bản gợi ý
                          border: OutlineInputBorder(), // Viền cho ô tìm kiếm
                          suffixIcon:
                              Icon(Icons.search), // Icon tìm kiếm bên phải
                        ),
                        // Xử lý khi người dùng nhập tìm kiếm và nhấn Enter
                        onSubmitted: (value) {
                          setState(() {
                            searchQuery = value; // Update the search query
                          });
                        },
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Xử lý khi người dùng nhấn vào biểu tượng túi mua sắm
                            // Ví dụ: Mở giỏ hàng
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => cart(),
                              ),
                            );
                          },
                          icon: Icon(Icons.shopping_bag),
                        ),
                        if (cartItems
                            .isNotEmpty) // Only display the badge if the cart is not empty
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(
                                    0xFFB12A1C), // You can change the color to match your design
                              ),
                              child: Text(
                                cartItems.length.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      'Products',
                      style: TextStyle(
                        color: _currentIndexx == 0
                            ? Color(0xFFB12A1C) // Selected tab color
                            : Colors.black, // Unselected tab color
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Services',
                      style: TextStyle(
                        color: _currentIndexx == 1
                            ? Color(0xFFB12A1C) // Selected tab color
                            : Colors.black, // Unselected tab color
                      ),
                    ),
                  ),
                ],
                controller: _tabController, // Use _tabController
                onTap: (index) {
                  setState(() {
                    _currentIndexx = index;
                  });
                },
                labelColor: Color(0xFFFFBD58), // Text color for selected tab
                unselectedLabelColor:
                    Colors.black, // Text color for unselected tabs
                indicatorColor: Color(
                    0xFFFFBD58), // Color of the underline for the selected tab
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab View for Products
                    buildProductListView(
                        totalPagesForProducts, filteredProducts),

                    // Tab View for Services
                    buildServiceListView(
                        totalPagesForServices, filteredServices),
                  ],
                  controller: _tabController, // Use _tabController
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => shop()),
              );
            }
            if (index == 0) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => home()),
              );
            }
            if (index == 2) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => InsightPageView()),
              );
            }
            if (index == 3) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => userprofile()),
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0 ? Color(0xFFB12A1C) : Colors.black,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.pets,
                color: _currentIndex == 1 ? Color(0xFFB12A1C) : Colors.black,
              ),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bar_chart,
                color: _currentIndex == 2 ? Color(0xFFB12A1C) : Colors.black,
              ),
              label: 'Insight',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _currentIndex == 3 ? Color(0xFFB12A1C) : Colors.black,
              ),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Color(0xFFB12A1C), // Màu của label khi được chọn
          unselectedItemColor:
              Colors.black, // Màu của label khi không được chọn
          selectedLabelStyle:
              TextStyle(color: Colors.black), // Màu của chữ label
          unselectedLabelStyle: TextStyle(color: Color(0xFFB12A1C)),
        ),
      ),
    );
  }

  Widget buildProductListView(int totalPages, List<Product> products) {
    // Use the filtered products for rendering
    final productsForCurrentPage = getProductsForPage(currentPage, products);

    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: productsForCurrentPage.length,
            itemBuilder: (context, index) {
              final product = productsForCurrentPage[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to the ProductDetail screen when a product is tapped
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => productdetail(product: product),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        product.image!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      ListTile(
                        title: Text(
                          product.productName!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        subtitle: Text(
                          'Price: \$${product.price}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xFFB12A1C),
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        buildPagination(totalPages),
      ],
    );
  }

  Widget buildServiceListView(int totalPages, List<Service> services) {
    // Use the filtered services for rendering
    final servicesForCurrentPage = getServicesForPage(currentPage, services);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: servicesForCurrentPage.length,
            itemBuilder: (context, index) {
              final service = servicesForCurrentPage[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to the ProductDetail screen when a product is tapped
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => servicedetail(service: service),
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                service.serviceName!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Price: ${service.price}',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Image.network(
                            service.image!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        buildPagination(totalPages),
      ],
    );
  }

  Widget buildPagination(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int page = 0; page < totalPages; page++)
          InkWell(
            onTap: () {
              setState(() {
                currentPage = page.clamp(0, totalPages - 1);
              });
            },
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: currentPage == page ? Color(0xFFB12A1C) : Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                (page + 1).toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      currentPage == page ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
