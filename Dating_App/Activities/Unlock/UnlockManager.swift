//
//  UnlockManager.swift
//  Dating_App
//
//  Created by Robyn Chau on 19/04/2022.
//

import Combine
import StoreKit
import SwiftUI

class UnlockManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    enum RequestState {
        case loading
        case loaded(SKProduct)
        case failed(Error?)
        case purchased
        case deferred
    }

    private enum StoreError: Error {
        case invalidIdentifiers, missingProduct
    }

    @Published var requestState = RequestState.loading

    var currentUser: User
    private let request: SKProductsRequest
    private var loadedProducts = [SKProduct]()

    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }

    init(currentUser: User) {
        // Store the data controller we were sent.
        self.currentUser = currentUser

        // Prepare to look for our unlock product.
        let productIDs = Set(["com.RobynChau.DatingApp.unlock"])
        request = SKProductsRequest(productIdentifiers: productIDs)

        // This is required because we inherit from NSObject.
        super.init()


        // Start watching the payment queue.
        SKPaymentQueue.default().add(self)

        // Set ourselves up to be notified when the product request completes.
        request.delegate = self

        guard currentUser.fullVersionUnlocked == false else { return }

        // Start the request
        request.start()
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        DispatchQueue.main.async { [self] in
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased, .restored:
                    self.currentUser.fullVersionUnlocked = true
                    print(currentUser)
                    try! FirebaseManager.shared.firestore.collection("users").document(currentUser.uid).setData(from: currentUser, merge: false)
                    self.requestState = .purchased
                    queue.finishTransaction(transaction)

                case .failed:
                    if let product = loadedProducts.first {
                        self.requestState = .loaded(product)
                    } else {
                        self.requestState = .failed(transaction.error)
                    }

                    queue.finishTransaction(transaction)

                case .deferred:
                    self.requestState = .deferred

                default:
                    break
                }
            }
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            // Store the returned products for later, if we need them.
            self.loadedProducts = response.products

            guard let unlock = self.loadedProducts.first else {
                self.requestState = .failed(StoreError.missingProduct)
                return
            }

            if response.invalidProductIdentifiers.isEmpty == false {
                print("ALERT: Received invalid product identifiers: \(response.invalidProductIdentifiers)")
                self.requestState = .failed(StoreError.invalidIdentifiers)
                return
            }

            self.requestState = .loaded(unlock)
        }
    }

    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
