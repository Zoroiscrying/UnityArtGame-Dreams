using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleTouchableItem : TouchableItem
{
    public override void OnEndTouch()
    {
        base.OnEndTouch();
    }

    public void EnableCollider()
    {
        var collider = GetComponent<Collider>();
        if (collider)
        {
            collider.enabled = true;
            collider.isTrigger = false;
        }
    }

    public void ShowHint(string hint)
    {
        UIManager.Instance.ShowHint(Color.white,true, hint);
    }
    
    
}
