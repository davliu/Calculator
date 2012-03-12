//
//  CalculatorBrain.h
//  Calculator
//
//  Created by David Liu on 3/4/12.
//  Copyright (c) 2012 HighEagleStudios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;
-(void)clearAll;
@end
