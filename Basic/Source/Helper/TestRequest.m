//
//  TestRequest.m
//  Basic
//
//  Created by Dustin Doan on 11/15/17.
//  Copyright © 2017 Dustin Doan. All rights reserved.
//

#import "TestRequest.h"

@implementation TestRequest

+ (void) testRequest{
    
    
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"b95609a9-e3c5-41e7-4343-feb9648fed4f" };
    NSArray *parameters = @[ @{ @"name": @"jsonstr", @"value": @"{\"username\":\"0989725594\",\"password\":\"123456\",\"firstName\":\"Le\",\"lastName\":\"Do\",\"matchingPassword\":\"123456\",\"email\":\"iop8838846@gmail.com\",\"telephone\":\"09897255934\"}" } ];
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    
    NSError *error;
    NSMutableString *body = [NSMutableString string];
    for (NSDictionary *param in parameters) {
        [body appendFormat:@"--%@\r\n", boundary];
        if (param[@"fileName"]) {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
            [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
            if (error) {
                NSLog(@"%@", error);
            }
        } else {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
            [body appendFormat:@"%@", param[@"value"]];
        }
    }
    [body appendFormat:@"\r\n--%@--\r\n", boundary];
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.vjek.tk/api/registration/customer"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                                    }
                                                }];
    [dataTask resume];
    
}

@end
