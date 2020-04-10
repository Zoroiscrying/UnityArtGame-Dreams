using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using Hertzole.GoldPlayer;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class UIManager : Singleton<UIManager>
{
    [Header("Hint Text")]
    [SerializeField] private Text _hintText;
    [SerializeField] private RectTransform _startPos;
    [SerializeField] private RectTransform _endPos;
    [SerializeField] private Text _pressEToInteract;

    [Header("Scene Cover Image")] [SerializeField]
    private Image _sceneCoverImage;
    [SerializeField]
    private Color _sceneEndColor = Color.black;
    [SerializeField] private float _sceneEndTime = 1.0f;
    public float SceneEndAnimTime => _sceneEndTime;

    [Header("Player Status")] [SerializeField]
    private Image _playerDoubleJumpImage;
    [SerializeField] private Image _fastMovingImage;

    [Header("Pause Panel")] [SerializeField]
    private GameObject PausePanel;
    private bool paused = false;
    
    
    [Header("Menu Panel")] [SerializeField]private GameObject MenuPanel;
    [SerializeField] private GameObject GameInfoPanel;

    private GoldPlayerController _playerController;

    private void Awake()
    {
        if (UIManager.Instance != this && UIManager.Instance != null)
        {
            Destroy(this.gameObject);
        }
    }

    public void SwitchToScene(int sceneIndex)
    {
        SceneEndAnim((() => { SceneManager.LoadScene(sceneIndex); }));
    }


    public void ShowInteractHint()
    {
        if (_pressEToInteract==null)
        {
            return;
        }
        _pressEToInteract.gameObject.SetActive(true);
        _pressEToInteract.color = _sceneEndColor;
    }

    public void DisableInteractHint()
    {
        if (_pressEToInteract==null)
        {
            return;
        }
        _pressEToInteract.gameObject.SetActive(false);
        _pressEToInteract.color = new Color(
            _sceneEndColor.r,_sceneEndColor.g,_sceneEndColor.b,0); 
    }

    public void ShowHint(Color fontColor,bool ease = true ,string text="DEFAULT TEXT", int fontSize=32,
        float outTime = 2.0f,float endTime = 3.0f,Ease outEasingType=Ease.OutQuad, Ease endEasingType = Ease.InQuad)
    {
        var startPos = _startPos.position;
        var endPos = _endPos.position;
        this._hintText.text = text;
        this._hintText.fontSize = fontSize;
        this._hintText.color = new Color(0,0,0,0);
        if (ease)
        {
            this._hintText.rectTransform.position = startPos;
            this._hintText.rectTransform.DOMove(endPos, outTime).SetEase(outEasingType);
            this._hintText.DOColor(fontColor, outTime).SetEase(outEasingType).OnComplete(
                () => { HideHint(endTime,endEasingType); });
        }
        else
        {
            this._hintText.color = fontColor;
            this._hintText.rectTransform.position = endPos;
            this._hintText.rectTransform.DOMove(endPos, outTime).SetEase(outEasingType);
            this._hintText.DOColor(fontColor, outTime).SetEase(outEasingType).OnComplete(
                () => { HideHint(0.1f,endEasingType); });
        }
    }

    public void HideHint(float time = 1.0f, Ease easingType = Ease.InQuad)
    {
        this._hintText.DOColor(new Color(0, 0, 0, 0), time);
    }

    public void ChangeSceneCoverImageColor(Color col)
    {
        _sceneEndColor = col;
    }

    public void SceneEnterAnim(Action onComplete)
    {
        _sceneCoverImage.color = _sceneEndColor;
        _sceneCoverImage.DOColor(
                new Color(_sceneEndColor.r, _sceneEndColor.g, _sceneEndColor.b, 0)
                , _sceneEndTime)
            .SetEase(Ease.OutQuad)
            .OnComplete((onComplete.Invoke));
    }

    public void SceneEnterAnim()
    {
        _sceneCoverImage.color = _sceneEndColor;
        _sceneCoverImage.DOColor(
                new Color(_sceneEndColor.r, _sceneEndColor.g, _sceneEndColor.b, 0)
                , _sceneEndTime)
            .SetEase(Ease.OutQuad);
        Debug.Log("Scene entered~");
    }

    public void SceneEndAnim()
    {
        _sceneCoverImage.DOColor(
            new Color(_sceneEndColor.r, _sceneEndColor.g, _sceneEndColor.b,255)
            , _sceneEndTime).SetEase(Ease.InQuad);
    }
    
    public void SceneEndAnim(Action onComplete)
    {
        _sceneCoverImage.DOColor(
            new Color(_sceneEndColor.r, _sceneEndColor.g, _sceneEndColor.b,255)
            , _sceneEndTime).SetEase(Ease.InQuad)
            .OnComplete((onComplete.Invoke));
    }

    public void ShowDoubleJumpImage()
    {
        _playerDoubleJumpImage.rectTransform.DOScale(Vector3.one, 0.2f).SetEase(Ease.OutQuad);
    }

    public void CloseDoubleJumpImage()
    {
        _playerDoubleJumpImage.rectTransform.DOScale(Vector3.zero, 0.2f).SetEase(Ease.InQuad);
    }

    public void ShowFastMovingValue()
    {
        _fastMovingImage.rectTransform.DOScaleX(1f, 0.15f).SetEase(Ease.OutQuad);
    }

    public void CloseFastMovingValue()
    {
        _fastMovingImage.rectTransform.DOScaleX(0f, 0.5f).SetEase(Ease.InQuad);
    }
    
    public void UpdateFastMovingValue(float value)
    {
        _fastMovingImage.rectTransform.localScale = new Vector3(value,1,1);
    }
    // private void Update()
    // {
    //     if (Input.GetKeyDown(KeyCode.K))
    //     {
    //         this.ShowHint(new Color(0,0,0,255), false,
    //             Time.timeSinceLevelLoad.ToString(),64,1f,2f);
    //     }
    // }
    public void ShowPausePanel()
    {
        PausePanel.SetActive(true);
        if (!_playerController)
        {
            _playerController = FindObjectOfType<GoldPlayerController>();
        }
        if (_playerController)
        {
            Debug.Log("Found player controller");
            _playerController.enabled = false;
        }
        Time.timeScale = 0.0f;
        paused = true;
    }

    public void ResumePausePanel()
    {
        PausePanel.SetActive(false);
        if (!_playerController)
        {
            _playerController = FindObjectOfType<GoldPlayerController>();
        }
        if (_playerController)
        {
            _playerController.enabled = true;
        }
        Time.timeScale = 1.0f;
        paused = false;
    }

    public void SwitchPausePanel()
    {
        if (paused)
        {
            ResumePausePanel();
        }
        else
        {
            ShowPausePanel();
        }
    }

    public void ShowGameInfoPanel()
    {
        GameInfoPanel.SetActive(true);
    }

    public void ResumeGameInfoPanel()
    {
        GameInfoPanel.SetActive(false);
    }

    public void ResumeMenuPanel()
    {
        MenuPanel.SetActive(false);
    }

    public void ShowMenuPanel()
    {
        MenuPanel.SetActive(true);
    }
    
}