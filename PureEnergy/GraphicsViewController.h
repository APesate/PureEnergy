//
//  GraphicsViewController.h
//  PureEnergy
//
//  Created by Andrés Pesate on 11/3/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Delegate.h"


@interface GraphicsViewController : UIViewController<Delegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) NSString* ident;
@end
