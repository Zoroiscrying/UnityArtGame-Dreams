using System;
using UnityEngine;

public class CheckPoint : MonoBehaviour
{
    [SerializeField]
    private Vector3 _position;
    [SerializeField]
    private Vector3 _rotation;
    [SerializeField]
    private Collider _collider;
    private int _priority;
    private bool _active;
    private GameObject particle;

    public int Priority
    {
        get => _priority;
        set => _priority = value;
    }

    public bool Active
    {
        get => _active;
        set => _active = value;
    }

    public Vector3 Position
    {
        get => _position;
        set => _position = value;
    }

    public Vector3 Rotation
    {
        get => _rotation;
        set => _rotation = value;
    }

    public Collider Collider
    {
        get => _collider;
        set => _collider = value;
    }
    
    public CheckPoint(int priority, bool active)
    {
        _priority = priority;
        _active = active;
    }

    private void Start()
    {
        GenerateGraphic();
    }

    private void GenerateGraphic()
    {
        particle = ResourceManager.Instance.GenerateCheckPointParticle(this.transform.position, Quaternion.identity);
        particle.transform.parent = this.transform;
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Debug.Log("Player Go CheckPoint!");
            FallOffManager.SceneFallOffManager.UpdateActivePoint(this);
            if (particle)
            {
                AnimationManager.Instance.MoveUpAndDisappear(particle.transform, .5f, .5f);
            }
        }
    }
}
