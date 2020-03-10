using System;
using System.Collections;
using System.Collections.Generic;
using Hertzole.GoldPlayer;
using Hertzole.GoldPlayer.Core;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

public class InteractbleItem : MonoBehaviour, IInteractableZoro
{
    private Material _mat;
    [SerializeField] private UnityEvent _onInteractEvent;
    
    // Start is called before the first frame update
    void Start()
    {
        _mat = GetComponent<MeshRenderer>().sharedMaterial;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            SceneManagerZoro.Instance.SwitchToScene(0);
        }

        if (Input.GetKeyDown(KeyCode.W))
        {
            Debug.Log("Space");
        }
    }

    public float MaxRange { get; } = 5f;

    public void SwitchToScene(int index)
    {
        SceneManagerZoro.Instance.SwitchToScene(index);
    }

    private void OnTriggerEnter(Collider other)
    {
        var movement = other.GetComponent<GoldPlayerController>();
        if (movement!=null)
        {
            movement.Movement.MoveSpeedMultiplier = 2.0f;
            movement.Movement.CurrentJumps--;
            // movement.Movement.Gravity *= 0.5f;
        }
    }

    public void OnStartHover()
    {
        _mat.SetColor("_EmissionColor", new Color(0.5f,0.5f,0.5f));
    }

    public void OnInteract()
    {
        Debug.Log("Interacted!");
        _onInteractEvent.Invoke();
    }

    public void OnEndHover()
    {
        _mat.SetColor("_EmissionColor", new Color(0f,0f,0f));
    }
}
