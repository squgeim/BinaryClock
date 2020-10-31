//
//  DateTimeUtils.swift
//  BinaryClock
//
//  Created by Shreya Dahal on 2020-10-31.
//

import Foundation

func getTimeStr(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HHmmss"
    let dateStr = formatter.string(from: date)
    
    return dateStr
}

func getBitsForChar(digit: Int) -> [Bool] {
    switch digit {
    case 0:
        return [false,false,false,false]
    case 1:
        return [false,false,false,true]
    case 2:
        return [false,false,true,false]
    case 3:
        return [false,false,true,true]
    case 4:
        return [false,true,false,false]
    case 5:
        return [false,true,false,true]
    case 6:
        return [false,true,true,false]
    case 7:
        return [false,true,true,true]
    case 8:
        return [true,false,false,false]
    case 9:
        return [true,false,false,true]
    default:
        return [false,false,false,false]
    }
}

func getTimeBitList(date: Date) -> [[Bool]] {
    var bitList: [[Bool]] = []
    
    let time = getTimeStr(date: date)
    
    for char in time {
        let bits = getBitsForChar(digit: Int(String(char)) ?? 0)
        bitList.append(bits);
    }
    
    return bitList
}
