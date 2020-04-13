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

    protected override void OnTouchGraphics(Transform player)
    {
        base.OnTouchGraphics(player);
        ResourceManager.Instance.GenerateDoubleJumpItemParticle(this.transform.position, this.transform.rotation);
        Timer.Register(RestoreTime, (() => { this.gameObject.SetActive(true); }));
        AudioManager.Instance.RandomPlayVfx(ResourceManager.Instance.DoubleJumpItemAudioClips);
        this.gameObject.SetActive(false);
    }

}
