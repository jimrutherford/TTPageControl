//
//  TTPageControl.h
//  TTPageControl
//
//  Created by James Rutherford on 2012-10-10.
//  Copyright (c) 2012 Taptonics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIControl.h>
#import <UIKit/UIKitDefines.h>

@interface TTPageControl : UIControl
{
	NSInteger numberOfPages ;
	NSInteger currentPage ;
}

// Replicate UIPageControl features
@property(nonatomic) NSInteger numberOfPages ;
@property(nonatomic) NSInteger currentPage ;

@property(nonatomic) BOOL hidesForSinglePage ;

@property(nonatomic) BOOL defersCurrentPageDisplay ;
- (void)updateCurrentPageDisplay ;

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount ;

@property (nonatomic) CGFloat indicatorWidth;
@property (nonatomic) CGFloat indicatorHeight;
@property (nonatomic) CGFloat indicatorSpace;
@property (nonatomic) NSArray *indicatorImages;
@property (nonatomic) NSString *defaultIndicator;

@end

