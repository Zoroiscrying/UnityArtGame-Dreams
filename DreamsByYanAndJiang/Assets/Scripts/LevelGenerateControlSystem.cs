using System;
using System.Collections;
using System.Collections.Generic;
using Hertzole.GoldPlayer.Example;
using UnityEngine;
using Random = UnityEngine.Random;

public class LevelGenerateControlSystem : MonoBehaviour
{
    [SerializeField] private List<Vector3> _localStartPositions = new List<Vector3>();
    [SerializeField] private Vector3 _direction = Vector3.forward;
    [SerializeField] private float _offsetDistance = 0f;
    private List<Vector3> _realStartPositions = new List<Vector3>();

    [SerializeField] private GameObject _platformPrefab;

    private void InitializeRealPosition()
    {
        _realStartPositions = new List<Vector3>();
        foreach (var localStartPosition in _localStartPositions)
        {
            Vector3 realStartPosition = localStartPosition + transform.position;
            realStartPosition += _direction * _offsetDistance;
            _realStartPositions.Add(realStartPosition);
        }
    }

    private void OnValidate()
    {
        InitializeRealPosition();
    }

    private void OnDrawGizmos()
    {
        InitializeRealPosition();
        foreach (var pos in _localStartPositions)
        {
            Gizmos.DrawWireCube( this.transform.position + pos, Vector3.one*0.8f);
        }
        foreach (var pos in _realStartPositions)
        {
            Gizmos.DrawWireCube(pos,Vector3.one * 0.6f);
            Gizmos.DrawLine(pos, pos - _direction * _offsetDistance);
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        InitializeRealPosition();
    }

    private void SpawnOnePlatformRandomly()
    {
        var ind = Random.Range(0, _realStartPositions.Count - 1);
        var pos = _realStartPositions[ind];
        var obj = Instantiate(_platformPrefab,pos, Quaternion.Euler(_direction));
        var platformScript = obj.GetComponent<MovingPlatform>();
        //platformScript.Init(3, _direction);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            SpawnOnePlatformRandomly();
        }
    }
}
