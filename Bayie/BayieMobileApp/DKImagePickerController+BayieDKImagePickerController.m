//
//  DKImagePickerController+BayieDKImagePickerController.m
//  BayieMobileApp
//
//  Created by qbuser on 16/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "DKImagePickerController+BayieDKImagePickerController.h"

@implementation DKImagePickerController (BayieDKImagePickerController)

-  (void) done {
  if (self.selectedAssets) {
    self.didSelectAssets(self.selectedAssets);

  }
}
@end
