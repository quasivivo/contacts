//
//  WHContactManager.m
//  Contacts
//
//  Created by William Hannah on 1/30/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHContactManager.h"
#import "WHContact.h"
#import "WHContactAddress.h"

static WHContactManager *sContactManager = nil;

@interface WHContactManager()

@property (nonatomic, readwrite) NSMutableArray * contacts;

@end

@implementation WHContactManager

+ (WHContactManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sContactManager = [WHContactManager new];
    });
    return sContactManager;
}

-(instancetype)init {
    if (self = [super init]) {
        self.contacts = [@[] mutableCopy];
    }
    return self;
}

#pragma mark - Contact Retrieval

-(void)loadContactsWithCompletion:(void (^)(BOOL success))completion
{
    NSURL *url = [NSURL URLWithString:@"http://beta.json-generator.com/api/json/get/4yLVmeGYe"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            NSError * error = nil;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
            if (!jsonArray) {
                completion(NO);
            } else {
                [self processContactsFromJSONArray:jsonArray];
                completion(YES);
            }
        } else {
            completion(NO);
        }
    }];
}

-(void)processContactsFromJSONArray:(NSArray *)jsonArray {
#warning Assume we're not updating existing records, just reloading
    
    self.contacts = [@[] mutableCopy];
    
    for(NSDictionary *item in jsonArray) {
        WHContact * contact = [WHContact new];
        
        contact.name = [item objectForKey:@"name"];
        contact.position = [item objectForKey:@"position"];
        contact.age = (long)[item objectForKey:@"age"];
        contact.homePage = [item objectForKey:@"homePage"];
        contact.imageUrl = [NSURL URLWithString:[item objectForKey:@"imageUrl"]];
        contact.phoneNumbers = [item objectForKey:@"phone"];
        contact.emails = [item objectForKey:@"emails"];
        contact.companyDetails = [item objectForKey:@"companyDetails"];
        
        NSMutableArray * addresses = [@[] mutableCopy];
        
        for (NSDictionary *address in [item objectForKey:@"address"])
        {
            WHContactAddress * a = [WHContactAddress new];
            a.address1 = [address objectForKey:@"address1"];
            a.address2 = [address objectForKey:@"address2"];
            a.address3 = [address objectForKey:@"address3"];
            a.city = [address objectForKey:@"city"];
            a.state = [address objectForKey:@"state"];
            a.zipcode = [address objectForKey:@"zipcode"];
            a.country = [address objectForKey:@"country"];
            
            [addresses addObject:a];
        }
        
        contact.addresses = addresses;
        
        [self.contacts addObject:contact];
    }
}

@end
