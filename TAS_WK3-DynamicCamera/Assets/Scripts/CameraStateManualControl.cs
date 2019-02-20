using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class CameraStateManualControl : CameraState
{

    private float Timer = 0;
    private float TimeMax = 1f;
    public CameraStateManualControl(ThirdPersonCameraController cameraController) : base(cameraController)
    {
    }

    public override void Tick()
    {
        if (Input.GetMouseButton(1))
        {
            Timer = 0f;
            cameraController._ManualUpdate();
        }
        cameraController.CameraLerp();


        if (!Input.GetMouseButton(1))
        {
            if (cameraController.isWalking)
            {
                cameraController.SetState(new CameraStateAutoFollow(cameraController));
            }
            else
            {
                if (Timer < TimeMax)
                {
                    Timer += Time.deltaTime;
                }
                else
                {
                    cameraController.SetState(new CameraStateDefault(cameraController));
                }
            }
        }
        
    }
    
    public override void OnStateEnter()
    {
        Timer = 0f;
    }
}