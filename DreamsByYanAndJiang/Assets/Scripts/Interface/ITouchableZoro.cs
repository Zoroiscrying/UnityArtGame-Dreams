using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface ITouchableZoro
{
    void OnBeginTouch();
    
    void OnTouching();

    void OnEndTouch();
}
