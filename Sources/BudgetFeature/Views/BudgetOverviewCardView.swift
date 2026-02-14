import SwiftUI

struct BudgetOverviewCardView: View {
	let data: BudgetOverviewData
	
	var body: some View {
		HStack(alignment: .center, spacing: 24) {
			BudgetRemainingCircleView(
				remaining: data.remaining,
				progress: data.progress,
				isOverBudget: data.isOverBudget,
				currencyCode: data.currencyCode
			)
			.frame(maxWidth: .infinity)
			
			VStack(alignment: .leading, spacing: 30) {
				statRow(
					icon: "chart.bar.fill",
					label: "title.budget",
					value: data.totalBudget.formatted(.currency(code: data.currencyCode)),
					iconColor: BudgetFeatureColors.secondaryText
				)
				
				statRow(
					icon: "flame.fill",
					label: "title.spent",
					value: data.totalSpent.formatted(.currency(code: data.currencyCode)),
					iconColor: BudgetFeatureColors.accent
				)
			}
		}
		.padding(.horizontal, 24)
		.padding(.vertical, 36)
		.background(
			RoundedRectangle(cornerRadius: 20)
				.fill(BudgetFeatureColors.cardBackground)
		)
	}
	
	private func statRow(
		icon: String,
		label: LocalizedStringKey,
		value: String,
		iconColor: Color
	) -> some View {
		HStack(spacing: 12) {
			Image(systemName: icon)
				.font(.system(size: 24))
				.foregroundColor(iconColor)
				.frame(width: 36)
			
			VStack(alignment: .trailing, spacing: 2) {
				Text(label, bundle: .module)
					.font(.system(size: 10, weight: .semibold))
					.foregroundColor(BudgetFeatureColors.secondaryText)
					.tracking(0.5)
					.lineLimit(1)
					.allowsTightening(true)
					.minimumScaleFactor(0.8)
					.frame(width: 85, alignment: .leading)
					.fixedSize(horizontal: true, vertical: false)
				
				Text(value)
					.font(.system(size: 16, weight: .semibold))
					.monospacedDigit()
					.foregroundColor(BudgetFeatureColors.primaryText)
					.contentTransition(.numericText())
					.lineLimit(1)
					.allowsTightening(true)
					.minimumScaleFactor(0.8)
					.frame(width: 85, alignment: .leading)
					.fixedSize(horizontal: true, vertical: false)
			}
			
		}
	}
}
