using System;
using System.Collections;
using System.Collections.Generic;
using Hertzole.GoldPlayer.Core;
using NaughtyAttributes;
using UnityEngine;

public class FallOffManager : MonoBehaviour
{
    [ReorderableList]
    public List<CheckPoint> _checkPoints;
    private Dictionary<Vector3,int> _checkPointPriorityDict = new Dictionary<Vector3, int>();
    private CheckPoint _activeCheckpoint;

    public static FallOffManager SceneFallOffManager;

    private void InitializeCheckPoints()
    {
        int priority = 0;
        foreach (var checkPoint in _checkPoints)
        {
            if (checkPoint!=null)
            {
                checkPoint.Position = checkPoint.transform.position;
                checkPoint.Rotation = checkPoint.transform.rotation.eulerAngles;
                checkPoint.Active = false;
                checkPoint.Priority = priority;
                _checkPointPriorityDict.Add(checkPoint.Position, priority);
                priority++;
            }
        }

        if (_checkPoints.Count > 0 && _checkPoints[0]!=null)
        {
            _checkPoints[0].Active = true;
            _activeCheckpoint = _checkPoints[0];
        }

    }
    
    // Start is called before the first frame update
    void Start()
    {
        if (SceneFallOffManager != null)
        {
            Destroy(this.gameObject);
        }
        else
        {
            SceneFallOffManager = this;
        }

        InitializeCheckPoints();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Debug.Log(_activeCheckpoint.Position);
        }
    }

    public void UpdateActivePoint(CheckPoint checkPoint)
    {
        if (_activeCheckpoint==null || _activeCheckpoint.Priority <= checkPoint.Priority)
        {
            this._activeCheckpoint = checkPoint;
        }
    }

    public void HandleFallOff(GameObject obj)
    {
        if (_activeCheckpoint!=null)
        {
            Debug.Log("Change:" + _activeCheckpoint.Position );
            obj.transform.position = _activeCheckpoint.Position;
            obj.transform.rotation = Quaternion.Euler(_activeCheckpoint.Rotation);
        }
    }

    private void OnDrawGizmosSelected()
    {
        foreach (var checkPoint in _checkPoints)
        {
            Vector3 colliderSize = checkPoint.Collider.bounds.size;
            Gizmos.color = Color.blue;
            Gizmos.DrawWireCube(checkPoint.transform.position, colliderSize);
            Gizmos.DrawCube(checkPoint.transform.position,Vector3.one);
        }
    }
}
