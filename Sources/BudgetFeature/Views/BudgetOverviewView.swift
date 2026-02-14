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
		.preferredColorScheme(.dark)
		.background(AppColors.background.ignoresSafeArea())
	}
}

struct BudgetContentView: View {
	let data: BudgetOverviewData

	var body: some View {
		VStack(spacing: 24) {
			Text("budget.overview.title", bundle: .module)
				.font(.system(size: 20, weight: .bold, design: .rounded))
				.foregroundColor(.white)
				.frame(maxWidth: .infinity)
				.multilineTextAlignment(.center)

			BudgetOverviewCardView(data: data)
		}
		.padding()
	}
}

enum AppColors {
	static let background = Color(red: 0.1, green: 0.1, blue: 0.12)
	static let cardBackground = Color(red: 0.15, green: 0.15, blue: 0.18)
}

#Preview {
	BudgetOverviewView()
}
