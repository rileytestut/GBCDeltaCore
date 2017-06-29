//
//  GBCInputTransformer.swift
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/11/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

import Foundation

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
}

public struct GBCInputTransformer: InputTransforming
{
    public var gameInputType: Input.Type = GBCGameInput.self
    
    public func inputs(for controllerSkin: ControllerSkin, item: ControllerSkin.Item, point: CGPoint) -> [Input]
    {
        var inputs: [Input] = []
        
        for key in item.keys
        {
            switch key
            {
            case "dpad":
                
                let topRect = CGRect(x: item.frame.minX, y: item.frame.minY, width: item.frame.width, height: item.frame.height / 3.0)
                let bottomRect = CGRect(x: item.frame.minX, y: item.frame.maxY - item.frame.height / 3.0, width: item.frame.width, height: item.frame.height / 3.0)
                let leftRect = CGRect(x: item.frame.minX, y: item.frame.minY, width: item.frame.width / 3.0, height: item.frame.height)
                let rightRect = CGRect(x: item.frame.maxX - item.frame.width / 3.0, y: item.frame.minY, width: item.frame.width / 3.0, height: item.frame.height)
                
                if topRect.contains(point)
                {
                    inputs.append(GBCGameInput.up)
                }
                
                if bottomRect.contains(point)
                {
                    inputs.append(GBCGameInput.down)
                }
                
                if leftRect.contains(point)
                {
                    inputs.append(GBCGameInput.left)
                }
                
                if rightRect.contains(point)
                {
                    inputs.append(GBCGameInput.right)
                }
                
            case "a": inputs.append(GBCGameInput.a)
            case "b": inputs.append(GBCGameInput.b)
            case "start": inputs.append(GBCGameInput.start)
            case "select": inputs.append(GBCGameInput.select)
            case "menu": inputs.append(ControllerInput.menu)
            default: break
            }
        }
        
        return inputs
    }
    
    public func inputs(for controller: MFiGameController, input: MFiGameController.Input) -> [Input]
    {
        var inputs: [GBCGameInput] = []
        
        switch input
        {
        case let .dPad(xAxis: xAxis, yAxis: yAxis): inputs.append(contentsOf: self.inputs(forXAxis: xAxis, YAxis: yAxis))
        case let .leftThumbstick(xAxis: xAxis, yAxis: yAxis): inputs.append(contentsOf: self.inputs(forXAxis: xAxis, YAxis: yAxis))
        case .rightThumbstick(xAxis: _, yAxis: _): break
        case .a: inputs.append(.a)
        case .b: inputs.append(.b)
        case .x: inputs.append(.select)
        case .y: inputs.append(.start)
        case .l: break
        case .r: break
        case .leftTrigger: break
        case .rightTrigger: break
        }
        
        return inputs
    }
}

private extension GBCInputTransformer
{
    func inputs(forXAxis xAxis: Float, YAxis yAxis: Float) -> [GBCGameInput]
    {
        var inputs: [GBCGameInput] = []
        
        if xAxis > 0.0
        {
            inputs.append(.right)
        }
        else if xAxis < 0.0
        {
            inputs.append(.left)
        }
        
        if yAxis > 0.0
        {
            inputs.append(.up)
        }
        else if yAxis < 0.0
        {
            inputs.append(.down)
        }
        
        return inputs
    }
}
