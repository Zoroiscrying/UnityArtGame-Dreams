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

    public void ShowGameLobbyPanel()
    {
        UIManager.Instance.ShowMenuPanel();
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
        SceneManagerZoro.SwitchToSceneStatic(0);
        UIManager.Instance.SceneEndAnim((() =>
        {
            UIManager.Instance.ShowMenuPanel();
        }));
    }

    public void RestartScene()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }
    
    public void StartGame()
    {
        UIManager.Instance.ResumeMenuPanel();
        SceneManagerZoro.SwitchToSceneStatic(1);
    }

    public void QuitGame()
    {
        Application.Quit();
    }
}
