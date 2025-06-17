//
//  GBCInputGetter.h
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/13/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#ifndef GBCInputGetter_h
#define GBCInputGetter_h

#include "inputgetter.h"

class GBCInputGetter
{
public:
    GBCInputGetter();
    ~GBCInputGetter();
    
    void activateInput(unsigned input);
    void deactivateInput(unsigned input);
    void resetInputs();
    
    unsigned inputs();
    
    static unsigned get(GBCInputGetter *p) { return p->inputs(); }
    
    unsigned operator()();
    
private:
    unsigned inputs_;
};

#endif /* GBCInputGetter_h */
