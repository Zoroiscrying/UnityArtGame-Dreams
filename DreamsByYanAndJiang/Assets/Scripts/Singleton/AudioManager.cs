using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : Singleton<AudioManager>
{
    [SerializeField] private AudioClip _menuAudio;
    [SerializeField] private AudioClip _level1MusicOne;
    [SerializeField] private AudioClip _level1MusicTwo;
    [SerializeField] private AudioClip _level2MusicOne;
    [SerializeField] private AudioClip _level2MusicTwo;
    [SerializeField] private AudioClip _level2MusicThree;
    [SerializeField] private AudioClip _level3MusicOne;
    [SerializeField] private AudioClip _level3MusicTwo;
    [SerializeField] private float _maxVolume = .8f;
    private AudioSource _audioSource;

    private void Start()
    {
        _audioSource = GetComponent<AudioSource>();
        if (!_audioSource)
        {
            _audioSource = this.gameObject.AddComponent<AudioSource>();
        }
    }

    public void CloseMusic()
    {
        if (_audioSource.clip)
        {
            _audioSource.FadeOut(4.0f);
        }
    }
    
    public void CloseMusic(Action OnCompleted)
    {
        if (_audioSource.clip)
        {
            _audioSource.FadeOut(4.0f);
            Timer.Register(4.0f, OnCompleted.Invoke);
        }
    }

    public void PlayMusic()
    {
        if (_audioSource.clip)
        {
            _audioSource.FadeIn(4.0f,_maxVolume);
        }
    }
    
    public void PlayMusic(Action OnCompleted)
    {
        if (_audioSource.clip)
        {
            _audioSource.FadeIn(4.0f,_maxVolume);
            Timer.Register(4.0f, OnCompleted.Invoke);
        }
    }

    public void PlayMenuAudio()
    {
        CloseMusic((() =>
        {
            this._audioSource.clip = _menuAudio;
            PlayMusic();
        }));
    }

    public void PlayLevelOneAudio(int index)
    {
        AudioClip audioClip;
        switch (index)
        {
            case 0:
                audioClip = _level1MusicOne;
                break;
            case 1:
                audioClip = _level1MusicTwo;
                break;
            default:
                audioClip = _level1MusicOne;
                break;
        }
        CloseMusic((() =>
        {
            this._audioSource.clip = audioClip;
            PlayMusic();
        }));
    }
    
    public void PlayLevelTwoAudio(int index)
    {
        AudioClip audioClip;
        switch (index)
        {
            case 0:
                audioClip = _level2MusicOne;
                break;
            case 1:
                audioClip = _level2MusicTwo;
                break;
            case 2:
                audioClip = _level2MusicThree;
                break;
            default:
                audioClip = _level2MusicOne;
                break;
        }
        CloseMusic((() =>
        {
            this._audioSource.clip = audioClip;
            PlayMusic();
        }));
    }
    
    public void PlayLevelThreeAudio(int index)
    {
        AudioClip audioClip;
        switch (index)
        {
            case 0:
                audioClip = _level3MusicOne;
                break;
            case 1:
                audioClip = _level3MusicTwo;
                break;
            default:
                audioClip = _level3MusicOne;
                break;
        }
        CloseMusic((() =>
        {
            this._audioSource.clip = audioClip;
            PlayMusic();
        }));
    }
}
