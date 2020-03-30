using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpRestoreTouchableItem : TouchableItem
{
    public ParticleSystem DieEffect;
    public float RestoreTime = 3.0f;
    public float RotatingSpeed = 10.0f;
    private void Update()
    {
        this.transform.Rotate(new Vector3(Time.time,-Time.time,Time.time),Time.deltaTime*RotatingSpeed);
    }

    protected override void OnTouch(Transform player)
    {
        base.OnTouch(player);
        var playerMoveControl = player.GetComponent<PlayerMoveControl>();
        playerMoveControl.AddOneJumpChance();
    }

    protected override void OnTouchGraphics()
    {
        base.OnTouchGraphics();
        if (DieEffect!=null)
        {
            Instantiate(DieEffect, this.transform.position, Quaternion.identity);
        }
        Timer.Register(RestoreTime, (() => { this.gameObject.SetActive(true); }));
        this.gameObject.SetActive(false);
    }

}
