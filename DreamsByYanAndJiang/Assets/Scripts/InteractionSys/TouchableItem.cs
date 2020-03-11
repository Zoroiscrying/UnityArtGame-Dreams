using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public abstract class TouchableItem :MonoBehaviour, ITouchableZoro
{
    public UnityEvent onPlayerBeginTouchEvent;
    public UnityEvent onPlayerEndTouchEvent;
    

    public virtual void OnBeginTouch()
    {
        onPlayerBeginTouchEvent.Invoke();
    }

    public virtual void OnTouching()
    {
        //
    }

    public virtual void OnEndTouch()
    {
        onPlayerEndTouchEvent.Invoke();
    }
}
