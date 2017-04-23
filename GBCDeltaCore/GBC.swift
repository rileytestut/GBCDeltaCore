//
//  GBC.swift
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/11/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

import Foundation
import AVFoundation

import DeltaCore

public extension GameType
{
    public static let gbc = GameType("com.rileytestut.delta.game.gbc")
}

public struct GBC: DeltaCoreProtocol
{
    public static let core = GBC()
    
    public let gameType = GameType.gbc
    
    public let bundleIdentifier: String = "com.rileytestut.GBCDeltaCore"
    
    public let gameSaveFileExtension: String = "sav"
    
    public let frameDuration = (1.0 / 59.7275)
    
    public let supportedRates: ClosedRange<Double> = 1...4
    
    public let supportedCheatFormats: [CheatFormat] = {
        let gameGenieFormat = CheatFormat(name: NSLocalizedString("Game Genie", comment: ""), format: "XXX-YYY-ZZZ", type: .gameGenie)
        let gameSharkFormat = CheatFormat(name: NSLocalizedString("GameShark", comment: ""), format: "XXXXXXXX", type: .gameShark)
        return [gameGenieFormat, gameSharkFormat]
    }()
    
    public let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 35112 * 59.7275, channels: 2, interleaved: true)
    
    public let videoFormat = VideoFormat(pixelFormat: .bgra8, dimensions: CGSize(width: 160, height: 144))
    
    public let emulatorBridge: EmulatorBridging = GBCEmulatorBridge.shared
    
    public let inputTransformer: InputTransforming = GBCInputTransformer()
    
    private init()
    {
    }
    
}
