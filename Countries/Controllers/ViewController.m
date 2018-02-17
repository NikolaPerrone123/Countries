//
//  ViewController.m
//  Countries
//
//  Created by Nikola Popovic on 1/2/18.
//  Copyright © 2018 Nikola Popovic. All rights reserved.
//

#import "ViewController.h"
#import "CountryCell.h"
#define cellIdentifier @"CountryCell"

@interface ViewController ()
{
    NSMutableArray* countries;
    BOOL isPresentPopUp;
    BOOL isDeviceSE;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingPopUp;
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
@property (weak, nonatomic) IBOutlet UITableView *tebleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYConstraintsPoPUp;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraintsPoPUp;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintsPoPUp;
@property (weak, nonatomic) IBOutlet UIView *popUp;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Second Commit
    self.centerYConstraintsPoPUp.constant = -500;
    isPresentPopUp = false;
    [self parseUrl];
    [self getData];
    [self checkDevice];
    [self setConstraints];
    [self setTable];
}
- (IBAction)closePupUp:(id)sender {
    [self presentPopUp];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return countries.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CountryCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSMutableDictionary* state = countries[indexPath.row];
    cell.nameOfState.text = state[@"name"];
    cell.code = state[@"code"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* state = countries[indexPath.row];
    NSLog(@"State: %@", state[@"name"]);
    NSLog(@"Code: %@", state[@"code"]);
    //[self presentPopUp];
}

- (void) parseUrl
{
    NSMutableString* query = [[NSMutableString alloc] init];
    NSString* queryString = @"https://data.guidestar.org/v1_1/search/?q=";
    NSString* prefixOrganizationName = @"organization_name:";
    NSString* prefixCity = @"city:";
    NSString* prefixState = @"state:";
    NSString* preficZip = @"zip:";
    NSString* precent = @"*%20AND%20";
    NSString* precentWithoutStar = @"%20AND%20";
    NSString* radius = @"&r=25";
    
    NSString* name = @"Moja organizacija koja radi";
    NSString* city = @"";
    NSString* state = @"";
    NSString* zip = @"";
    
    if (name != nil && name.length != 0)
    {
        query = [[query stringByAppendingString:queryString] mutableCopy];
        query = [[query stringByAppendingString: prefixOrganizationName] mutableCopy];
        NSArray* arrayOfStrings = [name componentsSeparatedByString:@" "];
        for (int i = 0; i < arrayOfStrings.count; i++) {
            query = [[query stringByAppendingString:arrayOfStrings[i]] mutableCopy];
            query = [[query stringByAppendingString:precent] mutableCopy];
        }
    }
    if (city != nil && city.length != 0)
    {
        query = query.length == 0 ? [[query stringByAppendingString:queryString] mutableCopy] : query;
        query = [[query stringByAppendingString: prefixCity] mutableCopy];
        NSArray* arrayOfStrings = [city componentsSeparatedByString:@" "];
        for (int i = 0; i < arrayOfStrings.count; i++) {
            query = [[query stringByAppendingString:arrayOfStrings[i]] mutableCopy];
            query = [[query stringByAppendingString:precent] mutableCopy];
        }
    }
    if (state != nil && state.length != 0)
    {
        query = query.length == 0 ? [[query stringByAppendingString:queryString] mutableCopy] : query;
        query = [[query stringByAppendingString: prefixState] mutableCopy];
        query = [[query stringByAppendingString: state] mutableCopy];
        query = [[query stringByAppendingString: precentWithoutStar] mutableCopy];
    }
    if (zip != nil && zip.length != 0)
    {
        query = query.length == 0 ? [[query stringByAppendingString:queryString] mutableCopy] : query;
        query = [[query stringByAppendingString: preficZip] mutableCopy];
        query = [[query stringByAppendingString: zip] mutableCopy];
        query = [[query stringByAppendingString: precentWithoutStar] mutableCopy];
    }
    
    query = [[query stringByAppendingString: radius] mutableCopy];
    NSLog(@"Query: %@", query);
}

- (void) setTable
{
    UINib* nibCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tebleView registerNib:nibCell forCellReuseIdentifier:cellIdentifier];
    self.tebleView.dataSource = self;
    self.tebleView.delegate = self;
    self.tebleView.estimatedRowHeight = 100;
}

- (void) presentPopUp
{
    if (isPresentPopUp) {
        self.centerYConstraintsPoPUp.constant = -500;
        [self.backgroundButton setHidden:YES];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
        isPresentPopUp = !isPresentPopUp;
    }
    else
    {
        self.centerYConstraintsPoPUp.constant = 0;
        [self.backgroundButton setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
        isPresentPopUp = !isPresentPopUp;
    }
}

- (void) setConstraints
{
    if(isDeviceSE)
    {
        self.widthConstraintsPoPUp.constant = 280;
    }
}

- (void) checkDevice
{
    CGFloat height = self.view.frame.size.height;
    //CGFloat width = self.view.frame.size.width;
    
    if (height < 569)
    {
        isDeviceSE = true;
    }
}

- (void) getData
{
    NSString* queryString = @"https://api.printful.com/countries";
    
    NSURL *url = [NSURL URLWithString: queryString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error == nil) {
                        countries = [[NSMutableArray alloc] init];
                        
                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        NSArray* result = responseDictionary[@"result"];
                        NSLog(@"Count: %lu", (unsigned long)result.count);
                        for (int i = 0; i < result.count; i++) {
                            NSDictionary* country = result[i];
                            NSString* code = country[@"code"];
                            if( [code isEqualToString:@"US"])
                            {
                                NSArray* states = country[@"states"];
                                NSLog(@"States %lu", (unsigned long)states.count);
                                for (int j = 0; j < states.count; j++) {
                                    NSDictionary* state = states[j];
                                    NSString* nameOfState = state[@"name"];
                                    NSString* codeOfState = state[@"code"];
                                    NSMutableDictionary* dictionaryForArray = [[NSMutableDictionary alloc] init];
                                    [dictionaryForArray setObject:nameOfState forKey:@"name"];
                                    [dictionaryForArray setObject:codeOfState forKey:@"code"];
                                    [countries addObject:dictionaryForArray];
                                }
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue(),^{
                            [self.tebleView reloadData];
                        });
                        //NSLog(@"Data: %@", responseDictionary);
                    }
                    else {
                        NSLog(@"Error: %@", error);
                    }
                }] resume];
}

@end
