using System;
using System.Collections;
using System.Collections.Generic;
using Hertzole.GoldPlayer;
using Hertzole.GoldPlayer.Core;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

public abstract class InteractbleItem : MonoBehaviour, IInteractableZoro
{
    [SerializeField] protected UnityEvent onInteractEvent;
    protected bool _interacted = false;
    public bool _canReInteract = true;
    // Start is called before the first frame update

    public virtual float MaxRange { get; } = 5f;

    public bool CanInteract
    {
        get { return !(_interacted && !_canReInteract); }
        
    }

    public bool Interacted
    {
        get { return _interacted; }
    }


    public virtual void OnStartHover()
    {
       // _mat.SetColor("_EmissionColor", new Color(0.5f,0.5f,0.5f));
    }

    public virtual void OnInteract()
    {
        Debug.Log("Interacted!");
        onInteractEvent.Invoke();
    }

    public virtual void OnEndHover()
    {
       // _mat.SetColor("_EmissionColor", new Color(0f,0f,0f));
    }
}
