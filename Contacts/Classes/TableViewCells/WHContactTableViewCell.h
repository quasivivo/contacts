//
//  WHContactTableViewCell.h
//  Contacts
//
//  Created by William Hannah on 1/30/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHContact.h"

@interface WHContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactTitle;
@property (weak, nonatomic) IBOutlet UIImageView *contactPhoto;

- (void)hydrateWithContact:(WHContact *)contact;
- (void)loadContactPhoto:(NSURL *)imageUrl;

@end
