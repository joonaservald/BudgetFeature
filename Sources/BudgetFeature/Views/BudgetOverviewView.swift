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
			Text("Monthly overview")
				.font(.system(size: 20, weight: .bold, design: .rounded))
				.foregroundColor(.white)
				.frame(maxWidth: .infinity)
				.multilineTextAlignment(.center)

			BudgetOverviewCardView(data: data)
		}
		.padding()
	}
}

//TODO: Create a solution for asset, color and localization handling
enum AppColors {
	static let background = Color(red: 0.1, green: 0.1, blue: 0.12)
	static let cardBackground = Color(red: 0.15, green: 0.15, blue: 0.18)
}

#Preview {
	BudgetOverviewView()
}
