using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FloatingSelf : MonoBehaviour
{
    [SerializeField] private float offsetY = 2f;
    [SerializeField] private float floatingSpeed = 2f;
    private Vector3 selfPos;
    // Start is called before the first frame update
    void Start()
    {
        selfPos = this.transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        this.transform.position =
            new Vector3(selfPos.x, selfPos.y + offsetY * Mathf.Sin(floatingSpeed * Time.time), selfPos.z);
    }
}
