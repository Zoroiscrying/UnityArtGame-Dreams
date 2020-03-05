using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PlayerLoop;

public class MovingPlatform : MonoBehaviour
{
    private float speed;
    private Vector3 direction;
    
    public void Init(float speed, Vector3 direction)
    {
        this.speed = speed;
        this.direction = direction;
    }

    private void Move()
    {
        this.transform.position += speed * direction * Time.fixedDeltaTime;
    }

    // Update is called once per frame
    void Update()
    {
        Move();
    }
}
