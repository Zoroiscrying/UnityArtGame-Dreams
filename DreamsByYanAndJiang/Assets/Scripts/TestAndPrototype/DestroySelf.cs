using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroySelf : MonoBehaviour,ITouchableZoro
{
    public void DestroySelfImmediately()
    {
        Destroy(this.gameObject);
    }

    public void OnBeginTouch()
    {
        DestroySelfImmediately();
    }

    public void OnTouching()
    {
        DestroySelfImmediately();
    }

    public void OnEndTouch()
    {
        DestroySelfImmediately();
    }
}
