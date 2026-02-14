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
		viewData = BudgetOverviewData(
			totalBudget: data.totalBudget,
			totalSpent: data.totalSpent,
			remaining: remainingBudget,
			progress: NSDecimalNumber(decimal: data.totalSpent / data.totalBudget).doubleValue,
			isOverBudget: data.totalSpent > data.totalBudget
		)
	}
}
