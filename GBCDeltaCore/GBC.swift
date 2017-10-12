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

@objc public enum GBCGameInput: Int, Input
{
    case up = 0x40
    case down = 0x80
    case left = 0x20
    case right = 0x10
    case a = 0x01
    case b = 0x02
    case start = 0x08
    case select = 0x04
    
    public var type: InputType {
        return .game(.gbc)
    }
}

public struct GBC: DeltaCoreProtocol
{
    public static let core = GBC()
    
    public let bundleIdentifier = "com.rileytestut.GBCDeltaCore"
    
    public let gameType = GameType.gbc
    
    public let gameInputType: Input.Type = GBCGameInput.self
    
    public let gameSaveFileExtension = "sav"
    
    public let frameDuration = (1.0 / 60.0)
    
    public let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 35112 * 60, channels: 2, interleaved: true)!
    
    public let videoFormat = VideoFormat(pixelFormat: .bgra8, dimensions: CGSize(width: 160, height: 144))
    
    public let supportedCheatFormats: Set<CheatFormat> = {
        let gameGenieFormat = CheatFormat(name: NSLocalizedString("Game Genie", comment: ""), format: "XXX-YYY-ZZZ", type: .gameGenie)
        let gameSharkFormat = CheatFormat(name: NSLocalizedString("GameShark", comment: ""), format: "XXXXXXXX", type: .gameShark)
        return [gameGenieFormat, gameSharkFormat]
    }()
    
    public let emulatorBridge: EmulatorBridging = GBCEmulatorBridge.shared
    
    private init()
    {
    }
}
