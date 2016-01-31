//
//  WHLoginViewController.m
//  Contacts
//
//  Created by William Hannah on 1/30/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHLoginViewController.h"
#import "WHAuthManager.h"
#import "WHContactManager.h"
#import "WHCustomAlert+UIViewController.h"

@interface WHLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation WHLoginViewController

#pragma mark - View LifeCycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.email.alpha = 0;
    self.password.alpha = 0;
    self.loginButton.alpha = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.email.alpha = 1;
        self.password.alpha = 1;
        self.loginButton.alpha = 1;
    }];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;

    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - Selectors

- (IBAction)userDidTapLogin:(id)sender {
    [WHAuthManager loginWithEmail:self.email.text password:self.password.text completion:^(BOOL success) {
#warning Implement error message handling in completion block once Auth service is implemented
        if (success) {
            [[WHContactManager sharedManager] loadContactsWithCompletion:^(BOOL success) {
                if (success) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else {
                    [self showAlertWithTitle:NSLocalizedString(@"Contacts could not be retrieved or parsed from http://beta.json-generator.com/api/json/get/4yLVmeGYe.", nil) dismissButtonTitle:NSLocalizedString(@"OK", @"Button label to close generic alert")];
                }
            }];
        }
        else {
            BOOL emailMissing = [self.email.text isEqualToString:@""];
            NSString * alertText = (emailMissing ? NSLocalizedString(@"We need your email address to log you in.", @"Email missing") : NSLocalizedString(@"We need your password to log you in.",@"password missing"));
            
            [self showAlertWithTitle:alertText dismissButtonTitle:NSLocalizedString(@"OK", @"Button label to close generic alert")];
        }
    }];
}

@end
