import Foundation

public protocol BudgetService: Sendable {
	func fetchMonthlyBudget() async throws -> BudgetOverviewResponse
}
