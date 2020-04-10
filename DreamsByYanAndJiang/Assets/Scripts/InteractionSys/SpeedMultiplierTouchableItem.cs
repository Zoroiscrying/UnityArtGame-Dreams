using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpeedMultiplierTouchableItem : TouchableItem
{
    public ParticleSystem DieParticle;
    public float RestoreTime = 3.0f;   
    public float Multiplier = 1.5f;

    public float Duration = 3f;
    
    public float RotatingSpeed = 10.0f;
    private void Update()
    {
        this.transform.Rotate(new Vector3(Time.time,-Time.time,Time.time),Time.deltaTime*RotatingSpeed);
    }

    // Start is called before the first frame update

    protected override void OnTouch(Transform player)
    {
        base.OnTouch(player);
        var playerMoveControl = player.GetComponent<PlayerMoveControl>();
        playerMoveControl.SpeedUpForSeconds(Multiplier,Duration);
    }

    protected override void OnTouchGraphics(Transform player)
    {
        base.OnTouchGraphics(player);
        ResourceManager.Instance.GenerateFastMovingItemParticle(player.position, player.rotation);
        Timer.Register(RestoreTime, (() => { this.gameObject.SetActive(true); }));
        this.gameObject.SetActive(false);
    }
}
