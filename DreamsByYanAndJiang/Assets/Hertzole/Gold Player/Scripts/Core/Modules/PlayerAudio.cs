using UnityEngine;
using UnityEngine.Serialization;

namespace Hertzole.GoldPlayer.Core
{
    /// <summary>
    /// Used to apply audio to Gold Player.
    /// </summary>
    [System.Serializable]
    public class PlayerAudio : PlayerModule
    {
        [SerializeField]
        [Tooltip("Determines if any audio should be played.")]
        [FormerlySerializedAs("m_EnableAudio")]
        private bool enableAudio = true;
        [SerializeField]
        [Tooltip("Sets how the audio will work.\nCustom will require a PlayerAudioBehaviour attached to the player.")]
        [FormerlySerializedAs("m_AudioType")]
        private AudioTypes audioType = AudioTypes.Standard;

        [Space]

        [SerializeField]
        [Tooltip("Determines if the audio should be based on head bob.")]
        [FormerlySerializedAs("m_BasedOnHeadBob")]
        private bool basedOnHeadBob = true;
        [SerializeField]
        [Tooltip("Sets how frequent the footsteps are.")]
        [FormerlySerializedAs("m_StepTime")]
        private float stepTime = 1.5f;

        [Space]

        [SerializeField]
        [Tooltip("All the audio settings that plays when walking.")]
        [FormerlySerializedAs("m_WalkFootsteps")]
        private AudioItem walkFootsteps = new AudioItem(true, true, 1f, 0.9f, 1.1f, true, 1f);
        [SerializeField]
        [Tooltip("All the audio settings that plays when running.")]
        [FormerlySerializedAs("m_RunFootsteps")]
        private AudioItem runFootsteps = new AudioItem(true, true, 1.4f, 1.4f, 1.6f, true, 1f);
        [SerializeField]
        [Tooltip("All the audio settings that plays when crouching.")]
        [FormerlySerializedAs("m_CrouchFootsteps")]
        private AudioItem crouchFootsteps = new AudioItem(true, true, 1f, 0.9f, 1.1f, true, 0.4f);
        [SerializeField]
        [Tooltip("All the audio settings that plays when jumping.")]
        [FormerlySerializedAs("m_Jumping")]
        private AudioItem jumping = new AudioItem(true, true, 1f, 0.9f, 1.1f, true, 1f);
        [SerializeField]
        [Tooltip("All the audio settings that plays when landing.")]
        [FormerlySerializedAs("m_Landing")]
        private AudioItem landing = new AudioItem(true, true, 1f, 0.9f, 1.1f, true, 1f);

        [Space]

        [SerializeField]
        [Tooltip("The audio source where all the footsteps sounds will be played.")]
        [FormerlySerializedAs("m_FootstepsSource")]
        private AudioSource footstepsSource = null;
        [SerializeField]
        [Tooltip("The audio source where all the jump sounds will be played.")]
        [FormerlySerializedAs("m_JumpSource")]
        private AudioSource jumpSource = null;
        [SerializeField]
        [Tooltip("The audio source where all the land sounds will be played.")]
        [FormerlySerializedAs("m_LandSource")]
        private AudioSource landSource = null;

        // When the next step sound should occur.
        protected float nextStepTime = 0;
        // Where in the cycle the steps are.
        protected float stepCycle = 0;

        // Check if the player was previously grounded.
        protected bool previouslyGrounded = true;

        // A custom audio behaviour, if the type is set to Custom.
        private PlayerAudioBehaviour customBehaviour;

        /// <summary> Determines if any audio should be played. </summary>
        public bool EnableAudio { get { return enableAudio; } set { enableAudio = value; } }
        /// <summary> Sets how the audio will work. Custom will require a PlayerAudioBehaviour attached to the player. </summary>
        public AudioTypes AudioType { get { return audioType; } set { audioType = value; } }
        /// <summary> Determines if the audio should be based on head bob. </summary>
        public bool BasedOnHeadBob { get { return basedOnHeadBob; } set { basedOnHeadBob = value; } }
        /// <summary> Sets how frequent the footsteps are. </summary>
        public float StepTime { get { return stepTime; } set { stepTime = value; } }

