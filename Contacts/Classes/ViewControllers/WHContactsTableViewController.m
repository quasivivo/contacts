//
//  WHContactsTableViewController.m
//  Contacts
//
//  Created by William Hannah on 1/30/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHContactsTableViewController.h"
#import "WHContactDetailViewController.h"
#import "WHContactTableViewCell.h"
#import "WHContactManager.h"
#import "WHAuthManager.h"
#import "WHContact.h"

@interface WHContactsTableViewController ()

@property (nonatomic) BOOL isSearching;
@property (nonatomic) NSMutableArray * filteredContacts;

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation WHContactsTableViewController

#pragma mark - View LifeCycle

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.scopeButtonTitles = [NSArray array];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    self.searchController.searchBar.delegate = self;
    
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.searchController.searchBar sizeToFit];
    self.filteredContacts = [[[WHContactManager sharedManager] contacts] mutableCopy];
    [self searchContacts:self.searchController.searchBar.text];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [WHAuthManager checkNeedsLogin];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredContacts.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * kContactTableViewCell = @"contactCell";
    
    WHContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactTableViewCell forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = (WHContactTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kContactTableViewCell];
    }
    
    [cell hydrateWithContact:[self.filteredContacts objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Searchbar filtering

-(void)searchContacts:(NSString *)search {
    if (![search isEqualToString:@""]) {
        search = [search lowercaseString];
        
        self.filteredContacts = [@[] mutableCopy];
        
        for (WHContact * contact in [[WHContactManager sharedManager] contacts]) {
            BOOL searchMatchesName = [[contact.name lowercaseString] rangeOfString:search].location != NSNotFound;
            BOOL searchMatchesTitle = [[contact.position lowercaseString] rangeOfString:search].location != NSNotFound;
            if (searchMatchesName || searchMatchesTitle) {
                [self.filteredContacts addObject:contact];
            }
        }
    }
    else {
        [self.tableView reloadData];
    }
}

#pragma mark - UISearchResultsUploading

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self searchContacts:searchController.searchBar.text];
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.isSearching = [searchText length] != 0;
    if(self.isSearching) {
        [self searchContacts:searchBar.text];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isSearching = NO;
    self.filteredContacts = [[[WHContactManager sharedManager] contacts] mutableCopy];    
}


#pragma mark - iOS Slide Navigation Controller Delegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetailSegue"])
    {
        WHContactDetailViewController *details = (WHContactDetailViewController*)segue.destinationViewController;
        
        WHContact * selectedContact = [self.filteredContacts objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        details.contact = selectedContact;
    }
}

@end
