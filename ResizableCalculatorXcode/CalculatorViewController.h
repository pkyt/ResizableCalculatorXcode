//
//  CalculatorViewController.h
//  ResizableCalculatorXcode
//
//  Created by Pavlo Kytsmey on 1/29/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)buttonPressed:(UIButton *)sender;
- (IBAction)submitPressed:(UIButton *)sender;
- (IBAction)clearPressed:(UIButton *)sender;


@end
