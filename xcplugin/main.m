//
//  main.m
//  xcplugin
//
//  Created by Macro on 10/23/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XCODE_PATH @"/Applications/Xcode.app/Contents/Info.plist"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSString *username = NSUserName();
        NSString *pluginPath = [NSString stringWithFormat:@"/Users/%@/Library/Application Support/Developer/Shared/Xcode/Plug-ins", username];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:XCODE_PATH];
        NSString *xcodeUUID = dictionary[@"DVTPlugInCompatibilityUUID"];

        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error;
        NSArray *pathArray = [fm contentsOfDirectoryAtPath:pluginPath error:&error];
        if (error) {
            NSLog(@"路径错误");
            return 0;
        }
        for (NSString *name  in pathArray) {
            if ([name hasSuffix:@".xcplugin"]) {
                NSString *pluginPlistPath = [NSString stringWithFormat:@"%@/%@/Contents/Info.plist", pluginPath, name];
                NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:pluginPlistPath];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:dictionary[@"DVTPlugInCompatibilityUUIDs"]];
                
                if (![arr containsObject:xcodeUUID]) {
                    [arr addObject:xcodeUUID];
                    [dictionary setValue:arr forKey:@"DVTPlugInCompatibilityUUIDs"];
                    [dictionary writeToFile:pluginPlistPath atomically:YES];
                }
            }
        }
    }
    NSLog(@"XCode适配已成功,所有插件都可以正常使用了~");
    return 0;
}



