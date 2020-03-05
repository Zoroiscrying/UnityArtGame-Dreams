using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InteractbleItem : MonoBehaviour, IInteractableZoro
{
    private Material _mat;
    
    // Start is called before the first frame update
    void Start()
    {
        _mat = GetComponent<MeshRenderer>().sharedMaterial;
    }

    public float MaxRange { get; } = 5f;

    public void OnStartHover()
    {
        _mat.SetColor("_EmissionColor", new Color(0.5f,0.5f,0.5f));
    }

    public void OnInteract()
    {
        Debug.Log("Interacted!");
    }

    public void OnEndHover()
    {
        _mat.SetColor("_EmissionColor", new Color(0f,0f,0f));
    }
}
