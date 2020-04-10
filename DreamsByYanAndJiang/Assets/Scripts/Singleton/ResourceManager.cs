using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResourceManager : Singleton<ResourceManager>
{
    public Shader StandingCollapsePlatformShader;

    public Material DangerZoneMat;

    public GameObject FastMovingItemParticle;

    public GameObject DoubleJumpItemParticle;

    public void GenerateFastMovingItemParticle(Vector3 pos, Quaternion rot)
    {
        var particle = Instantiate(FastMovingItemParticle, pos, rot);
        Destroy(particle, 1f);
    }
    public void GenerateDoubleJumpItemParticle(Vector3 pos, Quaternion rot)
    {
        var particle = Instantiate(DoubleJumpItemParticle, pos, rot);
        Destroy(particle, 1f);
    }
    // Start is called before the first frame update
    void Start()
    {
        
    }

}
