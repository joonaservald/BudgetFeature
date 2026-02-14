import Foundation

struct BudgetOverviewData: Equatable {
	let totalBudget: Decimal
	let totalSpent: Decimal
	let remaining: Decimal
	let progress: Double
	let isOverBudget: Bool
}
