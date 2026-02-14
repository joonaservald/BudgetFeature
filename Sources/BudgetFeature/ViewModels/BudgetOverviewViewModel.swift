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
		viewData = BudgetOverviewData(
			totalBudget: data.totalBudget,
			totalSpent: data.totalSpent,
			remaining: remainingBudget,
			progress: progress,
			isOverBudget: data.totalSpent > data.totalBudget,
			currencyCode: data.currencyCode
		)
	}
}
