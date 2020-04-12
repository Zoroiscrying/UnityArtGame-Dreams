using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleTouchableItem : TouchableItem
{
    private Color pinkCol = new Color(254,127,156,255);
    
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

    public void ShowPinkHint(string hint)
    {
        UIManager.Instance.ShowHint(pinkCol,true,hint);
    }
    
    
}
