//
//  GBC.swift
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/11/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

import Foundation

public extension GameType
{
    public static let gbc = GameType("com.rileytestut.delta.game.gbc")
}

public struct GBC: DeltaCoreProtocol
{
    public static let core = GBC()
    
    public let bundleIdentifier: String = "com.rileytestut.GBCDeltaCore"
    
    public let supportedGameTypes: Set<GameType> = [.gbc]
    
    public let emulatorBridge: EmulatorBridging = GBCEmulatorBridge.shared
    
    public let emulatorConfiguration: EmulatorConfiguration = GBCEmulatorConfiguration()
    
    public let inputTransformer: InputTransforming = GBCInputTransformer()
    
    private init()
    {
    }
    
}
