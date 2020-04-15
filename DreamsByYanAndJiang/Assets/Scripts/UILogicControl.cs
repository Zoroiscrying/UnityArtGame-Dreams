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

    public void ShowDeveloperPanel(bool close)
    {
        UIManager.Instance.ShowDevelopersPanel(close);
    }

    public void ShowPlayerUIPanel(bool close)
    {
        UIManager.Instance.ShowPlayerStatus(close);
    }

    public void BackToMenu()
    {
        Debug.Log("Pressed UI Btn");
        ResumePausePanel();
        UIManager.Instance.SceneEndAnim((() =>
        {
            UIManager.Instance.ShowMenuPanel();
            SceneManager.LoadScene(0);
        }));
    }

    public void RestartScene()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }
    
    public void StartGame()
    {
        UIManager.Instance.ResumeMenuPanel();
        UIManager.Instance.SwitchToScene(1);
    }

    public void QuitGame()
    {
        Application.Quit();
    }
}
