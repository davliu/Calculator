//
//  CalculatorViewController.m
//  Calculator
//
//  Created by David Liu on 3/4/12.
//  Copyright (c) 2012 HighEagleStudios. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

-(CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    // NSLog(@"user touched %@", digit);
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

// Update the history label
-(void)appendHistory:(NSString *)value {
    // Update the history
    self.history.text = [self.history.text stringByAppendingString:@" "];
    self.history.text = [self.history.text stringByAppendingString:value];
    if ([self.history.text length] > 50) {
        self.history.text = [self.history.text substringFromIndex:([self.history.text length] - 50)];
    }
}

- (IBAction)decimalPressed:(UIButton *)sender {
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound) {
        self.display.text = [self.display.text stringByAppendingString:[sender currentTitle]];
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    // Update the history
    [self appendHistory:@" "];
    [self appendHistory:self.display.text];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    // Append an equal sign with the operation when an operation is pressed
    [self appendHistory:[sender currentTitle]];
    [self appendHistory:@" ="];
}

- (IBAction)clearText:(UIButton *)sender {
    // Clear the text from the view
    self.display.text = @"";
    self.history.text = @"";
    [self.brain clearAll];
}

// Delete the last character from the display
- (IBAction)backPressed:(UIButton *)sender {
    if ([self.display.text length]) {
        self.display.text = [self.display.text substringToIndex:([self.display.text length] - 1)];
    }
}

// Changes the sign in the display
- (IBAction)changeSignPressed:(UIButton *)sender {
    if ([self.display.text length]) {
        // If there's a negative sign, remove it
        if ([[self.display.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"]) {
            self.display.text = [self.display.text substringFromIndex:1];
        } else {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
    }
}

@end
