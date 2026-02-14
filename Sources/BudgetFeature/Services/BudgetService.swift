import Foundation

protocol BudgetService: Sendable {
	func fetchMonthlyBudget() async throws -> BudgetOverviewResponse
}
