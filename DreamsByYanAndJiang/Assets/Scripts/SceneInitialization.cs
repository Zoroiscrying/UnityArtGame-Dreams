using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class SceneInitialization : MonoBehaviour
{
    public UnityEvent IntializationEvent;
    public static Color SceneHintColor = Color.white;
    
    private void Start()
    {
        UIManager.Instance.SceneEnterAnim();
        IntializationEvent.Invoke();
    }
    
        
    
}
