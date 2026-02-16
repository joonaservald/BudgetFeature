import Foundation

public struct SpendingCategoryResponse {
	public let type: SpendingCategoryType
	public let monthlyBudget: Decimal
	public let monthlySpent: Decimal
	public let transactions: [TransactionResponse]

	public init(
		type: SpendingCategoryType,
		monthlyBudget: Decimal,
		monthlySpent: Decimal,
		transactions: [TransactionResponse]
	) {
		self.type = type
		self.monthlyBudget = monthlyBudget
		self.monthlySpent = monthlySpent
		self.transactions = transactions
	}
}
