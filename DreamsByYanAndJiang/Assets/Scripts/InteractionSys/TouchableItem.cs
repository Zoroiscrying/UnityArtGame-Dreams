using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public abstract class TouchableItem :MonoBehaviour, ITouchableZoro
{
    public UnityEvent onPlayerBeginTouchEvent;
    public UnityEvent onPlayerEndTouchEvent;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            OnTouch(other.transform);
        }
    }

    protected virtual void OnTouch(Transform player)
    {
        OnTouchGraphics();
    }

    protected virtual void OnTouchGraphics()
    {
        
    }

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
