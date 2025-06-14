#include "sm_cannydef"

void main()
{
    object oCaster = OBJECT_SELF;
    if (GetHasFeat(FEAT_CANNY_DEFENSE, oCaster))
    {
        SMUpdateCannyDef(oCaster);
    }
}