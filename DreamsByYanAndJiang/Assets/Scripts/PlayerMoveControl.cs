using System;
using System.Collections;
using System.Collections.Generic;
using Hertzole.GoldPlayer;
using Hertzole.GoldPlayer.Core;
using UnityEngine;

public class PlayerMoveControl : MonoBehaviour
{
    private GoldPlayerController playerController;
    private float _multiplierTime = 0.0f;
    private float _multiplierValue = 1.0f;
    private bool _resetedMultiplier = false;

    private void Start()
    {
        this.playerController = GetComponent<GoldPlayerController>();
    }

    private void Update()
    {
        //speed up for player.
        if (_multiplierTime>0.0f)
        {
            _multiplierTime -= Time.deltaTime;
            
            _resetedMultiplier = false;
            playerController.Movement.MoveSpeedMultiplier = _multiplierValue;
        }
        else if (!_resetedMultiplier)
        {
            _resetedMultiplier = true;
            playerController.Movement.MoveSpeedMultiplier = 1.0f;
            _multiplierTime = 0.0f;
        }
        
        //

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

    public void AddOneJumpChance()
    {
        playerController.Movement.CurrentJumps--;
    }

    public void SetJumpMultiplier(float multiplier)
    {
        playerController.Movement.JumpHeightMultiplier = multiplier;
        Debug.Log("Set:" + multiplier);
    }

    public void SetMoveSpeedMultiplier(float multiplier)
    {
        playerController.Movement.MoveSpeedMultiplier = multiplier;
    }

    public void SpeedUpForSeconds(float multiplier, float sec)
    {
        this._multiplierTime = sec;
        _multiplierValue = multiplier;
    }
}
