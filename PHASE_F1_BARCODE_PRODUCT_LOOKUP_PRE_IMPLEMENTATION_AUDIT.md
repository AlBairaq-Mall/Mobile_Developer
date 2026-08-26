# Phase F1: Barcode Product Lookup & Navigation Pre-Implementation Audit Report

**Document ID:** `PHASE_F1_BARCODE_PRODUCT_LOOKUP_PRE_IMPLEMENTATION_AUDIT.md`  
**Date:** 2026-08-26  
**Mode:** STRICT READ-ONLY / PRE-IMPLEMENTATION AUDIT  
**Scope:** Navigation Restructuring, Barcode Scanning & Product Lookup Architecture, Cart Integration & UI Reuse Blueprint  
**Final Readiness Gate:** **A — READY FOR IMPLEMENTATION** (Complete Architectural Blueprint & Reuse Mapping)

---

## 1. Executive Summary

This pre-implementation audit analyzes the architecture, data models, navigation controllers, UI components, and API integration points for introducing a **Barcode Product Scanner & Lookup** feature into the AlBairaq Supermarket Flutter application, alongside a controlled update to the bottom navigation bar.

The audit was conducted under **strict read-only constraints**. No source files, dependencies, navigation routes, models, or configurations were modified.

### High-Level Architectural Findings:
1. **Navigation Restructuring:** The bottom navigation bar currently houses 5 tabs (`Home`, `Categories`, `Cart`, `Favorites`, `Profile`). Moving `Cart` to position 3 and placing a new `Barcode Scanner` in position 2 (center) requires updating [main_navigation_screen.dart](file:///f:/Product_V_6/prduct_v_6/lib/features/navigation/presentation/main_navigation_screen.dart) and registering `AppRoutes.favorites` explicitly in [app_router.dart](file:///f:/Product_V_6/prduct_v_6/lib/app/router/app_router.dart) so Favorites remains 100% accessible via the Profile screen and direct deep links.
2. **Product & Multi-Unit Architecture:** [ProductModel](file:///f:/Product_V_6/prduct_v_6/lib/core/models/product_model.dart) already supports `barcode`, `uniqueNumber` (shared product/item code), and `units` (`List<ProductUnitModel>`). [ProductUnitsRepository](file:///f:/Product_V_6/prduct_v_6/lib/features/products/repositories/product_units_repository.dart) already implements `getUnitsByUniqueNumber()`.
3. **Cart Integration:** [CartProvider.addItem](file:///f:/Product_V_6/prduct_v_6/lib/features/cart/providers/cart_provider.dart#L190-L245) accepts `(ProductModel product, ProductUnitModel unit, int quantity)` directly. No secondary cart or logic duplication is required.
4. **UI & Design System Reuse:** The existing [ProductDetailsSheet](file:///f:/Product_V_6/prduct_v_6/lib/features/products/widgets/product_details_sheet.dart) and Design System components ([AppButton](file:///f:/Product_V_6/prduct_v_6/lib/core/design_system/components/app_button.dart), [AppIcon](file:///f:/Product_V_6/prduct_v_6/lib/core/design_system/components/app_icon.dart), [AppTextField](file:///f:/Product_V_6/prduct_v_6/lib/core/design_system/components/app_text_field.dart), [AppLoading](file:///f:/Product_V_6/prduct_v_6/lib/core/design_system/components/feedback/app_loading.dart)) provide 100% of the UI widgets needed for product display, unit selection, price calculation, and cart actions.
5. **Dependency Requirement:** The application currently lacks a real-time camera barcode scanner package (e.g. `mobile_scanner`) and camera permissions in `AndroidManifest.xml`. These must be added in the implementation phase.

---

## 2. Current Navigation Architecture

### 2.1 Navigation Implementation Topology
- **Host Screen:** [MainNavigationScreen](file:///f:/Product_V_6/prduct_v_6/lib/features/navigation/presentation/main_navigation_screen.dart)
- **Controller:** [NavigationProvider](file:///f:/Product_V_6/prduct_v_6/lib/features/navigation/providers/navigation_provider.dart) (`ChangeNotifier` managing `_index`)
- **Container:** `IndexedStack` with lazy instantiation array `_tabs = List<Widget?>.filled(5, null)`

### 2.2 Current Tab Slot Allocation (5 Tabs)

| Index | Label | Current Screen | Icon | Auth Guarded | Notes |
|:---:|---|---|---|:---:|---|
| **0** | الرئيسية | `HomeScreen` | `Icons.home_rounded` | No | Public home tab |
| **1** | الأقسام | `CategoriesScreen` | `Icons.grid_view_rounded` | No | Public categories catalog |
| **2** | السلة | `CartScreen` | `Icons.shopping_cart_rounded` | No | Center button (`_CartBtn` gradient container with cart count badge) |
| **3** | المفضلة | `FavoritesScreen` | `Icons.favorite_rounded` | Yes (`AuthGate.check`) | Favorites tab |
| **4** | حسابي | `ProfileScreen` | `Icons.person_rounded` | Yes (`AuthGate.check`) | Customer profile & account menu |

---

## 3. Navigation Change Impact

```
CURRENT BOTTOM NAV:
[0: الرئيسية]  [1: الأقسام]  [2: السلة (Center)]  [3: المفضلة]  [4: حسابي]

TARGET BOTTOM NAV:
[0: الرئيسية]  [1: الأقسام]  [2: الماسح (Center Barcode)]  [3: السلة]  [4: حسابي]
```

### 3.1 Slot Reallocation Mapping

| Index | New Label | Target Screen | Widget Type | Auth Guard | Notes |
|:---:|---|---|---|:---:|---|
| **0** | الرئيسية | `HomeScreen` | `_NavItem` | No | Unchanged |
| **1** | الأقسام | `CategoriesScreen` | `_NavItem` | No | Unchanged |
| **2** | مسح باركود | `BarcodeScannerScreen` | `_CenterScannerBtn` | No | **NEW:** Prominent central scanner shortcut |
| **3** | السلة | `CartScreen` | `_NavItemWithBadge` | No | **MOVED:** Replaces Favorites slot; retains badge |
| **4** | حسابي | `ProfileScreen` | `_NavItem` | Yes | Unchanged |

### 3.2 Preserving Favorites Functionality
1. **Route Declaration in Router:** `AppRoutes.favorites` is defined as `'/favorites'` in [app_routes.dart](file:///f:/Product_V_6/prduct_v_6/lib/app/router/app_routes.dart#L20), but was previously omitted from the `routes` list in [app_router.dart](file:///f:/Product_V_6/prduct_v_6/lib/app/router/app_router.dart). During implementation, `GoRoute(path: AppRoutes.favorites, builder: (_, __) => const FavoritesScreen())` will be added.
2. **Profile Screen Shortcut:** [profile_screen.dart](file:///f:/Product_V_6/prduct_v_6/lib/features/profile/presentation/profile_screen.dart#L155) previously called `context.read<NavigationProvider>().changeTab(3)`. This will be updated to `context.push(AppRoutes.favorites)`, allowing users to open Favorites directly as a full-screen view while preserving state.
3. **Cart Screen Home Navigation:** [cart_screen.dart](file:///f:/Product_V_6/prduct_v_6/lib/features/cart/presentation/cart_screen.dart#L113) calls `changeTab(0)` on empty state ("Start Shopping"), which remains aligned with Home (index 0).

---

## 4. Current Product Architecture

### 4.1 Product Model (`ProductModel`)
Located in [lib/core/models/product_model.dart](file:///f:/Product_V_6/prduct_v_6/lib/core/models/product_model.dart):
- `id` (`String`): Primary product identifier in backend database.
- `uniqueNumber` (`String`): Shared Product/Item Code (`unique_number` in JSON) across all units of the product.
- `barcode` (`String`): Top-level barcode field.
- `nameAr` / `nameEn`: Localized product title.
- `descriptionAr` / `descriptionEn`: Localized product descriptions.
- `images` (`List<String>`): Product gallery image URLs.
- `units` (`List<ProductUnitModel>`): Full collection of packaging units belonging to this product.
- `price` (`double`): Default price (derived from `firstUnit.price`).
- `isAvailable` (`bool`): Inventory/catalog status flag.

### 4.2 Product Repositories & Data Sources
- **Repository Interface:** [ProductRepository](file:///f:/Product_V_6/prduct_v_6/lib/features/products/domain/repositories/product_repository.dart) defines `getProducts({String? search, String? categoryId, int page})` and `getProductById(String id)`.
- **Remote Data Source:** [ProductRemoteDataSource](file:///f:/Product_V_6/prduct_v_6/lib/features/products/data/datasources/product_remote_datasource.dart) connects to `GET /products` and `GET /products/{id}`.
- **Provider:** [ProductProvider](file:///f:/Product_V_6/prduct_v_6/lib/features/products/providers/product_provider.dart) manages active product loading (`loadProduct`), unit selection (`_selectedUnitIndex`), quantity counters (`_quantity`), and in-memory seeding (`setProduct`).

---

## 5. Product Unit Architecture

Located in [lib/features/products/models/product_unit_model.dart](file:///f:/Product_V_6/prduct_v_6/lib/features/products/models/product_unit_model.dart):
```dart
class ProductUnitModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final int quantity;          // Package contents / pieces per unit
  final double price;          // Base price
  final double originalPrice;  // Pre-discount price
  final double discount;       // Discount amount
  final double finalPrice;      // Net price after discount
  final int soldQuantityLast2Days;
  final int buyersCountLast2Days;
}
```

### Key Multi-Unit Properties:
- A single product entity (e.g. "Milk") can have multiple distinct units:
  - Unit 1: "علبة 250 مل" (Piece / Single)
  - Unit 2: "كرتون 12 علبة" (Carton / Box)
  - Unit 3: "شدة 6 علب" (Pack)
- Each unit possesses independent pricing, packaging volume (`quantity`), and promotional discounts.
- All sibling units share the parent product's `uniqueNumber` (Product/Item Code).

---

## 6. Barcode Architecture

```
┌──────────────────────────────────────────────────────────┐
│              Customer Scans or Enters Barcode            │
│                       e.g. 6291003301234                 │
└────────────────────────────┬─────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────┐
│            Product Lookup & Barcode Resolution           │
│        Searches API via /products?search=<barcode>       │
└────────────────────────────┬─────────────────────────────┘
                             │ Returns Product with all units
                             ▼
┌──────────────────────────────────────────────────────────┐
│             Product Model Entity (Parent Product)        │
│   • Shared Product/Item Code (unique_number)             │
│   • Product Title, Images, Description, Category         │
│   • Units Collection: [ Unit 1, Unit 2, Unit 3 ]         │
└────────────────────────────┬─────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────┐
│                 Unit Auto-Selection Rule                 │
│  1. Match unit corresponding to scanned barcode          │
│  2. Default to primary unit if unit-level barcode absent │
│  3. Prominently display selected unit + active offers    │
│  4. Render sibling units in Unit Selector Strip          │
└──────────────────────────────────────────────────────────┘
```

---

## 7. Existing Barcode Support Analysis

| Inspection Item | Current Status | Evidence / Location |
|---|:---:|---|
| **Barcode Data Field in ProductModel** | **Supported** | `ProductModel.barcode` ([product_model.dart#L20](file:///f:/Product_V_6/prduct_v_6/lib/core/models/product_model.dart#L20)) |
| **Barcode Display in Product Details** | **Supported** | `_DetailRow("الباركود", currentProduct.barcode)` ([product_details_screen.dart#L315](file:///f:/Product_V_6/prduct_v_6/lib/features/products/presentation/product_details_screen.dart#L315)) |
| **Camera Barcode Scanning Package** | **Missing** | Not present in `pubspec.yaml` (needs `mobile_scanner`) |
| **Camera Hardware Permission (Android)** | **Missing** | Not declared in `android/app/src/main/AndroidManifest.xml` |
| **Camera Hardware Permission (iOS)** | **Missing** | `NSCameraUsageDescription` not yet declared in `ios/Runner/Info.plist` |
| **Dedicated Scanner UI Screen** | **Missing** | Needs new feature module (`lib/features/scanner/`) |

---

## 8. API & Backend Capability

### 8.1 Existing API Endpoints
- **Product Catalog Search:** `GET /products?search={query}&page=1`
  - Handled by `ProductRemoteDataSource.fetchProducts(search: query)`.
  - Supports numeric barcode strings or textual product codes.
  - Returns `PaginatedResult<List<ProductModel>>` where each `ProductModel` contains its full `units` array and `unique_number`.
- **Product Details by ID:** `GET /products/{id}`
  - Returns full `ProductModel` with category, gallery images, and units.
- **Dedicated Barcode Endpoint:** No endpoint named `/products/barcode/{barcode}` exists in `ApiEndpoints.dart`.
  - **Verdict:** Reusing `GET /products?search={barcode}` is fully compatible and already implemented in the repository layer. Client-side verification matches the exact barcode or `unique_number`.

### 8.2 Promotional Offers Resolution
- [OffersProvider](file:///f:/Product_V_6/prduct_v_6/lib/features/ads/providers/offers_provider.dart) queries `GET /offers`.
- Automatically maps active Buy X Get Y gifts or discount tiers against `(product.id, unit.id)` pairs via `OffersProvider.giftRewardsFor()`.

---

## 9. Product Code Relationship

- **Field Name:** `unique_number` (JSON) -> `uniqueNumber` (Dart).
- **Semantics:** Identifies the overall product item line in the supermarket ERP/POS system.
- **Discovery Mechanism:** When one barcode is resolved to a `ProductModel`, all packaging variations (units) belonging to that same `uniqueNumber` are already populated in `product.units`.
- **Repository Support:** [ProductUnitsRepository.getUnitsByUniqueNumber](file:///f:/Product_V_6/prduct_v_6/lib/features/products/repositories/product_units_repository.dart#L25-L45) already provides a method to resolve sibling units by unique number.

---

## 10. Unit Relationship

- **Unit Differences:**
  - `nameAr` / `nameEn` (e.g. حبة, درزن, كرتون)
  - `price` (regular unit selling price)
  - `originalPrice` (pre-discount cross-out price)
  - `discount` (percentage or fixed value)
  - `finalPrice` (net discounted price)
  - `quantity` (package count / units per box)
- **Selection State:** When the barcode lookup completes:
  1. The scanned unit is matched and set as `selectedUnitIndex`.
  2. The UI displays the selected unit's price and package quantity.
  3. If the user taps another unit chip, `selectedUnitIndex` updates immediately, and the price/quantity selector recalculates without a new network request.

---

## 11. Existing Cart Integration

The existing cart pipeline in [CartProvider](file:///f:/Product_V_6/prduct_v_6/lib/features/cart/providers/cart_provider.dart) is fully compatible:

```dart
// Direct Reuse Pattern (No Cart Duplication):
final cart = context.read<CartProvider>();

final response = await cart.addItem(
  product: product,
  unit: selectedUnit,
  originalPrice: selectedUnit.originalPrice > selectedUnit.price
      ? selectedUnit.originalPrice
      : selectedUnit.price,
  unitPrice: selectedUnit.finalPrice > 0
      ? selectedUnit.finalPrice
      : selectedUnit.price,
  quantity: quantity,
);
```

### Cart Capabilities Reused Out-of-the-Box:
- Atomic local storage persistence (`_saveCart()`) for instant optimistic UI.
- Dual-mode support (Guest local storage vs. Authenticated Sanctum API sync).
- Multi-unit line separation (same product in two different units creates two distinct cart items: `CartItemModel(product, unit1)` and `CartItemModel(product, unit2)`).
- Cart count badge automatic increment on the bottom navigation bar.

---

## 12. Existing Product UI Reuse Opportunities

| UI Need | Existing Component | File Path | Reuse Strategy |
|---|---|---|---|
| **Product Display & Unit Switcher** | `ProductDetailsSheet` | [product_details_sheet.dart](file:///f:/Product_V_6/prduct_v_6/lib/features/products/widgets/product_details_sheet.dart) | Open directly as a modal sheet upon successful scan, pre-selecting the scanned unit |
| **Quantity Selector** | `AppQuantitySelector` | [app_quantity_selector.dart](file:///f:/Product_V_6/prduct_v_6/lib/app/widgets/app_quantity_selector.dart) | Increment / decrement quantity directly |
| **Price Display with Discounts** | `AppPrice` | [app_price.dart](file:///f:/Product_V_6/prduct_v_6/lib/app/widgets/app_price.dart) | Display current unit price, old price, and discount percentage |
| **Cached Product Images** | `AppCachedImage` | [app_cached_image.dart](file:///f:/Product_V_6/prduct_v_6/lib/app/widgets/app_cached_image.dart) | Render product thumbnail with shimmer placeholder |
| **Unit Selection Chips** | `CategoryChip` / Unit Selector | [product_details_sheet.dart#L590](file:///f:/Product_V_6/prduct_v_6/lib/features/products/widgets/product_details_sheet.dart#L590) | Interactive unit toggle list |

---

## 13. Design System Reuse

All scanner and lookup UI will be built exclusively using existing tokens and components:
- **Buttons:** `AppButton` (Primary for Add to Cart, Outlined for Manual Entry, Ghost for Rescan).
- **Icons:** `AppIcon` with `Icons.qr_code_scanner_rounded`, `Icons.flash_on_rounded`, `Icons.flash_off_rounded`, `Icons.keyboard_alt_outlined`.
- **Text Fields:** `AppTextField` with numeric keypad for manual barcode input.
- **Feedback:** `AppLoading` for search progress, `AppEmptyState` ("المنتج غير موجود"), `AppErrorState` for camera permission errors.
- **Typography:** `AppTypography.headingMedium`, `AppTypography.bodyMedium`, `AppTypography.labelSmall`.
- **Colors:** `AppColors.primary`, `AppColors.surface`, `AppColors.surfaceVariant`, `AppColors.error`.

---

## 14. RTL & Accessibility Considerations

- **Camera Viewfinder Overlay:** Symmetrical square/rectangular scanning window with RTL-aligned Arabic helper text ("وجّه الكاميرا نحو باركود المنتج").
- **Manual Input Modal:** Numeric keypad with LTR text direction for the barcode digits (`TextDirection.ltr`), wrapped in RTL Arabic labels and hints.
- **Torch & Flip Controls:** 48x48dp minimum touch target bounding boxes (`AppAccessibility.withMinTouchTarget`).
- **Permission Dialogs:** Clear Arabic explanation if camera permission is denied, with direct button to open app settings.

---

## 15. Dependency Requirements (For Implementation Phase)

To support real-time continuous video frame barcode scanning on both Android and iOS:
- **Recommended Package:** `mobile_scanner: ^6.0.2` (Modern ML Kit-based scanner supporting EAN-13, EAN-8, Code 128, QR, UPC-A, UPC-E).
- **Permission Requirement (Android):** `<uses-permission android:name="android.permission.CAMERA"/>` in `android/app/src/main/AndroidManifest.xml`.
- **Permission Requirement (iOS):** `NSCameraUsageDescription` ("نحتاج إذن الكاميرا لمسح باركود المنتجات في السوبرماركت") in `ios/Runner/Info.plist`.

---

## 16. Exact Files That Would Need Modification

| File Path | Component | Planned Modification in Phase F2 |
|---|---|---|
| `pubspec.yaml` | Dependencies | Add `mobile_scanner` |
| `android/app/src/main/AndroidManifest.xml` | Manifest | Add `android.permission.CAMERA` |
| `lib/app/router/app_routes.dart` | Routes | Ensure `scanner` and `favorites` constants exist |
| `lib/app/router/app_router.dart` | Router | Add `GoRoute(path: AppRoutes.favorites, ...)` and `GoRoute(path: AppRoutes.scanner, ...)` |
| `lib/features/navigation/presentation/main_navigation_screen.dart` | Bottom Nav | Swap Favorites to Cart; Add center Barcode Scanner button |
| `lib/features/profile/presentation/profile_screen.dart` | Profile Menu | Change Favorites click from `changeTab(3)` to `context.push(AppRoutes.favorites)` |
| `lib/features/scanner/presentation/barcode_scanner_screen.dart` | New Screen | **NEW:** Camera viewfinder + manual entry sheet + scan animation |
| `lib/features/scanner/providers/barcode_lookup_provider.dart` | New Provider | **NEW:** Lookup orchestration connecting repository, unit auto-selection, and error handling |

---

## 17. Files That Must NOT Be Modified

- `lib/features/cart/providers/cart_provider.dart` (Cart calculations, line storage, and API sync are completely intact).
- `lib/features/checkout/*` (Checkout and order creation flows must remain untouched).
- `lib/core/design_system/tokens/*` (Design tokens must not be changed).
- `android/app/build.gradle.kts` & signing configs (Keystore, passwords, release signing configuration must remain untouched).

---

## 18. Proposed Data Flow

```
1. Customer triggers scan (Camera detection or Manual keypad submission)
                               │
                               ▼
2. BarcodeLookupProvider calls ProductRepository.getProducts(search: barcode)
                               │
                               ▼
3. API returns matching ProductModel (with uniqueNumber and full units collection)
                               │
                               ▼
4. Provider matches scanned barcode to specific ProductUnitModel:
   - If unit matched: set as selectedUnitIndex
   - If only product matched: select defaultUnit (first unit)
                               │
                               ▼
5. ProductDetailsSheet opens with pre-selected unit, live price, and offer badges
                               │
                               ▼
6. Customer modifies quantity and clicks "Add to Cart"
                               │
                               ▼
7. CartProvider.addItem(product, unit, qty) updates cart & increments Nav Cart badge
```

---

## 19. Proposed UI Flow

1. **Tap Center Scanner Icon in Bottom Nav:**
   - Opens `BarcodeScannerScreen` with full-screen camera preview, illuminated scan line animation, and torch toggle.
2. **Bottom Action Bar on Scanner Screen:**
   - Button 1: "إدخال يدوي" (Opens compact bottom sheet with numeric input field).
   - Button 2: "تشغيل الفلاش" (Toggles camera torch).
3. **Detection Event:**
   - Device vibrates briefly (`HapticFeedback.mediumImpact()`).
   - Scanner pauses frame stream to prevent duplicate scans.
   - Shows compact floating `AppLoading` indicator ("جاري البحث عن المنتج...").
4. **Product Result Presentation:**
   - `ProductDetailsSheet` slides up smoothly over the scanner screen.
   - The scanned unit is highlighted in the unit selector.
   - Customer can switch units, adjust quantity, or click "إضافة إلى السلة".
5. **Dismissal / Continuous Scanning:**
   - When the sheet is closed or item added, scanner resumes camera stream ready for next product.

---

## 20. Risks & Unknowns

| Risk | Likelihood | Impact | Mitigation Strategy |
|---|:---:|:---:|---|
| **Camera Permission Denied** | Medium | Low | Provide clear Arabic permission rationale + fallback to manual barcode entry sheet |
| **Running on Emulator / Simulator** | High (Dev) | Low | Automatically display manual barcode entry UI when camera hardware is unavailable |
| **Poor Lighting / Blurry Barcode** | Medium | Low | Torch toggle button + high-contrast manual input fallback |
| **Search returns multiple products for partial code** | Low | Medium | Client-side exact match filter: prioritize `product.barcode == scanned` or `product.uniqueNumber == scanned` |

---

## 21. Missing Backend Capability Assessment

- **Is a new backend endpoint mandatory?** **No.**
  - `GET /products?search=<barcode>` already exists and returns the full `ProductModel` containing the `unique_number` and all `units`.
  - The frontend architecture can resolve the product and its units without backend changes.

---

## 22. Implementation Recommendations (Phase F2 Plan)

1. **Step 1:** Add `mobile_scanner` to `pubspec.yaml` and camera permissions to `AndroidManifest.xml`.
2. **Step 2:** Register `AppRoutes.favorites` in `AppRouter` and update `ProfileScreen` favorites button to `context.push(AppRoutes.favorites)`.
3. **Step 3:** Update `MainNavigationScreen` to place `BarcodeScannerScreen` at index 2 and `CartScreen` at index 3.
4. **Step 4:** Implement `BarcodeLookupProvider` and `BarcodeScannerScreen` utilizing `ProductDetailsSheet` and `CartProvider`.
5. **Step 5:** Run `flutter analyze` and `flutter test` to verify zero regressions.

---

## 23. Strict Scope Boundary

- **In Scope for Phase F2:** Bottom navigation reallocation, `mobile_scanner` integration, scanner screen with manual input fallback, pre-selecting scanned unit, direct cart addition via `CartProvider`.
- **Out of Scope for Phase F2:** Modifying cart calculation engine, modifying checkout, changing server-side database schemas, modifying Android signing keys.

---

## 24. Final Readiness Gate

### **A — READY FOR IMPLEMENTATION**

> The pre-implementation audit is complete. All architectural connections, navigation impacts, model relationships, cart pipelines, and UI reuse opportunities are mapped and ready for execution in Phase F2.
