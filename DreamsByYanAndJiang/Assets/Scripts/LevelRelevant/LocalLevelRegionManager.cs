using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LocalLevelRegionManager : MonoBehaviour
{
    private Transform _playerTransform;
    private bool _playerInside = false;
    
    private void OnTriggerEnter(Collider other)
    {
        var obj = other.gameObject;
        if (obj.CompareTag("Player"))
        {
            _playerTransform = obj.transform;
            _playerInside = true;
            UIManager.Instance.ShowHint(Color.white,true,"Press R to Restart This Level.");
        }
    }

    private void OnTriggerExit(Collider other)
    {
        var obj = other.gameObject;
        if (obj.CompareTag("Player"))
        {
            _playerTransform = null;
            _playerInside = false;
        }
    }


    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.R))
        {
            if (_playerInside)
            {
                FallOffManager.SceneFallOffManager.HandleFallOff(_playerTransform);
                _playerTransform = null;
                _playerInside = false;
            }
        }
    }
}
