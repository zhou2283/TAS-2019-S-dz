using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BezierBase : MonoBehaviour
{

	public Vector3 startPoint;
	public Vector3 startTangent;
	public Vector3 endTangent;
	public Vector3 endPoint;
	public float length;

	private float timeStep = 0.02f;
	private float deltaDis = 0.01f;

	private float[] timeToDistanceArray;

	private void Start()
	{

		timeToDistanceArray = new float[(int)(1f/timeStep)];
		GetLength();
	}


	public Vector3 GetPoint (float t) {
		return transform.TransformPoint(Bezier.GetPoint(startPoint, startTangent, endTangent, endPoint, t));
	}
	
	public Vector3 GetVelocity (float t) {
		return transform.TransformPoint(Bezier.GetFirstDerivative(startPoint, startTangent, endTangent, endPoint, t)) - transform.position;
	}

	public float GetLength()
	{
		length = 0;
		for (int i = 0; i < timeToDistanceArray.Length; i++)
		{
			timeToDistanceArray[i] = length;
			length += Vector3.Distance(GetPoint(IndexToTime(i)), GetPoint(IndexToTime(i + 1)));
		}

		return length;
	}

	float IndexToTime(int index)
	{
		return index * timeStep;
	}

	int TimeToIndex(float time)
	{
		return (int) (time / timeStep);
	}
	

	
	public Vector3 GetPointWithDistance (float d) {
		for (int i = 0; i < timeToDistanceArray.Length - 1; i++)
		{
			if (d > timeToDistanceArray[i] && d <= timeToDistanceArray[i + 1])
			{
				if (d - timeToDistanceArray[i] < deltaDis)
				{
					return GetPoint(IndexToTime(i));
				}

				if (timeToDistanceArray[i + 1] - d < deltaDis)
				{
					return GetPoint(IndexToTime(i + 1));
				}

				return GetPoint((IndexToTime(i) + IndexToTime(i + 1)) / 2f);
			}

		}

		print("delta is too big");
		return Vector3.zero;


	}

	

	
}
