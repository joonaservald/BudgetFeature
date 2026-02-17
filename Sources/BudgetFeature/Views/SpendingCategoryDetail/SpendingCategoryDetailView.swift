import SwiftUI

struct SpendingCategoryDetailView: View {
	let category: SpendingCategoryData
	let currencyCode: String

	var body: some View {
		ScrollView {
			VStack(spacing: 16) {
				SpendingCategoryHeaderView(
					category: category,
					currencyCode: currencyCode
				)

				transactionsCard
			}
			.padding()
		}
		.background(BudgetFeatureColors.background.ignoresSafeArea())
		.navigationTitle(Text(category.type.displayName))
		.navigationBarTitleDisplayMode(.inline)
	}

	private var transactionsCard: some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack {
				Text(.categoryDetailTransactions)
					.font(.system(size: 16, weight: .bold))
					.foregroundStyle(BudgetFeatureColors.primaryText)

				Spacer()

				Text((-category.monthlySpent).formatted(.currency(code: currencyCode)))
					.font(.system(size: 16, weight: .bold))
					.foregroundStyle(BudgetFeatureColors.primaryText)
					.monospacedDigit()
			}
			.padding(.bottom, 12)

			if category.transactions.isEmpty {
				Text(.categoryDetailNoTransactions)
					.font(.system(size: 14))
					.foregroundStyle(BudgetFeatureColors.secondaryText)
					.frame(maxWidth: .infinity)
					.padding(.vertical, 20)
			} else {
				LazyVStack(spacing: 0) {
					ForEach(category.transactions) { transaction in
						TransactionRowView(
							transaction: transaction,
							currencyCode: currencyCode
						)
						if transaction.id != category.transactions.last?.id {
							Divider()
						}
					}
				}
			}
		}
		.padding(16)
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(BudgetFeatureColors.cardBackground)
		)
	}
}

#Preview {
	NavigationStack {
		SpendingCategoryDetailView(
			category: .init(
				id: UUID(),
				type: .health,
				monthlySpent: 333.33,
				monthlyBudget: 1000.00,
				progress: 0.33,
				isOverBudget: false,
				transactions: []
			),
			currencyCode: "EUR"
		)
	}
}
