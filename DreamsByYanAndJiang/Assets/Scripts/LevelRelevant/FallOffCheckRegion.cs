using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FallOffCheckRegion : MonoBehaviour
{
    public bool IfSwitchMaterial = true;
    
    private void Start()
    {
        if (IfSwitchMaterial)
        {
            this.GetComponent<Renderer>().sharedMaterial = ResourceManager.Instance.DangerZoneMat;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        // Debug.Log("What is this?");
        if (other.gameObject.layer == LayerMask.NameToLayer("Player"))
        {
            Debug.Log("Player!");
            FallOffManager.SceneFallOffManager.HandleFallOff(other.gameObject.transform);
        }
    }

}
