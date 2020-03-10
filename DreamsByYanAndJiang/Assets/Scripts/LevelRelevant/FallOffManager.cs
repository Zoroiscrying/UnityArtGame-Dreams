using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Hertzole.GoldPlayer.Core;
using NaughtyAttributes;
using UnityEngine;

public class FallOffManager : MonoBehaviour
{
    [ReorderableList]
    public List<CheckPoint> _checkPoints;
    private Dictionary<Vector3,int> _checkPointPriorityDict = new Dictionary<Vector3, int>();
    private CheckPoint _activeCheckpoint;
    public bool CheckScenePoints = false;
    public static FallOffManager SceneFallOffManager;

    private void InitializeCheckPoints()
    {
        if (CheckScenePoints)
        {
            _checkPoints.Clear();
            _checkPoints = FindObjectsOfType<CheckPoint>().ToList();
        }
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
        }
    }

    public void HandleFallOff(Transform player)
    {
        if (_activeCheckpoint!=null)
        {
            var characterController = player.GetComponent<CharacterController>();
            if (characterController)
            {
                characterController.Move(Vector3.zero);
                characterController.enabled = false;
                player.position = _activeCheckpoint.Position;
                characterController.enabled = true;
            }
        }
    }

    private void OnDrawGizmosSelected()
    {
        if (_checkPoints.Count>0)
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
}
