//
//  wav_demo.hpp
//  ZGSoundTouchPro
//
//  Created by ali on 2019/1/7.
//  Copyright © 2019 com.alibaba-inc. All rights reserved.
//

#ifndef wav_demo_hpp
#define wav_demo_hpp

#include <stdio.h>
#include "SoundTouch.h"

using namespace soundtouch;

class Wav_demo
{
public:
    Wav_demo();
    ~Wav_demo();
    
    int demo_main(char *outFilePath);
    
};

#endif /* wav_demo_hpp */
