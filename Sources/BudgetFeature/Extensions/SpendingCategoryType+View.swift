import SwiftUI

extension SpendingCategoryType {

	var displayName: LocalizedStringResource {
		switch self {
		case .food: .categoryFood
		case .home: .categoryHome
		case .transport: .categoryTransport
		case .health: .categoryHealth
		case .other: .categoryOther
		}
	}

	var iconName: String {
		switch self {
		case .food: "fork.knife"
		case .home: "house.fill"
		case .transport: "car.fill"
		case .health: "heart.fill"
		case .other: "square.grid.2x2.fill"
		}
	}

	var accentColor: Color {
		switch self {
		case .food: BudgetFeatureColors.categoryFood
		case .home: BudgetFeatureColors.categoryHome
		case .transport: BudgetFeatureColors.categoryTransport
		case .health: BudgetFeatureColors.categoryHealth
		case .other: BudgetFeatureColors.categoryOther
		}
	}
}
