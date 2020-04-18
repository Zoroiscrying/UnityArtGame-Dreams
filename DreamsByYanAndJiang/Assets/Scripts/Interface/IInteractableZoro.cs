using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IInteractableZoro
{
    float MaxRange { get; }
    
    bool CanInteract { get; }
    
    bool Interacted { get; }

    void OnStartHover();
    
    void OnInteract();
    void OnEndHover();
}
