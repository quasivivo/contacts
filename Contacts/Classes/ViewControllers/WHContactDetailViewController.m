//
//  WHContactDetailViewController.m
//  Contacts
//
//  Created by William Hannah on 1/30/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHContactDetailViewController.h"
#import "WHContactTableViewCell.h"
#import "WHSimpleContactDataTableViewCell.h"
#import "WHContactAddressTableViewCell.h"
#import "WHContactAddress.h"

@interface WHContactDetailViewController ()

@end

@implementation WHContactDetailViewController

#pragma mark - View LifeCycle

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.contact.name;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row)
    {
        case 0:
        {
            return [self createPhotoAndNameCell:indexPath];
        }
            break;
        case 4:
        {
            return [self createAddressCell:indexPath];
        }
            break;
        default:
        {
            return [self createDataCell:indexPath];
        }
            break;
    }
}

#pragma mark - UITableView custom cell creation

-(WHContactTableViewCell *)createPhotoAndNameCell:(NSIndexPath *)indexPath {
    static NSString * kContactTableViewCell = @"contactCell";
    
    WHContactTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kContactTableViewCell forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = (WHContactTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kContactTableViewCell];
    }
    
    [cell hydrateWithContact:self.contact];
    
    return cell;
}

-(WHSimpleContactDataTableViewCell *)createDataCell:(NSIndexPath *)indexPath {
    static NSString * kDataTableViewCell = @"dataCell";
    
    WHSimpleContactDataTableViewCell * cell  = [self.tableView dequeueReusableCellWithIdentifier:kDataTableViewCell forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = (WHSimpleContactDataTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDataTableViewCell];
    }
    
    switch (indexPath.row)
    {
        case 1: // position
        {
            cell.dataLabel.text = NSLocalizedString(@"Position", @"Contact's position");
            cell.dataValue.text = self.contact.position;
        }
            break;
        case 2: // company
        {
            cell.dataLabel.text = NSLocalizedString(@"Company", @"Contact's company");
            cell.dataValue.text = [[self.contact.companyDetails objectForKey:@"name"] stringByAppendingString:[NSString stringWithFormat:@" (%@)", [self.contact.companyDetails objectForKey:@"location"] ]];
        }
            break;
        case 3: // phone (first only for now)
        {
            cell.dataLabel.text = NSLocalizedString(@"Phone", @"Contact's phone");
            cell.dataValue.text = [[self.contact.phoneNumbers objectAtIndex:0] objectForKey:@"number"];
        }
            break;
        case 5: // email (first only for now)
        {
            cell.dataLabel.text = NSLocalizedString(@"E-mail", @"Contact's e-mail");
            cell.dataValue.text = [[self.contact.emails objectAtIndex:0] objectForKey:@"email"];
        }
            break;
        case 6: // website
        {
            cell.dataLabel.text = NSLocalizedString(@"Website", @"Contact's website");
            cell.dataValue.text = self.contact.homePage;
        }
            break;
    }
    
    return cell;
}

-(WHContactAddressTableViewCell *)createAddressCell:(NSIndexPath *)indexPath {
    static NSString * kAddressTableViewCell = @"addressCell";
    
    WHContactAddressTableViewCell * cell  = [self.tableView dequeueReusableCellWithIdentifier:kAddressTableViewCell forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = (WHContactAddressTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAddressTableViewCell];
    }
    
    WHContactAddress * address = [self.contact.addresses objectAtIndex:0];
    
    if (address) {
        cell.address12.text = [address.address1 stringByAppendingString:[NSString stringWithFormat:@" %@",address.address2]];
        cell.address3.text = address.address3;
        
        cell.citystatezipcountry.text = [address.city stringByAppendingString:[NSString stringWithFormat:@", %@ %@ %@", address.state, address.zipcode, address.country]];
    }
    
    return cell;
}

#pragma mark - iOS Slide Navigation Controller Delegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

@end
