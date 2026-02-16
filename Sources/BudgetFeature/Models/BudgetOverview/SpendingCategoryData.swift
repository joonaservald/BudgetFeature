import Foundation

struct SpendingCategoryData: Equatable, Identifiable {
	
	var id: SpendingCategoryType { type }
	
	let type: SpendingCategoryType
	let monthlySpent: Decimal
	let monthlyBudget: Decimal
	let progress: Double
	let isOverBudget: Bool
	let transactions: [TransactionResponse]
}
