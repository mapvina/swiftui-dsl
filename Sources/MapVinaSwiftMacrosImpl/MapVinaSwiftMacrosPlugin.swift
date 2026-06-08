import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MapVinaSwiftMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MLNStylePropertyMacro.self,
        MLNRawRepresentableStylePropertyMacro.self,
    ]
}
