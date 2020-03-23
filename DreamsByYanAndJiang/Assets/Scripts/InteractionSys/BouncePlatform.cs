using System;
using System.Collections;
using System.Collections.Generic;
using Hertzole.GoldPlayer;
using UnityEngine;

public class BouncePlatform : MonoBehaviour
{
    public Vector3 BounceMultiplier = Vector3.one;


    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            var playerController = other.GetComponent<GoldPlayerController>();
            var velocity = other.GetComponent<CharacterController>().velocity;
            velocity.Scale(BounceMultiplier);
            playerController.Movement.ApplyVelocity(-velocity);
        }
    }
}
