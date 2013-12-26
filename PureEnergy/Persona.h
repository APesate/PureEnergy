//
//  Persona.h
//  PureEnergy
//
//  Created by Andrés Pesate on 11/11/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Persona : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* lastname;
@property (nonatomic, strong) NSString* ident;
@property (nonatomic, strong) NSMutableArray* consumesArray;

@end
