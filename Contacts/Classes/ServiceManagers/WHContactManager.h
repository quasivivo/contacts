//
//  WHContactManager.h
//  Contacts
//
//  Created by William Hannah on 1/30/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHContactManager : NSObject

@property (nonatomic, readonly) NSMutableArray * contacts;

+ (WHContactManager *)sharedManager;

-(void)loadContactsWithCompletion:(void (^)(BOOL success))completion;

@end
