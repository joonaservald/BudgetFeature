import Foundation

final class BudgetServiceImpl {
	private let euroCurrencyIdentifier = "EUR"
	private let mockCategoryTypes: [SpendingCategoryType] = [.food, .health, .home, .transport, .other]
}

extension BudgetServiceImpl: BudgetService {

	func fetchMonthlyBudget() async throws -> BudgetOverviewResponse {
		try await Task.sleep(for: .milliseconds(1000))

		// Create mock categories
		let categories = mockCategoryTypes.map { type in
			let budget = Decimal(Double.random(in: 100...800)).rounded(2)
			let spent = Decimal(Double.random(in: 0...NSDecimalNumber(decimal: budget + 100).doubleValue)).rounded(2)
			let transactions = generateRandomTransactions(totalSpent: spent)
			return SpendingCategoryResponse(
				type: type,
				monthlyBudget: budget,
				monthlySpent: spent,
				transactions: transactions
			)
		}

		// Calculate mock total budget and spending
		let totalBudget = categories.reduce(Decimal.zero) { $0 + $1.monthlyBudget }
		let totalSpent = categories.reduce(Decimal.zero) { $0 + $1.monthlySpent }

		return BudgetOverviewResponse(
			currencyCode: Locale.current.currency?.identifier ?? euroCurrencyIdentifier,
			totalBudget: totalBudget,
			totalSpent: totalSpent,
			categories: categories
		)
	}

	private func generateRandomTransactions(totalSpent: Decimal) -> [TransactionResponse] {
		let count = Int.random(in: 0...10)
		let totalDouble = NSDecimalNumber(decimal: totalSpent).doubleValue
		var remaining = totalDouble
		var transactions: [TransactionResponse] = []

		for i in 0..<count {
			let amount: Decimal
			if i == count - 1 {
				amount = Decimal(remaining).rounded(2)
			} else {
				let portion = Double.random(in: 0.05...0.1) * remaining
				amount = Decimal(portion).rounded(2)
				remaining -= NSDecimalNumber(decimal: amount).doubleValue
			}

			let daysAgo = Int.random(in: 0...27)
			let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: .now) ?? .now

			transactions.append(TransactionResponse(
				id: UUID(),
				amount: amount,
				date: date
			))
		}

		return transactions.sorted { $0.date > $1.date }
	}
}
