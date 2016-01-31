//
//  WHContactTableViewCell.m
//  Contacts
//
//  Created by William Hannah on 1/30/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHContactTableViewCell.h"

@interface WHContactTableViewCell()

@property (nonatomic) NSCache *imageCache;
@property (nonatomic) NSOperationQueue *backgroundImageQueue;

@end

@implementation WHContactTableViewCell

- (void)awakeFromNib {
    self.imageCache = [NSCache new];
    self.backgroundImageQueue = [NSOperationQueue new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)hydrateWithContact:(WHContact *)contact {
    self.contactName.text = contact.name;
    self.contactTitle.text = contact.position;
    self.contactPhoto.image = [UIImage imageNamed:@"Placeholder"];
    
    [self loadContactPhoto:contact.imageUrl];
}

- (void)loadContactPhoto:(NSURL *)imageUrl {
    [self.backgroundImageQueue addOperationWithBlock:^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        
        if (image != nil) {
            [self.imageCache setObject:image forKey:imageUrl];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.contactPhoto.image = image;
            }];
        }
    }];
}

@end
