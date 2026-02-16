import Foundation
import Observation

@MainActor
@Observable
final class BudgetOverviewViewModel {

	public private(set) var viewData: BudgetOverviewData?

	@ObservationIgnored private let budgetService: BudgetService

	public init(budgetService: BudgetService = BudgetServiceImpl()) {
		self.budgetService = budgetService
	}

	func loadInitialBudgetData() async {
		guard viewData == nil else { return }
		await fetchBudgetData()
	}

	func didPullToRefresh() async {
		await fetchBudgetData()
	}

	private func fetchBudgetData() async {
		guard let data = try? await budgetService.fetchMonthlyBudget() else { return }
		let remainingBudget = data.totalBudget - data.totalSpent
		let progress: Double = data.totalBudget.isZero
		? 0 : NSDecimalNumber(decimal: data.totalSpent / data.totalBudget).doubleValue

		let categories = data.categories.map { [weak self] category in
			return SpendingCategoryData(
				type: category.type,
				monthlySpent: category.monthlySpent,
				monthlyBudget: category.monthlyBudget,
				progress: self?.categoryProgress(for: category) ?? 0,
				isOverBudget: category.monthlySpent > category.monthlyBudget,
				transactions: category.transactions
			)
		}

		viewData = BudgetOverviewData(
			totalBudget: data.totalBudget,
			totalSpent: data.totalSpent,
			remaining: remainingBudget,
			progress: progress,
			isOverBudget: data.totalSpent > data.totalBudget,
			currencyCode: data.currencyCode,
			categories: categories
		)
	}

	private func categoryProgress(for category: SpendingCategoryResponse) -> Double {
		category.monthlyBudget.isZero
		? 0 : NSDecimalNumber(decimal: category.monthlySpent / category.monthlyBudget).doubleValue
	}
}
