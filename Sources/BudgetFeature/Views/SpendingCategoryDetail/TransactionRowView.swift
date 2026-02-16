import SwiftUI

struct TransactionRowView: View {
	let transaction: TransactionResponse
	let currencyCode: String

	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 4) {
				Text(transaction.title)
					.font(.system(size: 14, weight: .semibold))
					.foregroundColor(BudgetFeatureColors.primaryText)

				Text(transaction.date, format: .dateTime.day().month().year().hour().minute())
					.font(.system(size: 12))
					.foregroundColor(BudgetFeatureColors.secondaryText)
			}

			Spacer()

			Text((-transaction.amount).formatted(.currency(code: currencyCode)))
				.font(.system(size: 14, weight: .semibold))
				.foregroundColor(BudgetFeatureColors.error)
				.monospacedDigit()
		}
		.padding(.vertical, 8)
	}
}

#Preview {
	TransactionRowView(
		transaction: .init(
			id: UUID(),
			title: "Transaction title",
			amount: 9.99,
			date: .now
		),
		currencyCode: "EUR"
	)
}
