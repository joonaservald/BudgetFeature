import SwiftUI

extension SpendingCategoryType {

	var displayName: LocalizedStringKey {
		switch self {
		case .food: "category.food"
		case .home: "category.home"
		case .transport: "category.transport"
		case .health: "category.health"
		case .other: "category.other"
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
