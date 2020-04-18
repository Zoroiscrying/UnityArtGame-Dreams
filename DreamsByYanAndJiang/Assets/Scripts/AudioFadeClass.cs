using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public static class AudioFadeClass
{
    public static IEnumerator FadeOut(AudioSource audioSource, float FadeTime)
    {
        // if (FadeInComplete)
        // {
        //     FadeOutComplete = false;
            float startVolume = audioSource.volume;
     
            while (audioSource.volume > 0)
            {
                audioSource.volume -= startVolume * Time.deltaTime / FadeTime;
     
                yield return null;
            }

            // FadeOutComplete = true;
            audioSource.Stop();
        // }
        // else
        // {
        //     FadeOutEmergenceBegin = true;
        //     yield break;
        // }
    }
 
    public static IEnumerator FadeIn(AudioSource audioSource, float FadeTime, float endVolume = 1.0f)
    {
        float startVolume = 0.1f;
 
        audioSource.volume = startVolume;
        audioSource.Play();
 
        while (audioSource.volume < endVolume)
        {
            // if (FadeOutEmergenceBegin)
            // {
            //     FadeOutEmergenceBegin = false;
            //     yield break;
            // }
            audioSource.volume += (endVolume-startVolume) * Time.deltaTime / FadeTime;
 
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
            Debug.Log("Fade out");
            AudioManager.Instance.StartCoroutine(AudioFadeClass.FadeOut(a, duration));
        }

        public static void FadeIn(this AudioSource a, float duration, float endVolume)
        {
            Debug.Log("Fade in");
            AudioManager.Instance.StartCoroutine(AudioFadeClass.FadeIn(a, duration, endVolume));
        }

    }
}