        /// <summary> All the audio settings that plays when walking. </summary>
        public AudioItem WalkFootsteps { get { return walkFootsteps; } set { walkFootsteps = value; } }
        /// <summary> All the audio settings that plays when running. </summary>
        public AudioItem RunFootsteps { get { return runFootsteps; } set { runFootsteps = value; } }
        /// <summary> All the audio settings that plays when crouching. </summary>
        public AudioItem CrouchFootsteps { get { return crouchFootsteps; } set { crouchFootsteps = value; } }
        /// <summary> All the audio settings that plays when jumping. </summary>
        public AudioItem Jumping { get { return jumping; } set { jumping = value; } }
        /// <summary> All the audio settings that plays when landing. </summary>
        public AudioItem Landing { get { return landing; } set { landing = value; } }

        /// <summary> The audio source where all the footsteps sounds will be played. </summary>
        public AudioSource FootstepsSource { get { return footstepsSource; } set { footstepsSource = value; } }
        /// <summary> The audio source where all the jump sounds will be played. </summary>
        public AudioSource JumpSource { get { return jumpSource; } set { jumpSource = value; } }
        /// <summary> The audio source where all the land sounds will be played. </summary>
        public AudioSource LandSource { get { return landSource; } set { landSource = value; } }

        protected override void OnInitialize()
        {
            // If based on head bob is true but head bob is not enabled, complain.
            if (basedOnHeadBob && !PlayerController.HeadBob.EnableBob)
            {
                Debug.LogWarning("Audio on '" + PlayerController.gameObject.name + "' is set to be based on head bob, but head bob isn't actually enabled!", PlayerController);
            }

            if (audioType == AudioTypes.Custom)
            {
                customBehaviour = PlayerController.GetComponent<PlayerAudioBehaviour>();

                if (customBehaviour == null)
                {
                    Debug.LogError("Audio type on " + PlayerController.gameObject.name + " is set to Custom but no PlayerAudioBehaviour is attached!");
                    return;
                }

                customBehaviour.Initialize(PlayerController, PlayerInput, footstepsSource, jumpSource, landSource);
            }
        }

        public override void OnUpdate(float deltaTime)
        {
            DoStepCycle(deltaTime);
            AudioHandler();

            if (audioType == AudioTypes.Custom && customBehaviour != null)
            {
                customBehaviour.OnUpdate(deltaTime);
            }
        }

        public override void OnFixedUpdate(float fixedDeltaTime)
        {
            if (audioType == AudioTypes.Custom && customBehaviour != null)
            {
                customBehaviour.OnFixedUpdate(fixedDeltaTime);
            }
        }

        public override void OnLateUpdate(float deltaTime)
        {
            if (audioType == AudioTypes.Custom && customBehaviour != null)
            {
                customBehaviour.OnLateUpdate(deltaTime);
            }
        }

        /// <summary>
        /// Handles the step cycle logic.
        /// </summary>
        protected virtual void DoStepCycle(float deltaTime)
        {
            // If the step cycle should be based on head bob, get it from there.
            // Else do it by itself.
            if (basedOnHeadBob)
            {
                // If head bob is enabled, set the step cycle to the bob cycle.
                // Else do it by itself.
                if (PlayerController.HeadBob.EnableBob)
                {
                    // Head bob was enabled. Set the step cycle to the bob cycle.
                    stepCycle = PlayerController.HeadBob.BobCycle;
                }
                else
                {
                    // Head bob was disabled. Do the math here.
                    DoStepCycleMath(deltaTime);
                }
            }
            else
            {
                // It should not be based on head bob. Do the math here.
                DoStepCycleMath(deltaTime);
            }
        }

        /// <summary>
        /// Calculates the step cycle.
        /// </summary>
        protected virtual void DoStepCycleMath(float deltaTime)
        {
            if (CharacterController == null)
            {
                Debug.LogError("Character Controller on " + PlayerController.gameObject.name + " is null. Did you run the GetReferences method?");
                return;
            }

            // Get the velocity from the character controller.
            float flatVelocity = new Vector3(CharacterController.velocity.x, 0, CharacterController.velocity.z).magnitude;
            // Calculate some stride thing. (Not 100% what everything here does)
            float strideLengthen = 1 + (flatVelocity * 0.3f);
            stepCycle += (flatVelocity / strideLengthen) * (deltaTime / stepTime);
        }

