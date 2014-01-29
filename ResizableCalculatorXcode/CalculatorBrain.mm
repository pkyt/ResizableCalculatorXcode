//
//  CalculatorBrain.m
//  Calculator_iOS2
//
//  Created by Pavlo Kytsmey on 1/27/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import "CalculatorBrain.h"
#import "CalculatorCpp.h"

@interface CalculatorBrain()
@property class CalculatorCpp * cpp;
@property bool _exist; // if cpp was already created
@property bool didWehaveSthWrittenToCpp; // does sth is saved in cpp class
@end

@implementation CalculatorBrain

@synthesize didWehaveSthWrittenToCpp;
@synthesize _exist;
@synthesize cpp = _cpp;

- (BOOL) didWeWriteSthToCCode{
    return didWehaveSthWrittenToCpp;
}

- (void) pushChar:(char)operand{
    if (!_exist){
        _exist = true;
        _cpp = new CalculatorCpp();
    }
    _cpp->addChar(operand);
    didWehaveSthWrittenToCpp = YES;
    
}
- (NSString*) performOperation{
    
    if(!_exist){
        didWehaveSthWrittenToCpp = NO;
        return @"0";
    }
    double result = _cpp->calculate();
    if (_cpp->err){
        didWehaveSthWrittenToCpp = NO;
        NSString * errorMessage = [NSString stringWithCString:_cpp->errorMessage.c_str()
                                                     encoding:[NSString defaultCStringEncoding]];
        return errorMessage;
    }
    return [NSString stringWithFormat:@"%f", result];
    return 0;
}

- (void) clearExpr{
    if (_exist) {
        _cpp->err = true; // it will automatically clear everything
        _cpp->errorMessage = "0"; // so that on display we get 0 not "ERROR"
    }
}

@end

