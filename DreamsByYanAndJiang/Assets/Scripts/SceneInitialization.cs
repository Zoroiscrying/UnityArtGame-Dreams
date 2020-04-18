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
        // Cursor.visible = false;
        UIManager.Instance.ResumePausePanel();
        
        if (DoSceneInitAnim)
        {
            UIManager.Instance.SceneEnterAnim();
        }
        IntializationEvent.Invoke();
    }

    public void LockCursorOff()
    {
        Cursor.lockState = CursorLockMode.None;
    }

    public void LockCursor()
    {
        Cursor.lockState = CursorLockMode.Locked;
    }
    
        
    
}
