using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class UIManager : Singleton<UIManager>
{
    [Header("Hint Text")]
    [SerializeField] private Text _hintText;
    [SerializeField] private RectTransform _startPos;
    [SerializeField] private RectTransform _endPos;

    [Header("Scene Cover Image")] [SerializeField]
    private Image _sceneCoverImage;
    
    public void ShowHint(Color fontColor,bool ease = true ,string text="DEFAULT TEXT", int fontSize=32,
        float outTime = 1.0f,float endTime = 2.0f,Ease outEasingType=Ease.OutQuad, Ease endEasingType = Ease.InQuad)
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

    private void SceneEnterAnim()
    {
        _sceneCoverImage.color = Color.black;
        _sceneCoverImage.DOColor(new Color(0,0,0,0), 1.0f).SetEase(Ease.OutQuad);
    }

    private void SceneEndAnim()
    {
        _sceneCoverImage.DOColor(new Color(0,0,0,255), 1.0f).SetEase(Ease.InQuad);
    }

    private void Start()
    {
        SceneEnterAnim();
    }

    public void SwithToScene(int sceneBuildIndex, Action<UnityEngine.AsyncOperation> onComplete)
    {
        
        SceneManager.LoadSceneAsync(sceneBuildIndex).completed += onComplete;
        
    }

    // private void Update()
    // {
    //     if (Input.GetKeyDown(KeyCode.K))
    //     {
    //         this.ShowHint(new Color(0,0,0,255), false,
    //             Time.timeSinceLevelLoad.ToString(),64,1f,2f);
    //     }
    // }
}