using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class CameraStateShowInterest : CameraState
{
    private float Timer = 0;
    private float TimeMax = 0.5f;
    public CameraStateShowInterest(ThirdPersonCameraController cameraController) : base(cameraController)
    {
    }

    public override void Tick()
    {
        if (Timer < TimeMax)
        {
            Timer += Time.deltaTime;
            cameraController._AutoFollowUpdate();
            cameraController.CameraLerp();
        }
        else
        {
            Transform interest = cameraController._CheckInterest();
            cameraController._ShowInterest(interest);
        }
        
        if (Input.GetMouseButton(1))
        {
            cameraController.SetState(new CameraStateManualControl(cameraController));
        }
        else if (cameraController.isWalking)
        {
            cameraController.SetState(new CameraStateAutoFollow(cameraController));
        }
    }

    public override void OnStateEnter()
    {
        Timer = 0f;
    }
}
