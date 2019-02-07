using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(BezierBase))]
public class BezierBaseInspector : Editor
{
	private int lineSteps = 10;
	private float velocityScale = 0.2f;
	private void OnSceneViewGUI(SceneView sv)
	{
		BezierBase be = target as BezierBase;

		Transform handleTransform = be.transform;
		Quaternion handleRotation = handleTransform.rotation;


		Vector3 startPointWorld = handleTransform.TransformPoint(be.startPoint);
		Vector3 endPointWorld = handleTransform.TransformPoint(be.endPoint);
		Vector3 startTangentWorld = handleTransform.TransformPoint(be.startTangent);
		Vector3 endTangentWorld = handleTransform.TransformPoint(be.endTangent);
		//draw bezier
		Handles.DoPositionHandle(startPointWorld, handleRotation);
		Handles.DoPositionHandle(endPointWorld, handleRotation);
		Handles.DoPositionHandle(startTangentWorld, handleRotation);
		Handles.DoPositionHandle(endTangentWorld, handleRotation);
		Handles.DrawBezier(startPointWorld, endPointWorld, startTangentWorld, endTangentWorld, Color.yellow, null, 5f);
		//draw shell
		Handles.color = Color.gray;
		Handles.DrawLine(startPointWorld, startTangentWorld);
		Handles.DrawLine(startTangentWorld, endTangentWorld);
		Handles.DrawLine(endTangentWorld, endPointWorld);
		//draw sub shell
		/*
		Vector3 ab = (startPointWorld + startTangentWorld) / 2f;
		Vector3 bc = (startTangentWorld + endTangentWorld) / 2f;
		Vector3 cd = (endTangentWorld + endPointWorld) / 2f;
		Handles.DrawLine(ab, bc);
		Handles.DrawLine(bc, cd);
		Handles.DrawLine((ab + bc)/2f, (bc+cd)/2f);
		*/
		//draw speed
		//first seg
		for (int i = 0; i < lineSteps; i++) {
			Vector3 lineStart = be.GetPoint(i / (float)lineSteps);
			Vector3 lineEnd = be.GetVelocity(i / (float)lineSteps) * velocityScale + lineStart;
			Handles.color = Color.green;
			Handles.DrawLine(lineStart, lineEnd);
		}
		
		
		EditorGUI.BeginChangeCheck();
		startPointWorld = Handles.DoPositionHandle(startPointWorld, handleRotation);
		if (EditorGUI.EndChangeCheck()) {
			Undo.RecordObject(be, "Move Point");
			EditorUtility.SetDirty(be);
			be.startPoint = handleTransform.InverseTransformPoint(startPointWorld);
		}
		EditorGUI.BeginChangeCheck();
		endPointWorld = Handles.DoPositionHandle(endPointWorld, handleRotation);
		if (EditorGUI.EndChangeCheck()) {
			Undo.RecordObject(be, "Move Point");
			EditorUtility.SetDirty(be);
			be.endPoint = handleTransform.InverseTransformPoint(endPointWorld);
		}
		EditorGUI.BeginChangeCheck();
		startTangentWorld = Handles.DoPositionHandle(startTangentWorld, handleRotation);
		if (EditorGUI.EndChangeCheck()) {
			Undo.RecordObject(be, "Move Point");
			EditorUtility.SetDirty(be);
			be.startTangent = handleTransform.InverseTransformPoint(startTangentWorld);
		}
		EditorGUI.BeginChangeCheck();
		endTangentWorld = Handles.DoPositionHandle(endTangentWorld, handleRotation);
		if (EditorGUI.EndChangeCheck()) {
			Undo.RecordObject(be, "Move Point");
			EditorUtility.SetDirty(be);
			be.endTangent = handleTransform.InverseTransformPoint(endTangentWorld);
		}
		
	}

	void OnEnable()
	{
		Debug.Log("OnEnable");
		SceneView.onSceneGUIDelegate += OnSceneViewGUI;
	}

	void OnDisable()
	{
		Debug.Log("OnDisable");
		SceneView.onSceneGUIDelegate -= OnSceneViewGUI;
	}
}
