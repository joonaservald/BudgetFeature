import SwiftUI

struct SpendingCategoryHeaderView: View {
	let category: SpendingCategoryData
	let currencyCode: String

	var body: some View {
		HStack(spacing: 16) {
			categoryIcon
			budgetSummaryCard
		}
		.fixedSize(horizontal: false, vertical: true)
	}

	private var categoryIcon: some View {
		Image(systemName: category.type.iconName)
			.font(.system(size: 20))
			.foregroundColor(category.type.accentColor)
			.frame(width: 60)
			.frame(maxHeight: .infinity)
			.background(
				RoundedRectangle(cornerRadius: 16)
					.fill(BudgetFeatureColors.cardBackground)
			)
	}

	private var budgetSummaryCard: some View {
		VStack(alignment: .leading, spacing: 12) {
			progressBar

			HStack {
				HStack(spacing: 4) {
					Text(category.monthlySpent.formatted(.currency(code: currencyCode)))
						.font(.system(size: 12, weight: .semibold))
						.foregroundColor(
							category.isOverBudget
							? BudgetFeatureColors.error
							: BudgetFeatureColors.primaryText
						)
						.monospacedDigit()

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

					Text("title.budget", bundle: .module)
						.font(.system(size: 12, weight: .semibold))
						.foregroundColor(BudgetFeatureColors.secondaryText)
				}
			}
		}
		.padding(16)
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(BudgetFeatureColors.cardBackground)
		)
	}

	private var progressBar: some View {
		ProgressBarView(progress: category.progress, tint: category.type.accentColor)
	}
}

#Preview {
	SpendingCategoryHeaderView(
		category: .init(
			id: UUID(),
			type: .food,
			monthlySpent: 234.56,
			monthlyBudget: 400.00,
			progress: 0.59,
			isOverBudget: false,
			transactions: []
		),
		currencyCode: "EUR"
	)
}
