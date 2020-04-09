using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class AnimationManager : Singleton<AnimationManager>
{

    public void MoveUpAndDisappear(Transform obj,float duration, float moveDis, float disappearTime = 5f)
    {
        obj.DOMove(obj.transform.position + Vector3.up * moveDis, duration).SetEase(Ease.OutQuad);
        obj.DOScale(Vector3.zero, duration).SetEase(Ease.OutQuad);
        Destroy(obj.gameObject,duration);
    }

    public void ScaleDisappear(Transform obj, float duration, float disappearTime = 5.0f)
    {
        obj.DOScale(Vector3.zero, duration).SetEase(Ease.OutQuad);
        Destroy(obj.gameObject,duration);
    }
    
}
