using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class SceneInitialization : MonoBehaviour
{
    public UnityEvent IntializationEvent;
    public static Color SceneHintColor = Color.white;
    public bool DoSceneInitAnim = true;
    
    private void Start()
    {
        if (DoSceneInitAnim)
        {
            UIManager.Instance.SceneEnterAnim();
        }
        IntializationEvent.Invoke();
    }
    
        
    
}
