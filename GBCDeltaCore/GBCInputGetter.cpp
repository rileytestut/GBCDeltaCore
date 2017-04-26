//
//  GBCInputGetter.cpp
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/13/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

#include "GBCInputGetter.h"

GBCInputGetter::GBCInputGetter()
{
    inputs_ = 0;
}

GBCInputGetter::~GBCInputGetter()
{
}

void GBCInputGetter::activateInput(unsigned input)
{
    inputs_ |= input;
}

void GBCInputGetter::deactivateInput(unsigned input)
{
    inputs_ &= ~input;
}

void GBCInputGetter::resetInputs()
{
    inputs_ = 0;
}

unsigned GBCInputGetter::inputs()
{
    return inputs_;
}

unsigned GBCInputGetter::operator()()
{
    return this->inputs();
}
