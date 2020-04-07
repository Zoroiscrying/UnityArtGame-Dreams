using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RunSpeedBoostPlatform : TouchableItem
{
    public float MoveSpeedMultiplier = 2.0f;
    
    protected override void OnTouch(Transform player)
    {
        base.OnTouch(player);
        var playerMoveControl = player.GetComponent<PlayerMoveControl>();
        if (playerMoveControl)
        {
            playerMoveControl.SetMoveSpeedMultiplier(MoveSpeedMultiplier);
        }
    }

    protected override void OnEndTouch(Transform player)
    {
        base.OnEndTouch(player);
        var playerMoveControl = player.GetComponent<PlayerMoveControl>();
        if (playerMoveControl)
        {
            playerMoveControl.SetMoveSpeedMultiplier(1.0f);
        }
    }
    
}
