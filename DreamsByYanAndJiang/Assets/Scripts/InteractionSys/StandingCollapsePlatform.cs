using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StandingCollapsePlatform : TouchableItem
{
    private float _beginTouchTime;
    private bool _beginTouch = false;
    [SerializeField] private float _collapseTime = 2f;
    [SerializeField] private float _recoverTime = 2f;
    private float _percentage = 0.0f;

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
        
    }

    private void Collapse()
    {
        this.GetComponent<Collider>().enabled = false;
        this.GetComponent<Renderer>().enabled = false;
        _beginTouch = false;
        Timer.Register(_recoverTime, Recover);
    }

    private void Recover()
    {
        _beginTouch = false;
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
