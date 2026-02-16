import Foundation

struct TransactionResponse: Equatable, Identifiable {
	let id: UUID
	let title: String
	let amount: Decimal
	let date: Date
}
