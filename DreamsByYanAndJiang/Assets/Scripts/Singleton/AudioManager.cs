using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class AudioManager : Singleton<AudioManager>
{
    [SerializeField] private AudioClip _menuAudio;
    [SerializeField] private AudioClip _level1MusicOne;
    [SerializeField] private AudioClip _level1MusicTwo;
    [SerializeField] private AudioClip _level2MusicOne;
    [SerializeField] private AudioClip _level2MusicTwo;
    [SerializeField] private AudioClip _level2MusicThree;
    [SerializeField] private AudioClip _level2MusicFour;
    [SerializeField] private AudioClip _level3MusicOne;
    [SerializeField] private AudioClip _level3MusicTwo;
    [SerializeField] private float _maxVolume = .8f;

    [SerializeField] private AudioSource _bgMusicSource;
    [SerializeField] private AudioSource _efxSource;

    public float lowPitchRange = .95f;
    public float highPitchRange = 1.05f;

    public void CloseMusic()
    {
        if (_bgMusicSource.clip)
        {
            _bgMusicSource.FadeOut(4.0f);
        }
    }
    
    public void CloseMusic(Action OnCompleted)
    {
        if (_bgMusicSource.clip)
        {
            _bgMusicSource.FadeOut(4.0f);
            Timer.Register(4.0f, OnCompleted.Invoke);
        }
        else
        {
            Timer.Register(4.0f, OnCompleted.Invoke);
        }
    }

    public void PlayMusic()
    {
        if (_bgMusicSource.clip)
        {
            _bgMusicSource.Play();
            _bgMusicSource.FadeIn(4.0f,_maxVolume);
        }
    }
    
    public void PlayMusic(Action OnCompleted)
    {
        if (_bgMusicSource.clip)
        {
            _bgMusicSource.Play();
            _bgMusicSource.FadeIn(4.0f,_maxVolume);
            Timer.Register(4.0f, OnCompleted.Invoke);
        }
        else
        {
            Timer.Register(4.0f, OnCompleted.Invoke);
        }
    }

    public void PlayMenuAudio()
    {
        CloseMusic((() =>
        {
            this._bgMusicSource.clip = _menuAudio;
            PlayMusic();
        }));
    }

    public void PlaySingleVfx(AudioClip clip)
    {
        _efxSource.clip = clip;
        _efxSource.Play();
    }

    public void RandomPlayVfx(AudioClip[] clips)
    {
        int randomIndex = Random.Range(0, clips.Length);

        float randomPitch = Random.Range(lowPitchRange, highPitchRange);

        _efxSource.pitch = randomPitch;

        _efxSource.clip = clips[randomIndex];

        _efxSource.Play();
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
            this._bgMusicSource.clip = audioClip;
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
            case 3:
                audioClip = _level2MusicFour;
                break;
            default:
                audioClip = _level2MusicOne;
                break;
        }
        CloseMusic((() =>
        {
            this._bgMusicSource.clip = audioClip;
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
            this._bgMusicSource.clip = audioClip;
            PlayMusic();
        }));
    }
}
