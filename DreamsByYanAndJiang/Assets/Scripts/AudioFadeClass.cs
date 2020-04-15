using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class AudioFadeClass
{
    public static IEnumerator FadeOut(AudioSource audioSource, float FadeTime)
    {
        float startVolume = audioSource.volume;
 
        while (audioSource.volume > 0)
        {
            audioSource.volume -= startVolume * Time.deltaTime / FadeTime;
 
            yield return null;
        }
 
        audioSource.Stop();
    }
 
    public static IEnumerator FadeIn(AudioSource audioSource, float FadeTime, float endVolume = 1.0f)
    {
        float startVolume = 0.2f;
 
        audioSource.volume = 0;
        audioSource.Play();
 
        while (audioSource.volume < endVolume)
        {
            audioSource.volume += startVolume * Time.deltaTime / FadeTime;
 
            yield return null;
        }
 
        audioSource.volume = endVolume;
    }
}

namespace UnityEngine
{
    public static class AudioSourceExtensions
    {
        public static void FadeOut(this AudioSource a, float duration)
        {
            AudioManager.Instance.StartCoroutine(AudioFadeClass.FadeOut(a, duration));
        }

        public static void FadeIn(this AudioSource a, float duration, float endVolume)
        {
            AudioManager.Instance.StartCoroutine(AudioFadeClass.FadeIn(a, duration, endVolume));
            // AudioFadeClass.FadeIn(a, duration, endVolume);
        }
        
    }
}