        /// <summary>
        /// Handles all the audio features.
        /// </summary>
        protected virtual void AudioHandler()
        {
            // Only run if the audio feature is enabled.
            if (enableAudio)
            {
                // If the player is grounded, play the footsteps and land sound.
                // Else play the jump sound.
                if (PlayerController.Movement.IsGrounded)
                {
                    // If the player wasn't previously grounded, play the land sound.
                    // Else play the footsteps sounds.
                    if (!previouslyGrounded)
                    {
                        // Play the land sound.
                        PlayLandSound();
                    }
                    else
                    {
                        // If the step cycle is above the next step time, play a footstep sound.
                        if (stepCycle > nextStepTime)
                        {
                            // Play a footstep sound.
                            PlayFootstepSound();
                        }
                    }
                    // Set previous grounded to true, as the player was previously grounded.
                    previouslyGrounded = true;
                }
                else
                {
                    // If the player was just grounded, play the jump sound.
                    if (previouslyGrounded)
                    {
                        // Play the jump sound.
                        PlayJumpSound();
                    }
                    // The player is no longer grounded, so set previously grounded to false.
                    previouslyGrounded = false;
                }
            }
        }

        /// <summary>
        /// Plays a random footstep sound.
        /// </summary>
        public virtual void PlayFootstepSound()
        {
            // Only run if the audio feature is enabled.
            if (enableAudio)
            {
                if (audioType == AudioTypes.Standard)
                {
                    // If the player is running, play the running footsteps.
                    // Else if the player is crouching, play the crouching footsteps.
                    // Else just play the walking footsteps.
                    if (PlayerController.Movement.IsRunning)
                    {
                        runFootsteps.Play(footstepsSource);
                    }
                    else if (PlayerController.Movement.IsCrouching)
                    {
                        crouchFootsteps.Play(footstepsSource);
                    }
                    else
                    {
                        walkFootsteps.Play(footstepsSource);
                    }
                }
                else if (audioType == AudioTypes.Custom && customBehaviour != null)
                {
                    customBehaviour.PlayFoostepSound();
                }

                // Add some time to the next step time.
                nextStepTime = stepCycle + 0.5f;
            }
        }

        /// <summary>
        /// Plays a random jump sound.
        /// </summary>
        public virtual void PlayJumpSound()
        {
            // Only play if the audio feature is enabled and the jump sound is enabled.
            if (enableAudio && jumping.Enabled)
            {
                if (audioType == AudioTypes.Standard)
                {
                    jumping.Play(jumpSource);
                }
                else if (audioType == AudioTypes.Custom)
                {
                    customBehaviour.PlayJumpSound();
                }
            }
        }

        /// <summary>
        /// Plays a random land sound.
        /// </summary>
        public virtual void PlayLandSound()
        {
            // Only play if the audio feature is enabled and the landing sound is enabled.
            if (enableAudio && landing.Enabled)
            {
                if (audioType == AudioTypes.Standard)
                {
                    landing.Play(landSource);
                }
                else if (audioType == AudioTypes.Custom)
                {
                    customBehaviour.PlayLandSound();
                }

                // Add some time to the next step time.
                nextStepTime = stepCycle + 0.5f;
            }
        }

        /// <summary>
        /// Stops the current footstep sound for playing.
        /// </summary>
        public void StopFootstepSound()
        {
            footstepsSource.Stop();
            footstepsSource.clip = null;
        }

        /// <summary>
        /// Stops the current jump sound from playing.
        /// </summary>
        public void StopJumpSound()
        {
            jumpSource.Stop();
            jumpSource.clip = null;
        }

        /// <summary>
        /// Stops the current land sound from playing.
        /// </summary>
        public void StopLandSound()
        {
            landSource.Stop();
            landSource.clip = null;
        }

        /// <summary>
        /// Stops all sounds from playing.
        /// </summary>
        public void StopAllSounds()
        {
            StopFootstepSound();
            StopJumpSound();
            StopLandSound();
        }
    }
}
