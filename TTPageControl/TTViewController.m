//
//  TTViewController.m
//  TTPageControl
//
//  Created by James Rutherford on 2012-10-10.
//  Copyright (c) 2012 Braxio Interactive. All rights reserved.
//

#import "TTViewController.h"
#import "TTPageControl.h"

@interface TTViewController ()

@end

@implementation TTViewController

@synthesize scrollView ;

- (void)viewDidLoad
{
    [super viewDidLoad];
	int numberOfPages = 10 ;
	
	// define the scroll view content size and enable paging
	[scrollView setPagingEnabled: YES] ;
	[scrollView setContentSize: CGSizeMake(scrollView.bounds.size.width * numberOfPages, scrollView.bounds.size.height)] ;

    NSArray *indicators = [[NSArray alloc] initWithObjects:@"search", [NSNull null], @"home", nil];
    
	// programmatically add the page control
	pageControl = [[TTPageControl alloc] init] ;
	[pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-30.0f)] ;
	[pageControl setNumberOfPages: numberOfPages] ;
	[pageControl setCurrentPage: 0] ;
	[pageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
	[pageControl setDefersCurrentPageDisplay: YES] ;
	[pageControl setIndicatorWidth: 14.0f] ;
    [pageControl setIndicatorHeight: 14.0f] ;
	[pageControl setIndicatorSpace: 15.0f] ;
    [pageControl setIndicatorImages:indicators];
    //[pageControl setDefaultIndicator:@"dot"];
	[self.view addSubview: pageControl] ;
	
	UILabel *pageLabel ;
	CGRect pageFrame ;
	UIColor *color ;
	char aLetter ;
	for (int i = 0 ; i < numberOfPages ; i++)
	{
		// determine the frame of the current page
		pageFrame = CGRectMake(i * scrollView.bounds.size.width, 0.0f, scrollView.bounds.size.width, scrollView.bounds.size.height) ;
		
		// create a page as a simple UILabel
		pageLabel = [[UILabel alloc] initWithFrame: pageFrame] ;
		
		// add it to the scroll view
		[scrollView addSubview: pageLabel] ;
		
		// determine and set its (random) background color
		if (i%2 == 0)
            color = [UIColor colorWithRed: 0.4f green: 0.4f blue: 0.4f alpha: 1.0f] ;
		else
            color = [UIColor colorWithRed: 0.5f green: 0.5f blue: 0.5f alpha: 1.0f] ;
            
        [pageLabel setBackgroundColor: color] ;
		
		// set some label properties
		[pageLabel setFont: [UIFont boldSystemFontOfSize: 200.0f]] ;
		[pageLabel setTextAlignment: NSTextAlignmentCenter] ;
		[pageLabel setTextColor: [UIColor darkTextColor]] ;
		
		// set the label's text as the letter corresponding to the current page index
		aLetter = (char)((i+65)-(i/26)*26) ;	// the capitalized alphabet characters are in the range 65-90
		[pageLabel setText: [NSString stringWithFormat: @"%c", aLetter]] ;
	}

}

#pragma mark -
#pragma mark TTPageControl triggered actions

- (void)pageControlClicked:(id)sender
{
	TTPageControl *thePageControl = (TTPageControl *)sender ;
	
	// we need to scroll to the new index
	[scrollView setContentOffset: CGPointMake(scrollView.bounds.size.width * thePageControl.currentPage, scrollView.contentOffset.y) animated: YES] ;
}


#pragma mark -
#pragma mark UIScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	CGFloat pageWidth = scrollView.bounds.size.width ;
    float fractionalPage = scrollView.contentOffset.x / pageWidth ;
	NSInteger nearestNumber = lround(fractionalPage) ;
	
	if (pageControl.currentPage != nearestNumber)
	{
		pageControl.currentPage = nearestNumber ;
		
		// if we are dragging, we want to update the page control directly during the drag
		if (scrollView.dragging)
			[pageControl updateCurrentPageDisplay] ;
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
	// if we are animating (triggered by clicking on the page control), we update the page control
	[pageControl updateCurrentPageDisplay] ;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
