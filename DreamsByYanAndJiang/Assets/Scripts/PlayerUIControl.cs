using System.Collections;
using System.Collections.Generic;
using Hertzole.GoldPlayer;
using UnityEngine;

public class PlayerUIControl : MonoBehaviour
{
    private GoldPlayerController playerController;
    private PlayerMoveControl _playerMoveControl;
    private float _relativeFastMovingValue = 0.0f;
    private bool _fastMovingLastFrame = false;
    private bool _canDoubleJumpLastFrame = true;
    private int _currentJumps = 0;
    
    // Start is called before the first frame update
    void Start()
    {
        this.playerController = GetComponent<GoldPlayerController>();
        this._playerMoveControl = GetComponent<PlayerMoveControl>();
        _currentJumps = playerController.Movement.CurrentJumps;
    }

    // Update is called once per frame
    void Update()
    {
        //pause
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            UIManager.Instance.SwitchPausePanel();
        }
    
        //fast moving
        _relativeFastMovingValue = _playerMoveControl.MultiplierTime / 4.0f;
        if (_relativeFastMovingValue<=0.0f)
        {
            if (_fastMovingLastFrame)
            {
                _fastMovingLastFrame = false;
                UIManager.Instance.CloseFastMovingValue();
            }
        }
        else if (!_fastMovingLastFrame)
        {
            UIManager.Instance.ShowFastMovingValue();
            Timer.Register(.15f, (() => this._fastMovingLastFrame = true));
        }
        else
        {
            UIManager.Instance.UpdateFastMovingValue(_relativeFastMovingValue);
        }
        

        //double jump
        _currentJumps = playerController.Movement.CurrentJumps;
        if (_currentJumps <= 0)
        {
            if (_canDoubleJumpLastFrame)
            {
                UIManager.Instance.ShowDoubleJumpImage();
                _canDoubleJumpLastFrame = false;
            }
        }
        else
        {
            if (!_canDoubleJumpLastFrame)
            {
                Debug.Log("no double jump!");
                UIManager.Instance.CloseDoubleJumpImage();
                _canDoubleJumpLastFrame = true;
            }
        }
        
    }
}
