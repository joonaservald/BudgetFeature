import Foundation
import Observation

@MainActor
@Observable
final class BudgetOverviewViewModel {

	enum ViewState: Equatable {
		case loading
		case loaded(BudgetOverviewData)
		case error
	}

	public private(set) var viewState: ViewState = .loading

	@ObservationIgnored private let budgetService: BudgetService

	public init(budgetService: BudgetService = BudgetServiceImpl()) {
		self.budgetService = budgetService
	}

	func loadInitialBudgetData() async {
		guard case .loading = viewState else { return }
		await fetchBudgetData()
	}

	func didPullToRefresh() async {
		await fetchBudgetData()
	}

	func didTapRetry() async {
		viewState = .loading
		await fetchBudgetData()
	}

	private func fetchBudgetData() async {
		do {
			let response = try await budgetService.fetchMonthlyBudget()
			viewState = .loaded(response.toOverviewData())
		} catch {
			viewState = .error
		}
	}
}

private extension BudgetOverviewResponse {

	func toOverviewData() -> BudgetOverviewData {
		let progress: Double = totalBudget.isZero
		? 0 : NSDecimalNumber(decimal: totalSpent / totalBudget).doubleValue

		let mappedCategories = categories.map { category in
			SpendingCategoryData(
				id: UUID(),
				type: category.type,
				monthlySpent: category.monthlySpent,
				monthlyBudget: category.monthlyBudget,
				progress: categoryProgress(for: category),
				isOverBudget: category.monthlySpent > category.monthlyBudget,
				transactions: category.transactions
			)
		}

		return BudgetOverviewData(
			totalBudget: totalBudget,
			totalSpent: totalSpent,
			remaining: totalBudget - totalSpent,
			progress: progress,
			isOverBudget: totalSpent > totalBudget,
			currencyCode: currencyCode,
			categories: mappedCategories
		)
	}

	func categoryProgress(for category: SpendingCategoryResponse) -> Double {
		category.monthlyBudget.isZero
		? 0 : NSDecimalNumber(decimal: category.monthlySpent / category.monthlyBudget).doubleValue
	}
}
