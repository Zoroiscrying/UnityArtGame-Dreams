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
        _touchableObject?.OnBeginTouch();
    }


    private void OnTriggerStay(Collider other)
    {
        _touchableObject = other.GetComponent<ITouchableZoro>();
        _touchableObject?.OnTouching();
    }

    private void OnTriggerExit(Collider other)
    {
        _touchableObject = other.GetComponent<ITouchableZoro>();
        _touchableObject?.OnEndTouch();
    }

    private void OnCollisionEnter(Collision other)
    {
        _touchableObject = other.gameObject.GetComponent<ITouchableZoro>();
        Debug.Log("Hit!");
        _touchableObject?.OnBeginTouch();
    }

    private void OnCollisionExit(Collision other)
    {
        _touchableObject = other.gameObject.GetComponent<ITouchableZoro>();
        _touchableObject?.OnEndTouch();
    }

    private void OnCollisionStay(Collision other)
    {
        _touchableObject = other.gameObject.GetComponent<ITouchableZoro>();
        _touchableObject?.OnTouching();
    }
}
