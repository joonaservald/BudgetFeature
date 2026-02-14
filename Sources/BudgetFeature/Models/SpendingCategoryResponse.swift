import Foundation

struct SpendingCategoryResponse {
	let type: SpendingCategoryType
	let monthlyBudget: Decimal
	let monthlySpent: Decimal
	let transactions: [TransactionResponse]
}
