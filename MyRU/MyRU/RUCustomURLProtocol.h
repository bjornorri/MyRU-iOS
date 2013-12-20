//
//  RUCustomURLProtocol.h
//  MyschoolChecker
//
//  Created by Kári Tristan Helgason on 23.9.2013.
//  Copyright (c) 2013 Kári Tristan Helgason. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class is a subclass of NSURLProtocol required to authenticate to the
// crappy IIS basicauth garbage myschool has going on

@interface RUCustomURLProtocol : NSURLProtocol <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSMutableURLRequest* _customRequest;
    NSURLConnection* _connection;
}

@end
