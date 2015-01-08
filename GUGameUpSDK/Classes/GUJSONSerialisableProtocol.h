/*
 Copyright 2014-2015 GameUp

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>

/** Protocol to dictate that data recieved/sent to the server can be converted to/from JSON/NSDictionary */
@protocol GUJSONSerialisableProtocol
@required
/**
 Initiate the given object from the NSDictionary JSON object
 */
- (id)initWithDictionary:(NSDictionary*) dictionary;
/**
 Converts the given object to NSDictionary JSON object
 */
- (NSDictionary*)toDictionary;
@end
