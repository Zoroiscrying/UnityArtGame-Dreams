using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InteractButton : InteractbleItem
{
    private Material _material;
    
    // Start is called before the first frame update
    void Start()
    {
        _material = GetComponent<Renderer>().sharedMaterial;
    }

    public override void OnStartHover()
    {
        base.OnStartHover();
        if (_material.HasProperty("_EmissionIntensity"))
        {
            _material.SetFloat("_EmissionIntensity",1.0f);
        }
    }

    public override void OnEndHover()
    {
        base.OnEndHover();
        if (_material.HasProperty("_EmissionIntensity"))
        {
            _material.SetFloat("_EmissionIntensity",0.0f);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
