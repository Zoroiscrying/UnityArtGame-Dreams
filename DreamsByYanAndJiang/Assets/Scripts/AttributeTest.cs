using System;
using System.Collections;
using System.Collections.Generic;
using Hertzole.GoldPlayer;
using Hertzole.GoldPlayer.Core;
using JetBrains.Annotations;
using NaughtyAttributes;
using UnityEngine;

public class AttributeTest : MonoBehaviour
{
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.E))
        {
            var controller = GetComponent<CharacterController>();
            if (controller != null)
            {
                Debug.Log("Change Position");
                controller.enabled = false;
                controller.transform.position = Vector3.zero;
                controller.enabled = true;
            }

        }
    }
}
