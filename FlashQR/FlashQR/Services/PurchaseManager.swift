import Foundation
import StoreKit

@Observable
final class PurchaseManager {
    var isProPurchased: Bool = false
    var isLoading: Bool = false

    private let productID = "com.zzoutuo.FlashQR.pro"
    private var product: Product?
    private var transactionListener: Task<Void, Never>?

    init() {
        transactionListener = Task {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    if transaction.productID == self.productID {
                        self.isProPurchased = transaction.revocationDate == nil
                    }
                    await transaction.finish()
                }
            }
        }
        Task {
            await checkPurchaseStatus()
        }
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [productID])
            product = products.first
        } catch {
            print("Failed to load product: \(error)")
        }
    }

    func purchasePro() async -> Bool {
        guard let product = product else {
            await loadProduct()
            guard let product = self.product else { return false }
            return await purchase(product: product)
        }
        return await purchase(product: product)
    }

    private func purchase(product: Product) async -> Bool {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    isProPurchased = transaction.revocationDate == nil
                    await transaction.finish()
                    return true
                }
            case .pending, .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
        return false
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await checkPurchaseStatus()
        } catch {
            print("Restore failed: \(error)")
        }
    }

    private func checkPurchaseStatus() async {
        guard let result = await Transaction.currentEntitlement(for: productID) else { return }
        if case .verified(let transaction) = result {
            isProPurchased = transaction.revocationDate == nil
        }
    }

    deinit {
        transactionListener?.cancel()
    }
}
