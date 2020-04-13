using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleTouchableItem : TouchableItem
{
    public bool GenerateGraphic = false;
    private Color pinkCol = new Color(254,127,156,255);
    private GameObject graphic;

    private void Start()
    {
        if (GenerateGraphic)
        {
            graphic = ResourceManager.Instance.GenerateFloatingRockParticle(this.transform.position,
                Quaternion.identity);
        }
    }

    public void EnableCollider()
    {
        var collider = GetComponent<Collider>();
        if (collider)
        {
            collider.enabled = true;
            collider.isTrigger = false;
        }
    }

    public void ShowHint(string hint)
    {
        UIManager.Instance.ShowHint(Color.white,true, hint);
        SoundFx();
        AnimationManager.Instance.MoveUpAndDisappear(graphic.transform, 1.0f, 1f);
    }

    public void ShowPinkHint(string hint)
    {
        UIManager.Instance.ShowHint(pinkCol,true,hint);
        SoundFx();
        AnimationManager.Instance.MoveUpAndDisappear(graphic.transform, 1.0f, 1f);
    }

    public void SoundFx()
    {
        AudioManager.Instance.RandomPlayVfx(ResourceManager.Instance.HintAudioClips);
    }
    
}
