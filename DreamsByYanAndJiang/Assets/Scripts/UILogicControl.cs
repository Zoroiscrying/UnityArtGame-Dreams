using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class UILogicControl : MonoBehaviour
{
    public void ShowPausePanel()
    {
        UIManager.Instance.ShowPausePanel();
    }

    public void ResumePausePanel()
    {
        UIManager.Instance.ResumePausePanel();
    }

    public void ShowGameInfoPanel()
    {
        UIManager.Instance.ShowGameInfoPanel();
    }

    public void ResumeGameInfoPanel()
    {
        UIManager.Instance.ResumeGameInfoPanel();
    }

    public void BackToMenu()
    {
        SceneManager.LoadScene(0);
    }

    public void RestartScene()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }
    
    public void StartGame()
    {
        SceneManager.LoadScene(1);
    }
}
