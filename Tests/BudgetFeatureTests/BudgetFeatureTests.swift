import Testing
import Foundation
@testable import BudgetFeature

private final class MockBudgetService: BudgetService, @unchecked Sendable {
	var response: Result<BudgetOverviewResponse, Error> = .failure(MockError.notConfigured)

	func fetchMonthlyBudget() async throws -> BudgetOverviewResponse {
		try response.get()
	}

	enum MockError: Error {
		case notConfigured
		case fetchFailed
	}
}

private func makeResponse(
	currencyCode: String,
	totalBudget: Decimal,
	totalSpent: Decimal,
	categories: [SpendingCategoryResponse] = []
) -> BudgetOverviewResponse {
	BudgetOverviewResponse(
		currencyCode: currencyCode,
		totalBudget: totalBudget,
		totalSpent: totalSpent,
		categories: categories
	)
}

private func makeCategory(
	type: SpendingCategoryType,
	monthlyBudget: Decimal,
	monthlySpent: Decimal,
	transactions: [TransactionResponse]
) -> SpendingCategoryResponse {
	SpendingCategoryResponse(
		type: type,
		monthlyBudget: monthlyBudget,
		monthlySpent: monthlySpent,
		transactions: transactions
	)
}

@Suite("BudgetOverviewViewModel")
struct BudgetOverviewViewModelTests {

	private let service = MockBudgetService()

	@Test("Initial state is loading")
	func initialStateLoading() async {
		let viewModel = await BudgetOverviewViewModel(budgetService: service)
		let state = await viewModel.viewState
		#expect(state == .loading)
	}

