import SpriteKit

public enum MusicNodePitch : String {
	case a, b, c, d, e, f, g
	case asharp = "as", csharp = "cs", dsharp = "ds"
	case fsharp = "fs", gsharp = "gs"
}

public enum GameDifficulties : String {
	case easy    = "Easy"
	case normal  = "Normal"
	case hard    = "Hard"
	case lunatic = "Lunatic"
}

public enum ColorSchemes {
	case dark, light, green, blue, red, purple
}

public struct DefaultConstants {
	static let color = SKColor.white
	static let backgroundColor = SKColor.darkGray
}
