//
//  CMDocument.m
//  CocoaMarkdown
//
//  Created by Indragie on 1/12/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

#import "CMDocument_Private.h"
#import "CMNode_Private.h"

@implementation CMDocument

- (instancetype)initWithData:(NSData *)data options:(CMDocumentOptions)options
{
	NSParameterAssert(data);
	
	if ((self = [super init])) {
		cmark_node *node = cmark_parse_document((const char *)data.bytes, data.length, options);
		if (node == NULL) return nil;
		
		_rootNode = [[CMNode alloc] initWithNode:node freeWhenDone:YES];
		_options = options;
	}
	return self;
}
- (void)updateWithData:(NSData *)data options:(CMDocumentOptions)options
{
	NSParameterAssert(data);
	cmark_node *node = cmark_parse_document((const char *)data.bytes, data.length, options);
	if (node == NULL) return;
	
	_rootNode = [[CMNode alloc] initWithNode:node freeWhenDone:YES];
	_options = options;
}
- (instancetype)initWithContentsOfFile:(NSString *)path options:(CMDocumentOptions)options
{
	if ((self = [super init])) {
		FILE *fp = fopen(path.UTF8String, "r");
		if (fp == NULL) return nil;
		
		cmark_node *node = cmark_parse_file(fp, options);
		fclose(fp);
		if (node == NULL) return nil;
		
		_rootNode = [[CMNode alloc] initWithNode:node freeWhenDone:YES];
		_options = options;
	}
	return self;
}
- (void)updateWithContentsOfFile:(NSString *)path options:(CMDocumentOptions)options
{
	FILE *fp = fopen(path.UTF8String, "r");
	if (fp == NULL) return;
	
	cmark_node *node = cmark_parse_file(fp, options);
	fclose(fp);
	if (node == NULL) return;
	
	_rootNode = [[CMNode alloc] initWithNode:node freeWhenDone:YES];
	_options = options;
}
- (instancetype)initWithString:(NSString *)string options:(CMDocumentOptions)options
{
    NSParameterAssert(string);
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if ((self = [super init])) {
        cmark_node *node = cmark_parse_document((const char *)data.bytes, data.length, options);
        if (node == NULL) return nil;
        
        _rootNode = [[CMNode alloc] initWithNode:node freeWhenDone:YES];
        _options = options;
    }
    return self;
}
- (void)updateWithString:(NSString *)string options:(CMDocumentOptions)options
{
    NSParameterAssert(string);
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    cmark_node *node = cmark_parse_document((const char *)data.bytes, data.length, options);
    if (node == NULL) return;
    
    _rootNode = [[CMNode alloc] initWithNode:node freeWhenDone:YES];
    _options = options;
}
@end
