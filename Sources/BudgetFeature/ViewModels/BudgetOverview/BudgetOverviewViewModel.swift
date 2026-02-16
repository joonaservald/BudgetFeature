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

	func loadBudgetData() async {
		guard let data = try? await budgetService.fetchMonthlyBudget() else { return }
		let remainingBudget = data.totalBudget - data.totalSpent
		let progress: Double = data.totalBudget.isZero
		? 0 : NSDecimalNumber(decimal: data.totalSpent / data.totalBudget).doubleValue

		let categories = data.categories.map { category in
			let categoryProgress: Double = category.monthlyBudget.isZero
			? 0 : NSDecimalNumber(decimal: category.monthlySpent / category.monthlyBudget).doubleValue
			
			return SpendingCategoryData(
				type: category.type,
				monthlySpent: category.monthlySpent,
				monthlyBudget: category.monthlyBudget,
				progress: categoryProgress,
				isOverBudget: category.monthlySpent > category.monthlyBudget
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
}