	@Test("loadInitialBudgetData sets loaded state on success")
	func loadInitialSuccess() async {
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 1000,
			totalSpent: 500,
			categories: []
		))
		let viewModel = await BudgetOverviewViewModel(budgetService: service)
		await viewModel.loadInitialBudgetData()

		let state = await viewModel.viewState
		guard case .resolved(let data) = state else {
			Issue.record("Expected resolved state, got \(state)")
			return
		}
		#expect(data.totalBudget == 1000)
		#expect(data.totalSpent == 500)
	}

	@Test("loadInitialBudgetData sets error state on failure")
	func loadInitialFailure() async {
		service.response = .failure(MockBudgetService.MockError.fetchFailed)
		let viewModel = await BudgetOverviewViewModel(budgetService: service)
		await viewModel.loadInitialBudgetData()
		let state = await viewModel.viewState
		#expect(state == .error)
	}

	@Test("loadInitialBudgetData does nothing if it is already loaded")
	func loadInitialIgnoredWhenLoaded() async {
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 1000,
			totalSpent: 100
		))
		let viewModel = await BudgetOverviewViewModel(budgetService: service)
		await viewModel.loadInitialBudgetData()
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 1000,
			totalSpent: 999
		))
		await viewModel.loadInitialBudgetData()
		let state = await viewModel.viewState
		guard case .resolved(let data) = state else {
			Issue.record("Expected resolveded state")
			return
		}
		#expect(data.totalSpent == 100)
	}

	@Test("loadInitialBudgetData does nothing when in error state")
	func loadInitialIgnoredWhenError() async {
		service.response = .failure(MockBudgetService.MockError.fetchFailed)
		let viewModel = await BudgetOverviewViewModel(budgetService: service)
		await viewModel.loadInitialBudgetData()
		#expect(await viewModel.viewState == .error)
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 1000,
			totalSpent: 500
		))
		await viewModel.loadInitialBudgetData()

		#expect(await viewModel.viewState == .error)
	}

	@Test("didPullToRefresh successfully refreshes data")
	func pullToRefresh() async {
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 1000,
			totalSpent: 100
		))
		let viewModel = await BudgetOverviewViewModel(budgetService: service)
		await viewModel.loadInitialBudgetData()

		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 1000,
			totalSpent: 750
		))
		await viewModel.didPullToRefresh()

		let state = await viewModel.viewState
		guard case .resolved(let data) = state else {
			Issue.record("Expected resolved data")
			return
		}
		#expect(data.totalSpent == 750)
	}

	@Test("didPullToRefresh sets error in case of failure")
	func pullToRefreshFailure() async {
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 1000,
			totalSpent: 500
		))
		let viewModel = await BudgetOverviewViewModel(budgetService: service)
		await viewModel.loadInitialBudgetData()

		service.response = .failure(MockBudgetService.MockError.fetchFailed)
		await viewModel.didPullToRefresh()

		#expect(await viewModel.viewState == .error)
	}

	@Test("didTapRetry successfully fetches data after error")
	func retryAfterError() async {
		service.response = .failure(MockBudgetService.MockError.fetchFailed)
		let viewModel = await BudgetOverviewViewModel(budgetService: service)
		await viewModel.loadInitialBudgetData()
		#expect(await viewModel.viewState == .error)

		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 1000,
			totalSpent: 300
		))
		await viewModel.didTapRetry()

		let state = await viewModel.viewState
		guard case .resolved(let data) = state else {
			Issue.record("Expected resolveded state")
			return
		}
		#expect(data.totalSpent == 300)
	}

	@Test("didTapRetry stays in error state if fetch fails again")
	func retryFailsAgain() async {
		service.response = .failure(MockBudgetService.MockError.fetchFailed)
		let viewModel = await BudgetOverviewViewModel(budgetService: service)
		await viewModel.loadInitialBudgetData()
		await viewModel.didTapRetry()
		#expect(await viewModel.viewState == .error)
	}

	@Test("Progress is mapped correctly")
	func dataMapping() async {
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 1000,
			totalSpent: 250
		))
		let viewModel = await BudgetOverviewViewModel(budgetService: service)

		await viewModel.loadInitialBudgetData()

		let state = await viewModel.viewState
		guard case .resolved(let data) = state else {
			Issue.record("Expected resolveded state")
			return
		}
		#expect(data.remaining == 750)
		#expect(data.progress == 0.25)
		#expect(data.isOverBudget == false)
		#expect(data.currencyCode == "EUR")
	}

	@Test("Over budget is detected correctly")
	func overBudget() async {
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 500,
			totalSpent: 600
		))
		let viewModel = await BudgetOverviewViewModel(budgetService: service)

		await viewModel.loadInitialBudgetData()

		let state = await viewModel.viewState
		guard case .resolved(let data) = state else {
			Issue.record("Expected resolveded state")
			return
		}
		#expect(data.isOverBudget == true)
		#expect(data.remaining == -100)
		#expect(data.progress == 1.2)
	}

	@Test("Zero spent equals zero progress")
	func zeroBudget() async {
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 100,
			totalSpent: 0
		))
		let viewModel = await BudgetOverviewViewModel(budgetService: service)

		await viewModel.loadInitialBudgetData()

		let state = await viewModel.viewState
		guard case .resolved(let data) = state else {
			Issue.record("Expected resolveded state")
			return
		}
		#expect(data.progress == 0)
	}

	@Test("Cetegories and their data is mapped correctly")
	func categoryMapping() async {
		let transaction = TransactionResponse(
			id: UUID(),
			title: "Transaction",
			amount: 50,
			date: Date()
		)
		let categories = [
			makeCategory(type: .food, monthlyBudget: 200, monthlySpent: 150, transactions: [transaction]),
			makeCategory(type: .transport, monthlyBudget: 100, monthlySpent: 120, transactions: [])
		]
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 1000,
			totalSpent: 500,
			categories: categories
		))
		let viewModel = await BudgetOverviewViewModel(budgetService: service)
		await viewModel.loadInitialBudgetData()

		let state = await viewModel.viewState
		guard case .resolved(let data) = state else {
			Issue.record("Expected resolveded state")
			return
		}
		#expect(data.categories.count == 2)

		let food = data.categories[0]
		#expect(food.type == .food)
		#expect(food.monthlySpent == 150)
		#expect(food.monthlyBudget == 200)
		#expect(food.progress == 0.75)
		#expect(food.isOverBudget == false)
		#expect(food.transactions.count == 1)

		let transport = data.categories[1]
		#expect(transport.type == .transport)
		#expect(transport.isOverBudget == true)
		#expect(transport.progress == 1.2)
	}

	@Test("Category with zero spent has zero progress")
	func zeroCategoryBudget() async {
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 1000,
			totalSpent: 0,
			categories: [
				makeCategory(type: .food, monthlyBudget: 0, monthlySpent: 0, transactions: [])
			]
		))
		let viewModel = await BudgetOverviewViewModel(budgetService: service)

		await viewModel.loadInitialBudgetData()

		let state = await viewModel.viewState
		guard case .resolved(let data) = state else {
			Issue.record("Expected resolveded state")
			return
		}
		#expect(data.categories[0].progress == 0)
	}

	@Test("Categories result in correct total spent")
	func multipleCategoriesWithTransactions() async {
		let foodTransactions = [
			TransactionResponse(id: UUID(), title: "Transaction", amount: 45, date: Date()),
			TransactionResponse(id: UUID(), title: "Transaction", amount: 30, date: Date())
		]
		let transportTransactions = [
			TransactionResponse(id: UUID(), title: "Transaction", amount: 15, date: Date()),
			TransactionResponse(id: UUID(), title: "Transaction", amount: 60, date: Date())
		]
		let categories = [
			makeCategory(type: .food, monthlyBudget: 300, monthlySpent: 75, transactions: foodTransactions),
			makeCategory(type: .transport, monthlyBudget: 200, monthlySpent: 75, transactions: transportTransactions)
		]
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 500,
			totalSpent: 150,
			categories: categories
		))
		let viewModel = await BudgetOverviewViewModel(budgetService: service)
		await viewModel.loadInitialBudgetData()

		let state = await viewModel.viewState
		guard case .resolved(let data) = state else {
			Issue.record("Expected resolved state")
			return
		}
		#expect(data.totalSpent == 150)
		#expect(data.remaining == 350)
	}

	@Test("Transactions result in correct category spent")
	func multipleTransactionsInCategory() async {
		let transactions = [
			TransactionResponse(id: UUID(), title: "Transaction", amount: 5, date: Date()),
			TransactionResponse(id: UUID(), title: "Transaction", amount: 12, date: Date()),
			TransactionResponse(id: UUID(), title: "Transaction", amount: 35, date: Date()),
			TransactionResponse(id: UUID(), title: "Transaction", amount: 8, date: Date())
		]
		let expectedSpent: Decimal = 60
		let categories = [
			makeCategory(type: .food, monthlyBudget: 200, monthlySpent: expectedSpent, transactions: transactions)
		]
		service.response = .success(makeResponse(
			currencyCode: "EUR",
			totalBudget: 200,
			totalSpent: expectedSpent,
			categories: categories
		))
		let viewModel = await BudgetOverviewViewModel(budgetService: service)
		await viewModel.loadInitialBudgetData()

		let state = await viewModel.viewState
		guard case .resolved(let data) = state else {
			Issue.record("Expected resolved state")
			return
		}
		let food = data.categories[0]
		#expect(food.monthlySpent == 60)
	}
}
