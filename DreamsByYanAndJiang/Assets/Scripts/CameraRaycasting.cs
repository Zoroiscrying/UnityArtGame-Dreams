using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraRaycasting : MonoBehaviour
{
    [SerializeField] private float range = 2f;

    private IInteractableZoro _currentTarget;
    private Camera _mainCamera;

    // Start is called before the first frame update
    void Start()
    {
        _mainCamera = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        RayCastForInteractable();

        if (Input.GetKeyDown(KeyCode.E))
        {
            _currentTarget?.OnInteract();
        }
    }

    private void RayCastForInteractable()
    {
        RaycastHit whatIHit;

        Ray ray = _mainCamera.ScreenPointToRay(Input.mousePosition);

        if (Physics.Raycast(ray, out whatIHit, range))
        {
            IInteractableZoro interactable = whatIHit.collider.GetComponent<IInteractableZoro>();
            if (interactable != null)
            {
                var withInRange = whatIHit.distance <= interactable.MaxRange;
                if (withInRange)
                {
                    if (interactable == _currentTarget)
                    {
                        return;
                    }

                    if(_currentTarget != null)
                    {
                        _currentTarget.OnEndHover();
                        _currentTarget = interactable;
                        _currentTarget.OnStartHover();
                        return;
                    }
                    
                    _currentTarget = interactable;
                    _currentTarget.OnStartHover();
                }
                else
                {
                    if (_currentTarget != null)
                    {
                        _currentTarget.OnEndHover();
                        _currentTarget = null;
                        return;
                    }
                }
            }
            else
            {
                if (_currentTarget != null)
                {
                    _currentTarget.OnEndHover();
                    _currentTarget = null;
                    return;
                }
            }
        }
        else
        {
            if (_currentTarget != null)
            {
                _currentTarget.OnEndHover();
                _currentTarget = null;
                return;
            }
        }
    }
}
