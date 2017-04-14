//
//  GBCEmulatorConfiguration.swift
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/11/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

import Foundation
import AVFoundation

import DeltaCore

public struct GBCEmulatorConfiguration: EmulatorConfiguration
{
    public let gameSaveFileExtension: String = "sav"
    
    public var audioBufferInfo: AudioManager.BufferInfo {
        let inputFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 2, interleaved: false)
        
        let bufferInfo = AudioManager.BufferInfo(inputFormat: inputFormat, preferredSize: 2064)
        return bufferInfo
    }
    
    public var videoBufferInfo: VideoManager.BufferInfo {
        let bufferInfo = VideoManager.BufferInfo(format: .bgra8, dimensions: CGSize(width: 160, height: 144))
        return bufferInfo
    }
    
    public var supportedCheatFormats: [CheatFormat] {
        let gameGenieFormat = CheatFormat(name: NSLocalizedString("Game Genie", comment: ""), format: "XXX-YYY-ZZZ", type: .gameGenie)
        let gameSharkFormat = CheatFormat(name: NSLocalizedString("GameShark", comment: ""), format: "XXXXXXXX", type: .gameShark)
        return [gameGenieFormat, gameSharkFormat]
    }
    
    public let supportedRates: ClosedRange<Double> = 1...4
}
