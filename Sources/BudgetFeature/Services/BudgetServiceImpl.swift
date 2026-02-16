import Foundation

public final class BudgetServiceImpl {
	private let euroCurrencyIdentifier = "EUR"

	public init() {}
}

extension BudgetServiceImpl: BudgetService {

	public func fetchMonthlyBudget() async throws -> BudgetOverviewResponse {
		
		// Mock 1 second timeout as it was requested in the home task description
		try await Task.sleep(for: .milliseconds(1000))
		
		// Create mock categories
		var categories: [SpendingCategoryResponse] = []
		let mockCategoryTypes: [SpendingCategoryType] = [.food, .health, .home, .transport, .other]
		mockCategoryTypes.forEach { [weak self] category in
			guard let self = self else { return }
			let transactions = self.generateRandomTransactions(category: category)
			let categorySpent = transactions.reduce(Decimal.zero) { $0 + $1.amount}
			let categoryBudget = Decimal(Double.random(in: 100...1000))
			categories.append(
				SpendingCategoryResponse(
					type: category,
					monthlyBudget: categoryBudget,
					monthlySpent: categorySpent,
					transactions: transactions
				)
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
	
	private func generateRandomTransactions(category: SpendingCategoryType) -> [TransactionResponse] {
		let transactionCount = Int.random(in: 0...10)
		var transactions: [TransactionResponse] = []
		for _ in 0..<transactionCount {
			let amount = Decimal(Double.random(in: 0.9...100))
			let daysAgo = Int.random(in: 0...15)
			let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: .now) ?? .now
			transactions.append(TransactionResponse(
				id: UUID(),
				title: mockTitle(for: category),
				amount: amount,
				date: date
			))
		}
		return transactions
	}

	private func mockTitle(for type: SpendingCategoryType) -> String {
		switch type {
		case .food: ["Selver", "Rimi", "Delice", "Vapiano", "MySushi", "Guru restoran"].randomElement()!
		case .home: ["Eesti Energia", "IKEA", "Bauhaus", "Telia", "Tele2"].randomElement()!
		case .transport: ["Alexela", "Circle K", "T-Pilet", "Uber", "Bolt", "Tuul", "Elron"].randomElement()!
		case .health: ["MyFitness", "Medicum", "Apotheka", "BENU Apteek"].randomElement()!
		case .other: ["Euronics", "C&C", "Apple", "Didrikson", "Sportland", "North Face", "Piletilevi"].randomElement()!
		}
	}
}
