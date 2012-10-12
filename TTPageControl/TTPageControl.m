//
//  TTPageControl.m
//  TTPageControl
//
//  Created by James Rutherford on 2012-10-10.
//  Copyright (c) 2012 Taptonics. All rights reserved.
//

#import "TTPageControl.h"


#define kItemWidth      4.0f
#define kItemHeight     4.0f
#define kItemSpace		12.0f
#define kDefaultIndicator @"dot"
#define kDefaultIndicatorColor [UIColor blackColor]
#define kDefaultIndicatorSelectedColor [UIColor colorWithRed:114/255.0f green:198/255.0f blue:255/255.0f alpha:1.0f]

@implementation TTPageControl

@synthesize numberOfPages ;
@synthesize currentPage ;
@synthesize hidesForSinglePage ;
@synthesize defersCurrentPageDisplay ;

@synthesize indicatorWidth;
@synthesize indicatorHeight;
@synthesize indicatorSpace;
@synthesize indicatorImages;
@synthesize defaultIndicator;
@synthesize indicatorColor;
@synthesize indicatorSelectedColor;

NSMutableArray *imageViews;
NSMutableArray *imageSelectedViews;

#pragma mark -
#pragma mark Initializers

- (id)init
{
	self = [self initWithFrame: CGRectZero] ;
	return self ;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame: CGRectZero]))
	{
		self.backgroundColor = [UIColor clearColor] ;
	}
	return self ;
}


#pragma mark -
#pragma mark drawRect

- (void)drawRect:(CGRect)rect
{
    
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
	// get the indicator metrics if it has been set or use the default one
	CGFloat width = (indicatorWidth > 0) ? indicatorWidth : kItemWidth ;
    CGFloat height = (indicatorHeight > 0) ? indicatorHeight : kItemHeight ;
	CGFloat space = (indicatorSpace > 0) ? indicatorSpace : kItemSpace ;
    
    
	// geometry
	CGRect currentBounds = self.bounds ;
	CGFloat totalWidth = self.numberOfPages * width + MAX(0, self.numberOfPages - 1) * space ;
	CGFloat x = CGRectGetMidX(currentBounds) - totalWidth / 2 ;
	CGFloat y = CGRectGetMidY(currentBounds) - height / 2 ;
	
	// actually draw the indicators
	for (int i = 0 ; i < numberOfPages ; i++)
	{
		CGRect indicatorRect = CGRectMake(x, y, width, height) ;
        
        UIImageView *indicatorView;
        
        if (currentPage == i)
        {
            indicatorView = [imageSelectedViews objectAtIndex:i];
        }
        else
        {
            indicatorView = [imageViews objectAtIndex:i];
        }
        
        indicatorView.frame = indicatorRect;
        
        [self addSubview:indicatorView];
        
		x += width + space ;
	}
}

- (void) initImageViews
{
    imageViews = [[NSMutableArray alloc] init];
    imageSelectedViews = [[NSMutableArray alloc] init];
    
    UIColor * color = (indicatorColor != nil) ? indicatorColor : kDefaultIndicatorColor;
    UIColor * selectedColor = (indicatorSelectedColor != nil) ? indicatorSelectedColor : kDefaultIndicatorSelectedColor;
    
    // actually draw the indicators
	for (int i = 0 ; i < numberOfPages ; i++)
	{
        
        // start our indicator image with the default image name
        NSString *indicatorImage = (defaultIndicator.length > 0) ? defaultIndicator : kDefaultIndicator;
        
        // look are our indicatorImages array and see if we need a custom icon at this spot
        if (indicatorImages != nil)
        {
            if (i < [indicatorImages count])
            {
                // lets see if we have a match and it's not null
                if ([indicatorImages objectAtIndex:i] != [NSNull null])
                {
                    indicatorImage = [indicatorImages objectAtIndex:i];
                }
            }
        }
        
        UIImage *indicator = [UIImage imageNamed:[NSString stringWithFormat:@"%@@2x.png", indicatorImage]];
        
        UIImageView *indicatorView = [[UIImageView alloc] initWithImage:[self tintImage:indicator withColor:color]];
        UIImageView *indicatorSelectedView = [[UIImageView alloc] initWithImage:[self tintImage:indicator withColor:selectedColor]];
        
        [imageViews addObject:indicatorView];
        [imageSelectedViews addObject:indicatorSelectedView];
	}
}

-(UIImage*) tintImage:(UIImage*)indicator withColor:(UIColor*)tintColor
{
    // lets tint the icon - assumes your icons are black
    UIGraphicsBeginImageContext(indicator.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, indicator.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, indicator.size.width, indicator.size.height);
    
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, indicator.CGImage);
    
    // draw tint color, preserving alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [tintColor setFill];
    CGContextFillRect(context, rect);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImage;
    
}

#pragma mark -
#pragma mark Accessors

