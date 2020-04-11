using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SceneAudioPlayer : MonoBehaviour
{
    public void PlayMenuSceneMusic()
    {
        AudioManager.Instance.PlayMenuAudio();
    }

    public void PlaySceneOneMusic(int index)
    {
        AudioManager.Instance.PlayLevelOneAudio(index);
    }

    public void PlaySceneTwoMusic(int index)
    {
        AudioManager.Instance.PlayLevelTwoAudio(index);
    }

    public void PlaySceneThreeMusic(int index)
    {
        AudioManager.Instance.PlayLevelThreeAudio(index);
    }
    
}
