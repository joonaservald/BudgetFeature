import Foundation

public struct BudgetOverviewResponse {
	public let currencyCode: String
	public let totalBudget: Decimal
	public let totalSpent: Decimal
	public let categories: [SpendingCategoryResponse]

	public init(
		currencyCode: String,
		totalBudget: Decimal,
		totalSpent: Decimal,
		categories: [SpendingCategoryResponse]
	) {
		self.currencyCode = currencyCode
		self.totalBudget = totalBudget
		self.totalSpent = totalSpent
		self.categories = categories
	}
}
