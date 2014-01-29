//
//  CalculatorBrain.h
//  Calculator_iOS2
//
//  Created by Pavlo Kytsmey on 1/27/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushChar:(char)operand;
- (NSString*) performOperation;
- (BOOL) didWeWriteSthToCCode;
- (void) clearExpr;
@end
