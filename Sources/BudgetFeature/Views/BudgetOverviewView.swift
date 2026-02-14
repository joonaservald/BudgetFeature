import SwiftUI

public struct BudgetOverviewView: View {
	@State private var viewModel = BudgetOverviewViewModel()

	public var body: some View {
		ScrollView {
			if let displayData = viewModel.viewData {
				BudgetContentView(data: displayData)
				.animation(.easeInOut, value: displayData)
			}
		}
		.refreshable { await viewModel.loadBudgetData() }
		.task { await viewModel.loadBudgetData() }
		.background(BudgetFeatureColors.background.ignoresSafeArea())
	}
}

struct BudgetContentView: View {
	let data: BudgetOverviewData

	var body: some View {
		VStack(spacing: 20) {
			Text("budget.overview.title", bundle: .module)
				.font(.system(size: 20, weight: .bold, design: .rounded))
				.foregroundColor(BudgetFeatureColors.primaryText)
				.frame(maxWidth: .infinity)
				.multilineTextAlignment(.center)

			BudgetOverviewCardView(data: data)

			ForEach(data.categories) { category in
				SpendingCategoryCardView(
					category: category,
					currencyCode: data.currencyCode
				)
			}
		}
		.padding()
	}
}

#Preview {
	BudgetOverviewView()
}
