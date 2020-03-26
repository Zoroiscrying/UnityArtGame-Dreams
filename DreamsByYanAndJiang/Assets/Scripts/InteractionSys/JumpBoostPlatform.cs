using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpBoostPlatform : TouchableItem
{
    public float JumpMultiplier = 2.0f;

    protected override void OnTouch(Transform player)
    {
        base.OnTouch(player);
        var playerMoveControl = player.GetComponent<PlayerMoveControl>();
        if (playerMoveControl)
        {
            playerMoveControl.SetJumpMultiplier(JumpMultiplier);
        }
    }

    protected override void OnEndTouch(Transform player)
    {
        base.OnEndTouch(player);
        var playerMoveControl = player.GetComponent<PlayerMoveControl>();
        if (playerMoveControl)
        {
            playerMoveControl.SetJumpMultiplier(1.0f);
        }
    }
}
