using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class CameraState
{
    protected ThirdPersonCameraController cameraController;

    public abstract void Tick();

    public virtual void OnStateEnter() { }
    public virtual void OnStateExit() { }

    public CameraState(ThirdPersonCameraController cameraController)
    {
        this.cameraController = cameraController;
    }
}