import SpriteKit

enum MusicNodePitch : String {
	case a, b, c, d, e, f, g
	case asharp = "as", csharp = "cs", dsharp = "ds"
	case fsharp = "fs", gsharp = "gs"
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