- (void)setCurrentPage:(NSInteger)pageNumber
{
	// no need to update in that case
	if (currentPage == pageNumber)
		return ;
	
	// determine if the page number is in the available range
	currentPage = MIN(MAX(0, pageNumber), numberOfPages - 1) ;
	
	// in case we do not defer the page update, we redraw the view
	if (self.defersCurrentPageDisplay == NO)
		[self setNeedsDisplay] ;
}

- (void)setNumberOfPages:(NSInteger)numOfPages
{
	// make sure the number of pages is positive
	numberOfPages = MAX(0, numOfPages) ;
	
	// we then need to update the current page
	currentPage = MIN(MAX(0, currentPage), numberOfPages - 1) ;
	
	// correct the bounds accordingly
	self.bounds = self.bounds ;
	
	// we need to redraw
    [self initImageViews];
	[self setNeedsDisplay] ;
	
	// depending on the user preferences, we hide the page control with a single element
	if (hidesForSinglePage && (numOfPages < 2))
		[self setHidden: YES] ;
	else
		[self setHidden: NO] ;
}

- (void)setHidesForSinglePage:(BOOL)hide
{
	hidesForSinglePage = hide ;
	
	// depending on the user preferences, we hide the page control with a single element
	if (hidesForSinglePage && (numberOfPages < 2))
		[self setHidden: YES] ;
}

- (void)setDefersCurrentPageDisplay:(BOOL)defers
{
	defersCurrentPageDisplay = defers ;
}

- (void)setIndicatorWidth:(CGFloat)aWidth
{
	indicatorWidth = aWidth ;
	
	// correct the bounds accordingly
	self.bounds = self.bounds ;
	
	[self setNeedsDisplay] ;
}

- (void)setIndicatorHeight:(CGFloat)aHeight
{
	indicatorHeight = aHeight ;
	
	// correct the bounds accordingly
	self.bounds = self.bounds ;
	
	[self setNeedsDisplay] ;
}

- (void)setIndicatorSpace:(CGFloat)aSpace
{
	indicatorSpace = aSpace ;
	
	// correct the bounds accordingly
	self.bounds = self.bounds ;
	
	[self setNeedsDisplay] ;
}

- (void)setIndicatorImages:(NSArray *)aIndicatorImages
{
	indicatorImages = aIndicatorImages ;
	[self initImageViews];
	[self setNeedsDisplay] ;
}

- (void)setDefaultIndicator:(NSString *)aDefaultIndicator
{
	defaultIndicator = aDefaultIndicator ;
	[self initImageViews];
	[self setNeedsDisplay] ;
}

- (void)setIndicatorColor:(UIColor *)aIndicatorColor
{
	indicatorColor = aIndicatorColor ;
	[self initImageViews];
	[self setNeedsDisplay] ;
}

- (void)setIndicatorSelectedColor:(UIColor *)aIndicatorSelectedColor
{
	indicatorSelectedColor = aIndicatorSelectedColor ;
	[self initImageViews];
	[self setNeedsDisplay] ;
}

- (void)setFrame:(CGRect)aFrame
{
	// we do not allow the caller to modify the size struct in the frame so we compute it
	aFrame.size = [self sizeForNumberOfPages: numberOfPages] ;
	super.frame = aFrame ;
}

- (void)setBounds:(CGRect)aBounds
{
	// we do not allow the caller to modify the size struct in the bounds so we compute it
	aBounds.size = [self sizeForNumberOfPages: numberOfPages] ;
	super.bounds = aBounds ;
}



#pragma mark -
#pragma mark UIPageControl methods

- (void)updateCurrentPageDisplay
{
	// ignores this method if the value of defersPageIndicatorUpdate is NO
	if (self.defersCurrentPageDisplay == NO)
		return ;
	
	// in case it is YES, we redraw the view (that will update the page control to the correct page)
	[self setNeedsDisplay] ;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
	CGFloat width = (indicatorWidth > 0) ? indicatorWidth : kItemWidth ;
	CGFloat space = (indicatorSpace > 0) ? indicatorSpace : kItemSpace ;
	
	return CGSizeMake(pageCount * width + (pageCount - 1) * space + 44.0f, MAX(44.0f, width + 4.0f)) ;
}


#pragma mark -
#pragma mark Touches handlers

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	// get the touch location
	UITouch *theTouch = [touches anyObject] ;
	CGPoint touchLocation = [theTouch locationInView: self] ;
	
	// check whether the touch is in the right or left hand-side of the control
	if (touchLocation.x < (self.bounds.size.width / 2))
		self.currentPage = MAX(self.currentPage - 1, 0) ;
	else
		self.currentPage = MIN(self.currentPage + 1, numberOfPages - 1) ;
	
	// send the value changed action to the target
	[self sendActionsForControlEvents: UIControlEventValueChanged] ;
}

@end
