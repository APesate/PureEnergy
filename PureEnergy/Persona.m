//
//  Persona.m
//  PureEnergy
//
//  Created by Andrés Pesate on 11/11/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "Persona.h"

@implementation Persona
@synthesize name, lastname, ident, consumesArray = _consumesArray;

-(id)init{
    self = [super init];
    
    if (self) {
        _consumesArray = [NSMutableArray arrayWithCapacity:2];
    }
    
    return self;
}

@end
