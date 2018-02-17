//
//  CountryCell.h
//  Countries
//
//  Created by Nikola Popovic on 1/2/18.
//  Copyright © 2018 Nikola Popovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameOfState;
@property (nonatomic, strong) NSString* code;

@end
