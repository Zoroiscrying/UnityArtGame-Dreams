using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneManagerZoro : MonoBehaviour
{
    private bool _sceneLoadedOnce = false;
    
    // private void Awake()
    // {
    //     if (SceneManagerZoro.Instance != this && SceneManagerZoro.Instance != null)
    //     {
    //         //Destroy(this.gameObject);
    //     }
    // }
    public void SwitchToScene(int sceneIndex)
    {
        UIManager.Instance.SceneEndAnim();
        AudioManager.Instance.CloseMusic();
        Timer.Register(UIManager.Instance.SceneEndAnimTime,
            (() => { switchToScene(sceneIndex); }));
    }

    private void switchToScene(int sceneBuildIndex)
    {
        SceneManager.LoadSceneAsync(sceneBuildIndex);
    }

}
