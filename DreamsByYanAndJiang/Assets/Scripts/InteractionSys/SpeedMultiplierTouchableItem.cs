using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpeedMultiplierTouchableItem : TouchableItem
{
    public ParticleSystem DieParticle;

    public float Multiplier = 1.5f;

    public float Duration = 3f;
    // Start is called before the first frame update

    protected override void OnTouch(Transform player)
    {
        base.OnTouch(player);
        var playerMoveControl = player.GetComponent<PlayerMoveControl>();
        playerMoveControl.SpeedUpForSeconds(Multiplier,Duration);
    }

    protected override void OnTouchGraphics()
    {
        base.OnTouchGraphics();
        if (DieParticle!=null)
        {
            Instantiate(DieParticle, this.transform.position, Quaternion.identity);
        }
        Destroy(this.gameObject);
    }
}
