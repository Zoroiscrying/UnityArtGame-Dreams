using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StandingCollapsePlatform : TouchableItem
{
    private Material _thisMaterial;
    private Shader _thisShader;
    private float _beginTouchTime;
    private bool _beginTouch = false;
    [SerializeField] private float _collapseTime = 2f;
    [SerializeField] private float _recoverTime = 2f;
    private float _percentage = 0.0f;

    private void Start()
    {
        _thisShader = ResourceManager.Instance.StandingCollapsePlatformShader;
       _thisMaterial = this.GetComponent<Renderer>().sharedMaterial = new Material(_thisShader);
       if (_thisMaterial.HasProperty("_EmissionIntensity"))
       {
           _thisMaterial.SetFloat("_EmissionIntensity",0.1f);
       }
    }

    public override void OnBeginTouch()
    {
        base.OnBeginTouch();
        _beginTouch = true;
        Debug.Log("Collapsing in 2 seconds!");
    }

    public override void OnEndTouch()
    {
        base.OnEndTouch();
    }

    private void UpdateGraphics()
    {
        if (_thisMaterial.HasProperty("_EmissionIntensity"))
        {
            _thisMaterial.SetFloat("_EmissionIntensity",0.1f+_percentage*1.2f);
        }
        
        
    }

    private void Collapse()
    {
        this.GetComponent<Collider>().enabled = false;
        this.GetComponent<Renderer>().enabled = false;
        _beginTouch = false;
        Timer.Register(_recoverTime, Recover);
        _percentage = 0.0f;
    }

    private void Recover()
    {
        _beginTouch = false;
        _percentage = 0.0f;
        this.GetComponent<Collider>().enabled = true;
        this.GetComponent<Renderer>().enabled = true;
    }

    // Update is called once per frame
    void Update()
    {
        if (_beginTouch)
        {
            _beginTouchTime += Time.deltaTime;
            _percentage = _beginTouchTime / _collapseTime;
        }

        if (_beginTouchTime >= _collapseTime)
        {
            Collapse();
            _beginTouchTime = 0.0f;
        }

        UpdateGraphics();
    }
}
