using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerTouchEnvironment : MonoBehaviour
{
    private Collider _collider;
    private ITouchableZoro _touchableObject;
    
    // Start is called before the first frame update
    void Start()
    {
        _collider = GetComponent<Collider>();
        if (_collider == null)
        {
            _collider = this.gameObject.AddComponent<BoxCollider>();
        }
    }


    private void OnTriggerEnter(Collider other)
    {
        _touchableObject = other.GetComponent<ITouchableZoro>();
        if (_touchableObject != null)
        {
            _touchableObject.OnBeginTouch();
        }
    }

    private void OnTriggerStay(Collider other)
    {
        _touchableObject = other.GetComponent<ITouchableZoro>();
        if (_touchableObject != null)
        {
            _touchableObject.OnBeginTouch();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        _touchableObject = other.GetComponent<ITouchableZoro>();
        if (_touchableObject != null)
        {
            _touchableObject.OnEndTouch();
        }
    }
}
