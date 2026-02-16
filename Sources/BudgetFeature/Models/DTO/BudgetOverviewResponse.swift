import Foundation

struct BudgetOverviewResponse {
	let currencyCode: String
	let totalBudget: Decimal
	let totalSpent: Decimal
	let categories: [SpendingCategoryResponse]
}
