using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraStateAutoFollow : CameraState
{
    public CameraStateAutoFollow(ThirdPersonCameraController cameraController) : base(cameraController)
    {
    }

    public override void Tick()
    {
        cameraController._AutoFollowUpdate();
        cameraController.CameraLerp();

        if (Input.GetMouseButton(1))
        {
            cameraController.SetState(new CameraStateManualControl(cameraController));
            return;
        }
        /*
        if (!cameraController._Helper_IsWalking())
        {
            Transform interest = cameraController._CheckInterest();
            if (interest)
            {
                cameraController.SetState(new CameraStateShowInterest(cameraController));
                return;
            }
            else
            {
                cameraController.SetState(new CameraStateDefault(cameraController));
                return;
            }
        }
        */
        Transform interest = cameraController._CheckInterest();
        if (interest)
        {
            cameraController.SetState(new CameraStateShowInterest(cameraController));
            return;
        }
        if (!cameraController.isWalking)
        {
            cameraController.SetState(new CameraStateDefault(cameraController));
            return;
        }
    }
}
