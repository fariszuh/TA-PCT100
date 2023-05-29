%module bdaqctrl
%include <typemaps.i>
%include "carrays.i"
%include <python/cwstring.i>

%array_class(unsigned char, UCharArray)
%array_class(double, DoubleArray)

%{
#include "bdaqctrl.h"
%}

%include "bdaqctrl.h"

%template(AiChannelCollection) Automation::BDaq::ICollection<Automation::BDaq::AnalogInputChannel>;
%template(AoChannelCollection) Automation::BDaq::ICollection<Automation::BDaq::AnalogChannel>;
