using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class MovingEvent : MonoBehaviour
{
    public List<Transform> ObjectsToMove;
    public Vector3 RelativeMoveVector = Vector3.zero;
    public float MoveTime = 20f;

    public void BeginMove()
    {
        foreach (var movingObject in ObjectsToMove)
        {
            movingObject.DOLocalMove(Vector3.zero + RelativeMoveVector, MoveTime).SetEase(Ease.Linear);
        }
    }



}
