using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraStateDefault : CameraState
{
    public CameraStateDefault(ThirdPersonCameraController cameraController) : base(cameraController)
    {
    }
    
    public override void Tick()
    {
        cameraController._DefaultUpdate();
        cameraController.CameraLerp();
        
        Transform interest = cameraController._CheckInterest();

        if (Input.GetMouseButton(1))
        {
            cameraController.SetState(new CameraStateManualControl(cameraController));
        }

        if (cameraController._Helper_IsWalking())
        {
            cameraController.SetState(new CameraStateAutoFollow(cameraController));
        }
        if (interest)
        {
            cameraController.SetState(new CameraStateShowInterest(cameraController));
        }
    }
}
