// # Proxy Compiler 21.11.3

import Foundation
import SAPOData

internal enum ESPMContainerStaticResolver {
    static func resolve() {
        ESPMContainerStaticResolver.resolve1()
    }

    private static func resolve1() {
        _ = ESPMContainerMetadata.ComplexTypes.address
        _ = ESPMContainerMetadata.EntityTypes.customer
        _ = ESPMContainerMetadata.EntityTypes.product
        _ = ESPMContainerMetadata.EntityTypes.productCategory
        _ = ESPMContainerMetadata.EntityTypes.productText
        _ = ESPMContainerMetadata.EntityTypes.purchaseOrderHeader
        _ = ESPMContainerMetadata.EntityTypes.purchaseOrderItem
        _ = ESPMContainerMetadata.EntityTypes.salesOrderHeader
        _ = ESPMContainerMetadata.EntityTypes.salesOrderItem
        _ = ESPMContainerMetadata.EntityTypes.stock
        _ = ESPMContainerMetadata.EntityTypes.supplier
        _ = ESPMContainerMetadata.EntitySets.customers
        _ = ESPMContainerMetadata.EntitySets.productCategories
        _ = ESPMContainerMetadata.EntitySets.productTexts
        _ = ESPMContainerMetadata.EntitySets.products
        _ = ESPMContainerMetadata.EntitySets.purchaseOrderHeaders
        _ = ESPMContainerMetadata.EntitySets.purchaseOrderItems
        _ = ESPMContainerMetadata.EntitySets.salesOrderHeaders
        _ = ESPMContainerMetadata.EntitySets.salesOrderItems
        _ = ESPMContainerMetadata.EntitySets.stock
        _ = ESPMContainerMetadata.EntitySets.suppliers
        _ = ESPMContainerMetadata.ActionImports.generateSamplePurchaseOrders
        _ = ESPMContainerMetadata.ActionImports.generateSampleSalesOrders
        _ = ESPMContainerMetadata.ActionImports.resetSampleData
        _ = ESPMContainerMetadata.ActionImports.updateSalesOrderStatus
        _ = Address.houseNumber
        _ = Address.street
        _ = Address.city
        _ = Address.country
        _ = Address.postalCode
        _ = Customer.city
        _ = Customer.country
        _ = Customer.customerID
        _ = Customer.dateOfBirth
        _ = Customer.emailAddress
        _ = Customer.firstName
        _ = Customer.houseNumber
        _ = Customer.lastName
        _ = Customer.phoneNumber
        _ = Customer.postalCode
        _ = Customer.street
        _ = Customer.address
        _ = Customer.updatedTimestamp
        _ = Customer.salesOrders
        _ = Product.category
        _ = Product.categoryName
        _ = Product.currencyCode
        _ = Product.dimensionDepth
        _ = Product.dimensionHeight
        _ = Product.dimensionUnit
        _ = Product.dimensionWidth
        _ = Product.longDescription
        _ = Product.name
        _ = Product.pictureUrl
        _ = Product.price
        _ = Product.productID
        _ = Product.quantityUnit
        _ = Product.shortDescription
        _ = Product.supplierID
        _ = Product.updatedTimestamp
        _ = Product.weight
        _ = Product.weightUnit
        _ = Product.stockDetails
        _ = Product.supplierDetails
        _ = ProductCategory.category
        _ = ProductCategory.categoryName
        _ = ProductCategory.mainCategory
        _ = ProductCategory.mainCategoryName
        _ = ProductCategory.numberOfProducts
        _ = ProductCategory.updatedTimestamp
        _ = ProductText.id
        _ = ProductText.language
        _ = ProductText.longDescription
        _ = ProductText.name
        _ = ProductText.productID
        _ = ProductText.shortDescription
        _ = PurchaseOrderHeader.currencyCode
        _ = PurchaseOrderHeader.grossAmount
        _ = PurchaseOrderHeader.netAmount
        _ = PurchaseOrderHeader.purchaseOrderID
        _ = PurchaseOrderHeader.supplierID
        _ = PurchaseOrderHeader.taxAmount
        _ = PurchaseOrderHeader.items
        _ = PurchaseOrderHeader.supplierDetails
        _ = PurchaseOrderItem.currencyCode
        _ = PurchaseOrderItem.grossAmount
        _ = PurchaseOrderItem.itemNumber
        _ = PurchaseOrderItem.netAmount
        _ = PurchaseOrderItem.productID
        _ = PurchaseOrderItem.purchaseOrderID
        _ = PurchaseOrderItem.quantity
        _ = PurchaseOrderItem.quantityUnit
        _ = PurchaseOrderItem.taxAmount
        _ = PurchaseOrderItem.header
        _ = PurchaseOrderItem.productDetails
        _ = SalesOrderHeader.createdAt
        _ = SalesOrderHeader.currencyCode
        _ = SalesOrderHeader.customerID
        _ = SalesOrderHeader.grossAmount
        _ = SalesOrderHeader.lifeCycleStatus
        _ = SalesOrderHeader.lifeCycleStatusName
        _ = SalesOrderHeader.netAmount
        _ = SalesOrderHeader.salesOrderID
        _ = SalesOrderHeader.taxAmount
        _ = SalesOrderHeader.items
        _ = SalesOrderHeader.customerDetails
        _ = SalesOrderItem.currencyCode
        _ = SalesOrderItem.deliveryDate
        _ = SalesOrderItem.grossAmount
        _ = SalesOrderItem.itemNumber
        _ = SalesOrderItem.netAmount
        _ = SalesOrderItem.productID
        _ = SalesOrderItem.quantity
        _ = SalesOrderItem.quantityUnit
        _ = SalesOrderItem.salesOrderID
        _ = SalesOrderItem.taxAmount
        _ = SalesOrderItem.header
        _ = SalesOrderItem.productDetails
        _ = Stock.lotSize
        _ = Stock.minStock
        _ = Stock.productID
        _ = Stock.quantity
        _ = Stock.quantityLessMin
        _ = Stock.updatedTimestamp
        _ = Stock.productDetails
        _ = Supplier.city
        _ = Supplier.country
        _ = Supplier.emailAddress
        _ = Supplier.houseNumber
        _ = Supplier.phoneNumber
        _ = Supplier.postalCode
        _ = Supplier.street
        _ = Supplier.supplierID
        _ = Supplier.supplierName
        _ = Supplier.address
        _ = Supplier.updatedTimestamp
        _ = Supplier.products
        _ = Supplier.purchaseOrders
    }
}
