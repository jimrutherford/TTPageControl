//
//  TTViewController.h
//  TTPageControl
//
//  Created by James Rutherford on 2012-10-10.
//  Copyright (c) 2012 Braxio Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPageControl.h"

@interface TTViewController : UIViewController<UIScrollViewDelegate>
{
	IBOutlet UIScrollView *scrollView ;
	
	TTPageControl *pageControl ;
}

@property (nonatomic,retain) IBOutlet UIScrollView *scrollView ;



@end
