//
//  String.swift
//  ExSwift
//
//  Created by pNre on 03/06/14.
//  Copyright (c) 2014 pNre. All rights reserved.
//

import Foundation

public extension String {
    
    /**
        Strips the specified characters from the beginning of self.

        :returns: Stripped string
    */
    func trimmedLeft (characterSet set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()) -> String {
        if let range = rangeOfCharacterFromSet(set.invertedSet) {
            return self[range.startIndex..<endIndex]
        }

        return ""
    }

    @available(*, unavailable, message="use 'trimmedLeft' instead") func ltrimmed (set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()) -> String {
        return trimmedLeft(characterSet: set)
    }

    /**
        Strips the specified characters from the end of self.

        :returns: Stripped string
    */
    func trimmedRight (characterSet set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()) -> String {
        if let range = rangeOfCharacterFromSet(set.invertedSet, options: NSStringCompareOptions.BackwardsSearch) {
            return self[startIndex..<range.endIndex]
        }

        return ""
    }

    @available(*, unavailable, message="use 'trimmedRight' instead") func rtrimmed (set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()) -> String {
        return trimmedRight(characterSet: set)
    }

    /**
        Strips whitespaces from both the beginning and the end of self.

        :returns: Stripped string
    */
    func trimmed () -> String {
        return trimmedLeft().trimmedRight()
    }

    /**
        Parses a string containing a double numerical value into an optional double if the string is a well formed number.

        :returns: A double parsed from the string or nil if it cannot be parsed.
    */
    func toDouble() -> Double? {

        let scanner = NSScanner(string: self)
        var double: Double = 0

        if scanner.scanDouble(&double) {
            return double
        }

        return nil

    }

    /**
       Parses a string containing a float numerical value into an optional float if the string is a well formed number.

       :returns: A float parsed from the string or nil if it cannot be parsed.
    */
    func toFloat() -> Float? {

        let scanner = NSScanner(string: self)
        var float: Float = 0

        if scanner.scanFloat(&float) {
            return float
        }

        return nil

    }

    /**
      Parses a string containing a boolean value (true or false) into an optional Bool if the string is a well formed.

      :returns: A Bool parsed from the string or nil if it cannot be parsed as a boolean.
    */
    func toBool() -> Bool? {
        let text = self.trimmed().lowercaseString
        if text == "true" || text == "false" || text == "yes" || text == "no" {
            return (text as NSString).boolValue
        }

        return nil
    }

    /**
      Parses a string containing a date into an optional NSDate if the string is a well formed.
      The default format is yyyy-MM-dd, but can be overriden.

      :returns: A NSDate parsed from the string or nil if it cannot be parsed as a date.
    */
    func toDate(format : String? = "yyyy-MM-dd") -> NSDate? {
        let text = self.trimmed().lowercaseString
        let dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        if let fmt = format {
            dateFmt.dateFormat = fmt
        }
        return dateFmt.dateFromString(text)
    }

    /**
      Parses a string containing a date and time into an optional NSDate if the string is a well formed.
      The default format is yyyy-MM-dd hh-mm-ss, but can be overriden.

      :returns: A NSDate parsed from the string or nil if it cannot be parsed as a date.
    */
    func toDateTime(format : String? = "yyyy-MM-dd hh-mm-ss") -> NSDate? {
        return toDate(format)
    }

}

/**
    Repeats the string first n times
*/
public func * (first: String, n: Int) -> String {

    var result = String()

    n.times {
        result += first
    }

    return result

}