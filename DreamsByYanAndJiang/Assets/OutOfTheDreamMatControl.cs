using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutOfTheDreamMatControl : MonoBehaviour
{
    [SerializeField] private Material _envMat;
    [SerializeField] private Material _skyBoxMat;
    [SerializeField] private Transform _player;
    [SerializeField] private Vector2 FromToDis = Vector2.zero;

    // Update is called once per frame
    void Update()
    {
        float playerPosZ = _player.position.z;
        float percentage = (playerPosZ - FromToDis.x) / (FromToDis.y - FromToDis.x);
        percentage = Mathf.Clamp(percentage, 0f, 0.7f);
        ChangeEnvMatColor(new Color(percentage+0.1f,percentage+0.1f,percentage+0.1f));
        ChangeSkyBoxEmit(percentage+0.05f);
    }

    public void ChangeEnvMatColor(Color color)
    {
        if (_envMat.HasProperty("_BaseColor"))
        {
            _envMat.SetColor("_BaseColor",color);
        }
    }

    public void ChangeSkyBoxEmit(float value)
    {
        if (_skyBoxMat.HasProperty("_Exposure"))
        {
            _skyBoxMat.SetFloat("_Exposure",value);
        }
    }
}
