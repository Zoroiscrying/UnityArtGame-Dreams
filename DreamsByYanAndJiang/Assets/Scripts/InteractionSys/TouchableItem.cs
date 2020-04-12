using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public abstract class TouchableItem :MonoBehaviour, ITouchableZoro
{
    [SerializeField] private bool _canReActivate = true;
    public UnityEvent onPlayerBeginTouchEvent;
    public UnityEvent onPlayerEndTouchEvent;
    private bool _activated = false;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {

            OnTouch(other.transform);

        }
    }

    private void OnTriggerExit(Collider other)
    {
        OnEndTouch(other.transform);
    }

    protected virtual void OnEndTouch(Transform player)
    {
        
    }

    protected virtual void OnTouch(Transform player)
    {
        OnTouchGraphics(player);
    }

    protected virtual void OnTouchGraphics(Transform player)
    {
        
    }

    public virtual void OnBeginTouch()
    {
        if (!_activated)
        {
            _activated = true;
            onPlayerBeginTouchEvent.Invoke();
        }else if (_canReActivate)
        {
            onPlayerBeginTouchEvent.Invoke();
        }
    }

    public virtual void OnTouching()
    {
        //
    }

    public virtual void OnEndTouch()
    {
        if (!_activated)
        {
            _activated = true;
            onPlayerEndTouchEvent.Invoke();
        }
        else if (_canReActivate)
        {
            onPlayerEndTouchEvent.Invoke();
        }
    }
}
