//
//  ExSwift.swift
//  ExSwift
//
//  Created by pNre on 07/06/14.
//  Copyright (c) 2014 pNre. All rights reserved.
//

import Foundation

infix operator =~ {}
infix operator |~ {}
infix operator .. {}
infix operator <=> {}

public typealias Ex = ExSwift

public class ExSwift {
    
    /**
        Creates a wrapper that, executes function only after being called n times.
    
        :param: n No. of times the wrapper has to be called before function is invoked
        :param: function Function to wrap
        :returns: Wrapper function
    */
    public class func after <P, T> (n: Int, function: (P...) -> T) -> ((P...) -> T?) {
        
        typealias Function = [P] -> T
    
        var times = n
        
        return {
            (params: P...) -> T? in
            
            //  Workaround for the now illegal (T...) type.
            let adaptedFunction = unsafeBitCast(function, Function.self)
        
            if times-- <= 0 {
                return adaptedFunction(params)
            }
            
            return nil
        }
        
    }
    
    /**
        Creates a wrapper function that invokes function once.
        Repeated calls to the wrapper function will return the value of the first call.
    
        :param: function Function to wrap
        :returns: Wrapper function
    */
    public class func once <P, T> (function: (P...) -> T) -> ((P...) -> T) {
        
        typealias Function = [P] -> T
    
        var returnValue: T? = nil
        
        return { (params: P...) -> T in
            
            if returnValue != nil {
                return returnValue!
            }
            
            let adaptedFunction = unsafeBitCast(function, Function.self)
            returnValue = adaptedFunction(params)
            
            return returnValue!

        }
        
    }
    
    /**
        Creates a wrapper that, when called, invokes function with any additional 
        partial arguments prepended to those provided to the new function.

        :param: function Function to wrap
        :param: parameters Arguments to prepend
        :returns: Wrapper function
    */
    public class func partial <P, T> (function: (P...) -> T, _ parameters: P...) -> ((P...) -> T) {
        typealias Function = [P] -> T

        return { (params: P...) -> T in
            let adaptedFunction = unsafeBitCast(function, Function.self)
            return adaptedFunction(parameters + params)
        }
    }
    
    /**
        Creates a wrapper (without any parameter) that, when called, invokes function
        automatically passing parameters as arguments.
    
        :param: function Function to wrap
        :param: parameters Arguments to pass to function
        :returns: Wrapper function
    */
    public class func bind <P, T> (function: (P...) -> T, _ parameters: P...) -> (Void -> T) {
        typealias Function = [P] -> T

        return { Void -> T in
            let adaptedFunction = unsafeBitCast(function, Function.self)
            return adaptedFunction(parameters)
        }
    }
    
    /**
        Creates a wrapper for function that caches the result of function's invocations.
        
        :param: function Function with one parameter to cache
        :returns: Wrapper function
    */
    public class func cached <P: Hashable, R> (function: P -> R) -> (P -> R) {
        var cache = [P:R]()
        
        return { (param: P) -> R in
            let key = param
            
            if let cachedValue = cache[key] {
                return cachedValue
            } else {
                let value = function(param)
                cache[key] = value
                return value
            }
        }
    }
    
    /**
        Creates a wrapper for function that caches the result of function's invocations.
        
        :param: function Function to cache
        :param: hash Parameters based hashing function that computes the key used to store each result in the cache
        :returns: Wrapper function
    */
    public class func cached <P: Hashable, R> (function: (P...) -> R, hash: ((P...) -> P)) -> ((P...) -> R) {
        typealias Function = [P] -> R
        typealias Hash = [P] -> P
        
        var cache = [P:R]()
        
        return { (params: P...) -> R in
            let adaptedFunction = unsafeBitCast(function, Function.self)
            let adaptedHash = unsafeBitCast(hash, Hash.self)
            
            let key = adaptedHash(params)
            
            if let cachedValue = cache[key] {
                return cachedValue
            } else {
                let value = adaptedFunction(params)
                cache[key] = value
                return value
            }
        }
    }
    
    /**
        Creates a wrapper for function that caches the result of function's invocations.
    
        :param: function Function to cache
        :returns: Wrapper function
    */
    public class func cached <P: Hashable, R> (function: (P...) -> R) -> ((P...) -> R) {
        return cached(function, hash: { (params: P...) -> P in return params[0] })
    }
    
}

func <=> <T: Comparable>(lhs: T, rhs: T) -> Int {
    if lhs < rhs {
        return -1
    } else if lhs > rhs {
        return 1
    } else {
        return 0
    }    
}
