import Foundation

final class BudgetServiceImpl {
	private let euroCurrencyIdentifier = "EUR"
}

extension BudgetServiceImpl: BudgetService {

	func fetchMonthlyBudget() async throws -> BudgetOverviewResponse {
		// Mock data with a mock fetch timer
		try await Task.sleep(for: .milliseconds(800))
		let totalBudget = Decimal(Double.random(in: 500...3000)).rounded(2)
		let totalSpent = Decimal(Double.random(in: 0...NSDecimalNumber(decimal: totalBudget + 500).doubleValue)).rounded(2)
		return BudgetOverviewResponse(
			currencyCode: Locale.current.currency?.identifier ?? euroCurrencyIdentifier,
			totalBudget: totalBudget,
			totalSpent: totalSpent
		)
	}
}
