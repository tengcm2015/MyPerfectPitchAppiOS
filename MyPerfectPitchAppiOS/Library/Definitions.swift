import SpriteKit

enum MusicNodePitch {
	case a, b, c, d, e, f, g
	case asharp, csharp, dsharp, fsharp, gsharp

	func signature(_ sign : KeySignatures) -> String {
		switch sign {
		case .english: switch self {
			case .a:      return "A"
			case .b:      return "B"
			case .c:      return "C"
			case .d:      return "D"
			case .e:      return "E"
			case .f:      return "F"
			case .g:      return "G"
			case .asharp: return "A#"
			case .csharp: return "C#"
			case .dsharp: return "D#"
			case .fsharp: return "F#"
			case .gsharp: return "G#"
		}
		}
	}
}

enum KeySignatures : String {
	case english
}

enum GameDifficulties : String {
	case easy    = "Easy"
	case normal  = "Normal"
	case hard    = "Hard"
	case lunatic = "Lunatic"
}

enum ColorSchemes {
	case dark, light, green, blue, red, purple
}

struct DefaultConstants {
	static let color = SKColor.white
	static let backgroundColor = SKColor.darkGray
}
