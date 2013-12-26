//
//  Delegate.h
//  Plot
//
//  Created by Andres Ormaechea on 11/19/13.
//  Copyright (c) 2013 Andres Ormaechea. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Delegate <NSObject>

-(void)receiveLength:(int)value;

@end
