using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResourceManager : Singleton<ResourceManager>
{
    public Shader StandingCollapsePlatformShader;

    public Material DangerZoneMat;

    public GameObject FastMovingItemParticle;
    public GameObject DoubleJumpItemParticle;
    public GameObject FloatingRockParticle;
    public GameObject CheckPointParticle;

    public AudioClip[] DoubleJumpItemAudioClips;
    public AudioClip[] FastMovingItemAudioClips;
    public AudioClip[] BtnAudioClips;
    public AudioClip[] HintAudioClips;

    public AudioClip UIClickSound;
    public AudioClip UIHoverSound;
    

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

    public GameObject GenerateFloatingRockParticle(Vector3 pos, Quaternion rot)
    {
        var obj = Instantiate(FloatingRockParticle, pos, rot);
        return obj;
    }

    public GameObject GenerateCheckPointParticle(Vector3 pos, Quaternion rot)
    {
        var obj = Instantiate(CheckPointParticle, pos, rot);
        return obj;
    }
    // Start is called before the first frame update
    void Start()
    {
        DontDestroyOnLoad(this.gameObject);
    }

}
