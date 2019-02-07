using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.PlayerLoop;

public class CameraOnSpline : MonoBehaviour {

	public BezierSpline spline;
	public bool lookForward;
	public SplineWalkerMode mode;
	public SplineSpeedMode speedMode;
	private bool goingForward = true;

	public float duration = 5f;
	private float distance = 0;

	private float progress;
	
	public AnimationCurve speedCurve = AnimationCurve.Linear(0, 10, 1, 10);

	public void SetSpeedCurve(AnimationCurve ac)
	{
		speedCurve = ac;
	}
	
	private void Update () {
		
		if (speedMode == SplineSpeedMode.TimeBased)
		{
			if (goingForward) {
				progress += Time.deltaTime / duration;
				if (progress > 1f) {
					if (mode == SplineWalkerMode.Once) {
						progress = 1f;
					}
					else if (mode == SplineWalkerMode.Loop) {
						progress -= 1f;
					}
					else {
						progress = 2f - progress;
						goingForward = false;
					}
				}
			}
			else {
				progress -= Time.deltaTime / duration;
				if (progress < 0f) {
					progress = -progress;
					goingForward = true;
				}
			}
			Vector3 position = spline.GetPoint(progress);
			transform.localPosition = position;
			if (lookForward) {
				transform.LookAt(position + spline.GetDirection(progress));
			}
		}
		else if (speedMode == SplineSpeedMode.DistanceBased)
		{
			float time = spline.GetTimeWithDistance(distance);
			transform.position = spline.GetPoint(time);
			distance += Time.deltaTime * speedCurve.Evaluate(distance/spline.length);
			if (distance >= spline.length)
			{
				distance -= spline.length;
			}
		
			if (lookForward) {
				transform.LookAt(transform.position + spline.GetDirection(time));
			}
		}
	}
	
}
