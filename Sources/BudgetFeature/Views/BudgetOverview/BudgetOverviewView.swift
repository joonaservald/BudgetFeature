import SwiftUI

public struct BudgetOverviewView: View {
	@State private var viewModel = BudgetOverviewViewModel()

	public init() {}

	public var body: some View {
		NavigationStack {
			Group {
				switch viewModel.viewState {
				case .loading:
					ProgressView()
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.background(BudgetFeatureColors.background)
				case .resolved(let data):
					ScrollView {
						BudgetContentView(data: data)
					}
					.refreshable { await viewModel.didPullToRefresh() }
				case .error:
					BudgetErrorView(onRetry: viewModel.didTapRetry)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.background(BudgetFeatureColors.background)
				}
			}
			.animation(.easeInOut, value: viewModel.viewState)
			.task { await viewModel.loadInitialBudgetData() }
			.background(BudgetFeatureColors.background.ignoresSafeArea())
		}
	}
}

struct BudgetContentView: View {
	let data: BudgetOverviewData

	var body: some View {
		VStack(spacing: 20) {
			Text("budget.overview.title", bundle: .module)
				.font(.system(size: 20, weight: .bold, design: .rounded))
				.foregroundStyle(BudgetFeatureColors.primaryText)
				.frame(maxWidth: .infinity)
				.multilineTextAlignment(.center)

			BudgetOverviewCardView(data: data)

			ForEach(data.categories) { category in
				NavigationLink {
					SpendingCategoryDetailView(
						category: category,
						currencyCode: data.currencyCode
					)
				} label: {
					SpendingCategoryCardView(
						category: category,
						currencyCode: data.currencyCode
					)
				}
				.buttonStyle(.plain)
			}
		}
		.padding()
	}
}

#Preview {
	BudgetOverviewView()
}
