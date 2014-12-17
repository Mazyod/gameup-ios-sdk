/*
 * Copyright 2014 GameUp
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>
#import "GUGameUp.h"
#import "GULoginViewController.h"
#import "GUAchievementUpdate.h"
#import "GUDataHolder.h"

@interface GUViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property(setter = setGameUpController:) GUGameUp *gameup;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UITextField *apiKeyTextField;
@property (strong, nonatomic) IBOutlet UITextView *resultTextView;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIButton *goButton;

@property GUDataHolder *dataHolder;

- (void)setResultText:(NSString*) text;
- (void)appendResultText:(NSString*) text;

- (void)enableLoginDependantButtons;
- (void)disableLoginDependantButtons;

- (IBAction)onApiKeyUpdate:(id)sender;
- (IBAction)onGoButtonClick:(id)sender;

- (void)backToMainView;


@end
