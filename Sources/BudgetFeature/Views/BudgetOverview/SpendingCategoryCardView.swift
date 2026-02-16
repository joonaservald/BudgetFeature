import SwiftUI

struct SpendingCategoryCardView: View {
	let category: SpendingCategoryData
	let currencyCode: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			topStack
			progressBar
			bottomStack
		}
		.padding(16)
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(BudgetFeatureColors.cardBackground)
		)
	}
	
	private var topStack: some View {
		HStack {
			Image(systemName: category.type.iconName)
				.font(.system(size: 20))
				.foregroundColor(category.type.accentColor)
				.frame(width: 32)
			
			Text(category.type.displayName, bundle: .module)
				.font(.system(size: 16, weight: .bold))
				.foregroundColor(BudgetFeatureColors.primaryText)
			
			Spacer()
			
			Image(systemName: "chevron.right")
				.font(.system(size: 14, weight: .semibold))
				.foregroundColor(BudgetFeatureColors.secondaryText)
		}
	}
	
	private var progressBar: some View {
		ProgressBarView(progress: category.progress, tint: category.type.accentColor)
	}
	
	private var bottomStack: some View {
		HStack {
			HStack(spacing: 4) {
				Text((category.monthlySpent.formatted(.currency(code: currencyCode))))
					.font(.system(size: 12, weight: .semibold))
					.foregroundColor(
						category.isOverBudget
						? BudgetFeatureColors.error
						: BudgetFeatureColors.primaryText
					)
					.monospacedDigit()
					.contentTransition(.numericText())
				
				Text("title.spent", bundle: .module)
					.font(.system(size: 12, weight: .semibold))
					.foregroundColor(BudgetFeatureColors.secondaryText)
			}
			
			Spacer()
			
			HStack(spacing: 4) {
				Text(category.monthlyBudget.formatted(.currency(code: currencyCode)))
					.font(.system(size: 12, weight: .semibold))
					.foregroundColor(BudgetFeatureColors.primaryText)
					.monospacedDigit()
					.contentTransition(.numericText())
				Text("title.budget", bundle: .module)
					.font(.system(size: 12, weight: .semibold))
					.foregroundColor(BudgetFeatureColors.secondaryText)
			}
		}
	}
}


#Preview {
	SpendingCategoryCardView(
		category: .init(
			id: UUID(),
			type: .food,
			monthlySpent: 123.45,
			monthlyBudget: 678.90,
			progress: 0.18,
			isOverBudget: false,
			transactions: []
		),
		currencyCode: "EUR"
	)
}
