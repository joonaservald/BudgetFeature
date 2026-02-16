import Foundation

struct SpendingCategoryData: Equatable, Identifiable {
	let id: UUID
	let type: SpendingCategoryType
	let monthlySpent: Decimal
	let monthlyBudget: Decimal
	let progress: Double
	let isOverBudget: Bool
	let transactions: [TransactionResponse]
}
