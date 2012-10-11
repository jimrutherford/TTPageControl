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

    NSArray *indicators = [[NSArray alloc] initWithObjects:@"search", @"location", [NSNull null], @"home", nil];
    
	// programmatically add the page control
	pageControl = [[TTPageControl alloc] init] ;
	[pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-30.0f)] ;
	[pageControl setNumberOfPages: numberOfPages] ;
	[pageControl setCurrentPage: 0] ;
	[pageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
	[pageControl setDefersCurrentPageDisplay: YES] ;
	[pageControl setIndicatorWidth: 12.0f] ;
    [pageControl setIndicatorHeight: 12.0f] ;
	[pageControl setIndicatorSpace: 15.0f] ;
    [pageControl setIndicatorSelectedColor:[UIColor yellowColor]];
    [pageControl setIndicatorColor: [UIColor redColor]];
    [pageControl setIndicatorImages:indicators];
    [pageControl setDefaultIndicator:@"dot2"];
	[self.view addSubview: pageControl] ;
	
	UIImageView *page;
	CGRect pageFrame ;
    NSString *pageName;
    
	for (int i = 0 ; i < numberOfPages ; i++)
	{
		// figure out the frame of the page to be added
		pageFrame = CGRectMake(i * scrollView.bounds.size.width, 0.0f, scrollView.bounds.size.width, scrollView.bounds.size.height) ;
		
        // get the name of the image we'll use to stub in a view
        // start with some default backgrounds
        if (i%2 == 0)
            pageName = @"bg_1.png";
		else
            pageName = @"bg_2.png";
		
        // if our indicators array has items, lets see if there is a matching background image
        if (indicators != nil)
        {
            if (i < [indicators count])
            {
                // lets see if we have a match and it's not null grab a reference to that background image name
                if ([indicators objectAtIndex:i] != [NSNull null])
                {
                    pageName = [NSString stringWithFormat:@"%@_bg.png", [indicators objectAtIndex:i]];
                }
            }
        }
        
        // set the image
        page = [[UIImageView alloc] initWithImage:[UIImage imageNamed:pageName]];
        
        // set the frame
		page.frame = pageFrame;
		
        // add it to the scroll view
		[scrollView addSubview: page] ;
	}
}

#pragma mark -
#pragma mark DDPageControl event handlers

- (void)pageControlClicked:(id)sender
{
	TTPageControl *pc = (TTPageControl *)sender ;
	
	// we need to scroll to the new index
	[scrollView setContentOffset: CGPointMake(scrollView.bounds.size.width * pc.currentPage, scrollView.contentOffset.y) animated: YES] ;
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
