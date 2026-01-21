//
//  PrimerDia.swift
//  
//
//  Created by Fran Villa on 21/1/26.
//


import Foundation

// MARK: - Enums
enum ProductCategory {
    case electronics(brand: String, warranty: Int) // años de garantía
    case food(expirationDate: Date)
    case clothing(size: String, material: String)
    case other(description: String)
}

// MARK: - Structs
struct Product {
    let id: UUID
    let name: String
    let category: ProductCategory
    var price: Double
    var discount: Double? // PREGUNTA: ¿Por qué opcional? --> Porque puede ser que no tenga valor
    var stock: Int
    
    // DESAFÍO 1: Crea un computed property 'finalPrice'
    // que calcule precio - descuento (si existe)
    var finalPrice: Double {
        let discountEnd = (price * (discount ?? 0)) / 100
        return price - discountEnd
    }
    
    // DESAFÍO 2: Crea un método que retorne un String
    // describiendo la categoría de forma legible
    func categoryDescription() -> String {
        // TU CÓDIGO AQUÍ
        // Pista: usa switch con pattern matching
        switch category {
        case .electronics(let brand, let warranty):
            return "Electrónica: \(brand) (\(warranty) años garantía)"
        case .food(let expirationDate):
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return "Alimento (caduca: \(formatter.string(from: expirationDate)))"
        case .clothing(let size, let material):
            return  "La ropa tiene la talla: \(size) y el material es \(material)"
        case .other(let description):
            return "Otros: \(description)"
        }

    }
}

// MARK: - Product Catalog
struct ProductCatalog {
    private var products: [Product] = []
    
    // DESAFÍO 3: Implementa este método
    mutating func addProduct(_ product: Product) {
        // TU CÓDIGO AQUÍ
        // ¿Por qué necesitamos 'mutating'? --> Se necesita mutatin para poder modifcarlo
        products.append(product)
    }
    
    // DESAFÍO 4: Buscar producto por nombre
    func findProduct(byName name: String) -> Product? {
        // $0 indica el parametro que obtenemos
        // PREGUNTA: ¿Por qué retorna Product? y no Product? -> Porque Product puede estar vacio
        return products.first { $0.name == name }
    }
    
    // DESAFÍO 5: Filtrar productos con descuento
    func productsWithDiscount() -> [Product] {
        return products.filter{ $0.discount != nil }
    }
    
    // DESAFÍO 6: Precio total del inventario
    func totalInventoryValue() -> Double {
        // TU CÓDIGO AQUÍ
        /**
         * Así sería con un for loop
         var total = 0.0
         for producto in products {
             total += producto.finalPrice
         }
         */
        return products.reduce(0) {acumulado, producto in
            return acumulado + producto.finalPrice
            
        }
    }
}

let iphone = Product(
    id: UUID(),
    name: "iPhone 15",
    category: .electronics(brand: "Apple", warranty: 2),
    price: 999.99,
    discount: 50.0,
    stock: 10
)

print(iphone.categoryDescription())
// Debería imprimir: "Electrónica: Apple (2 años garantía)"

let milk = Product(
    id: UUID(),
    name: "Leche Entera",
    category: .food(expirationDate: Date().addingTimeInterval(7 * 24 * 60 * 60)),
    price: 2.50,
    discount: nil,
    stock: 50
)

print(milk.categoryDescription())
// Debería imprimir: "Alimento (caduca: 28/01/2026)" (o similar)

let tshirt = Product(
    id: UUID(),
    name: "Camiseta Básica",
    category: .clothing(size: "M", material: "Algodón"),
    price: 15.99,
    discount: 3.0,
    stock: 30
)

print(tshirt.categoryDescription())
// MARK: - Testing Completo
var catalog = ProductCatalog()

catalog.addProduct(iphone)
catalog.addProduct(milk)
catalog.addProduct(tshirt)

print("=== BÚSQUEDA ===")
if let found = catalog.findProduct(byName: "iPhone 15") {
    print("✅ Encontrado: \(found.name)")
    print("   Categoría: \(found.categoryDescription())")
    print("   Precio original: €\(found.price)")
    print("   Descuento: \(found.discount ?? 0)%")
    print("   Precio final: €\(found.finalPrice)")
} else {
    print("❌ No encontrado")
}

print("\n=== BÚSQUEDA FALLIDA ===")
if let notFound = catalog.findProduct(byName: "PlayStation 5") {
    print("Encontrado: \(notFound.name)")
} else {
    print("✅ Correctamente retorna nil")
}

print("\n=== PRODUCTOS CON DESCUENTO ===")
let withDiscount = catalog.productsWithDiscount()
print("Total: \(withDiscount.count) productos con descuento")
for product in withDiscount {
    let savings = product.price - product.finalPrice
    print("• \(product.name)")
    print("  Precio: €\(product.price) → €\(product.finalPrice)")
    print("  Ahorro: €\(String(format: "%.2f", savings))")
}

print("\n=== VALOR TOTAL INVENTARIO ===")
let total = catalog.totalInventoryValue()
print("Valor total del catálogo: €\(String(format: "%.2f", total))")

print("\n=== DESGLOSE ===")
for product in [iphone, milk, tshirt] {
    print("• \(product.name): €\(String(format: "%.2f", product.finalPrice))")
}
