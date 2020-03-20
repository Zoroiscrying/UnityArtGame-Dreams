using System;
using System.Collections;
using System.Collections.Generic;
using Hertzole.GoldPlayer;
using Hertzole.GoldPlayer.Core;
using UnityEngine;

public class PlayerMoveControl : MonoBehaviour
{
    private GoldPlayerController playerController;

    private void Start()
    {
        this.playerController = GetComponent<GoldPlayerController>();
    }

    public void EnableJump()
    {
        playerController.Movement.CanJump = true;
    }

    public void EnableShiftRun()
    {
        playerController.Movement.CanRun = true;
    }

    public void EnableDoubleJump()
    {
        playerController.Movement.AirJumpsAmount = 1;
    }

    public void SpeedUpForSeconds(float multiplier, float sec)
    {
        playerController.Movement.MoveSpeedMultiplier = multiplier;
        Timer.Register(sec, (() => playerController.Movement.MoveSpeedMultiplier = 1.0f));
    }
}
