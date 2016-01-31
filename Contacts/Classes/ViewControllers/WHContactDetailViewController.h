//
//  WHContactDetailViewController.h
//  Contacts
//
//  Created by William Hannah on 1/30/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOS-Slide-Menu/SlideNavigationController.h"
#import "WHContact.h"

@interface WHContactDetailViewController : UITableViewController <SlideNavigationControllerDelegate>

@property (nonatomic) WHContact *contact;

@end
