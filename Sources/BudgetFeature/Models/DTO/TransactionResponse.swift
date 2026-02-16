import Foundation

public struct TransactionResponse: Equatable, Identifiable {
	public let id: UUID
	public let title: String
	public let amount: Decimal
	public let date: Date

	public init(id: UUID, title: String, amount: Decimal, date: Date) {
		self.id = id
		self.title = title
		self.amount = amount
		self.date = date
	}
}
