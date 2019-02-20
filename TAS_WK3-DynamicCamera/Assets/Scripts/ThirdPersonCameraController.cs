using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class ThirdPersonCameraController : MonoBehaviour {

    #region Internal References
    private Transform _app;
    private Transform _view;
    private Transform _cameraBaseTransform;
    private Transform _cameraTransform;
    private Transform _cameraLookTarget;
    private Transform _avatarTransform;
    private Rigidbody _avatarRigidbody;
    private Transform _objectsOfInterest;
    private List<Transform> ooiList = new List<Transform>();
    #endregion

    #region Public Tuning Variables
    public Vector3 avatarObservationOffset_Base;
    public float followDistance_Base;
    public float verticalOffset_Base;
    public float pitchGreaterLimit;
    public float pitchLowerLimit;
    public float fovAtUp;
    public float fovAtDown;
    #endregion

    #region Persistent Outputs
    //Positions
    private Vector3 _camRelativePostion_Auto;

    //Directions
    private Vector3 _avatarLookForward;

    //Scalars
    private float _followDistance_Applied;
    private float _verticalOffset_Applied;
    #endregion

    //
    private CameraState currentState;
    private Vector3 cameraOffset;
    public float cameraDistance = 5f;
    public float cameraAutoDistance = 4f;
    private float rotationSpeed = 5f;
    private Vector3 camTargetPos;
    private Vector3 camTargetRot;
    private float stayTimeMax = 2f;
    private float stayTimer = 2f;
    private RaycastHit hit;

    private float maxColDis = 5f;
    private float minColDis = 1f;
    private float horizonHeight = 3f;
    public float interestR = 5f;
    public bool isWalking = false;

    private void Awake()
    {
        _app = GameObject.Find("Application").transform;
        _view = _app.Find("View");
        _cameraBaseTransform = _view.Find("CameraBase");
        _cameraTransform = _cameraBaseTransform.Find("Camera");
        _cameraLookTarget = _cameraBaseTransform.Find("CameraLookTarget");

        _avatarTransform = _view.Find("AIThirdPersonController");
        _avatarRigidbody = _avatarTransform.GetComponent<Rigidbody>();
        _objectsOfInterest = _view.Find("ObjectsOfInterest");
        foreach (Transform child in _objectsOfInterest)
        {
            ooiList.Add(child);
        }
        //
        cameraOffset = (_cameraTransform.position - _avatarTransform.position).normalized * cameraDistance;
        SetState(new CameraStateDefault(this));
    }

    private void Update()
    {
        Debug.Log(isWalking);
        IsWalkingUpdate();
        currentState.Tick();
        CameraCollision();
    }

    private void LateUpdate()
    {
        
    }

    public void CameraLerp()
    {
        
        _cameraTransform.position = Vector3.Slerp(_cameraTransform.position, camTargetPos, 0.2f);
        _LookAtAvatar();
    }



    public void CameraCollision()
    {
        if (Physics.Raycast(_cameraTransform.position, Vector3.down, out hit))
        {
            if (hit.distance < horizonHeight)
            {
                cameraDistance = maxColDis - ((horizonHeight - hit.distance) / horizonHeight) *
                                 ((horizonHeight - hit.distance) / horizonHeight) * (maxColDis - minColDis);
            }
            else
            {
                cameraDistance = maxColDis;
            }
        }
        
        if (Physics.SphereCast(_cameraLookTarget.position, 0.4f, _cameraTransform.position - _cameraLookTarget.position,
            out hit, cameraDistance))
        {
            //cameraDistance = Mathf.Clamp(hit.distance, minColDis, maxColDis);
        }
    }
    
    public void SetState(CameraState state)
    {
        if (currentState != null)
            currentState.OnStateExit();

        currentState = state;

        if (currentState != null)
            currentState.OnStateEnter();
    }

    
    public void _DefaultUpdate()
    {
        _ComputeData();
        _FollowAvatar();

    }
    public void _AutoFollowUpdate()
    {
        _ComputeData();
        _FollowAvatar();

    }
    public void _ManualUpdate()
    {
        _Helper_IsWalking();
        _cameraLookTarget.position = _avatarTransform.position + avatarObservationOffset_Base;
        float xDif = Input.GetAxis("Mouse X");
        float yDif = Input.GetAxis("Mouse Y");
        if (xDif >= 5f)
        {
            xDif = 5f;
        }
        if (xDif <= -5f)
        {
            xDif = -5f;
        }
        if (yDif >= 5f)
        {
            yDif = 5f;
        }
        if (yDif <= -5f)
        {
            yDif = -5f;
        }
        Quaternion camTurnAngleH = Quaternion.AngleAxis(xDif * rotationSpeed, Vector3.up);
        Quaternion camTurnAngleV = Quaternion.AngleAxis(-yDif * rotationSpeed, _cameraTransform.transform.right);

        cameraOffset = camTurnAngleH * cameraOffset;
        cameraOffset = camTurnAngleV * cameraOffset;
        cameraOffset = cameraOffset.normalized*cameraDistance;

        if (Vector3.Dot(cameraOffset.normalized, Vector3.up) > 0.8f)
        {
            //cameraOffset angle limit
        }
        
        camTargetPos = _cameraLookTarget.position + cameraOffset;
        
        
    }

    public Transform _CheckInterest()
    {
        int layerMask = 1 << 9;
        Collider[] colArray = Physics.OverlapSphere(_avatarTransform.position, interestR, layerMask);
        float minDist = 9999f;
        Collider colMinDist = null;
        foreach (Collider child in colArray)
        {
            var dist = (child.transform.position - _cameraTransform.position).magnitude;
            if (dist < minDist)
            {
                colMinDist = child;
                minDist = dist;
            }
        }

        if (colMinDist != null)
        {
            return colMinDist.transform;
        }

        return null;
    }
    
    public void _ShowInterest(Transform target)
    {

        _Helper_IsWalking();
        if (target != null)
        {
            var dir = (target.position +_avatarTransform.position + avatarObservationOffset_Base)/2f - _cameraTransform.position;
            var rot = Quaternion.LookRotation(dir);
            _cameraTransform.rotation = Quaternion.Lerp(_cameraTransform.rotation, rot, 0.05f);
            cameraDistance = 10f;
        }
    }

    float _standingToWalkingSlider = 0;

    private void _ComputeData()
    {
        _avatarLookForward = Vector3.Normalize(Vector3.Scale(_avatarTransform.forward, new Vector3(1, 0, 1)));

        if (_Helper_IsWalking())
        {
            _standingToWalkingSlider = Mathf.MoveTowards(_standingToWalkingSlider, 1, Time.deltaTime * 3);
        }
        else
        {
            _standingToWalkingSlider = Mathf.MoveTowards(_standingToWalkingSlider, 0, Time.deltaTime);
        }

        float _followDistance_Walking = followDistance_Base;
        float _followDistance_Standing = followDistance_Base * 2;

        float _verticalOffset_Walking = verticalOffset_Base;
        float _verticalOffset_Standing = verticalOffset_Base * 4;

        _followDistance_Applied = Mathf.Lerp(_followDistance_Standing, _followDistance_Walking, _standingToWalkingSlider);
        _verticalOffset_Applied = Mathf.Lerp(_verticalOffset_Standing, _verticalOffset_Walking, _standingToWalkingSlider);
    }



    

    private void _FollowAvatar()
    {
        _camRelativePostion_Auto = _avatarTransform.position;

        _cameraLookTarget.position = _avatarTransform.position + avatarObservationOffset_Base;
       
        var camTargetPosFollow = _avatarTransform.position - (_avatarLookForward * _followDistance_Applied - Vector3.up * _verticalOffset_Applied).normalized * cameraAutoDistance;
        camTargetPos = Vector3.Slerp(camTargetPos, camTargetPosFollow, 0.1f);
        //renwe camera offset
        cameraOffset = (_cameraTransform.position - _avatarTransform.position).normalized * cameraAutoDistance;
        //_cameraTransform.position = _avatarTransform.position - _avatarLookForward * _followDistance_Applied + Vector3.up * _verticalOffset_Applied;

    }

    public void _LookAtAvatar()
    {
        var dir = _cameraLookTarget.position - _cameraTransform.position;
        var rot = Quaternion.LookRotation(dir);
        _cameraTransform.rotation = rot;
    }
    
 

    #region Helper Functions

    private Vector3 _lastPos;
    private Vector3 _currentPos;
    public bool _Helper_IsWalking()
    {
        _lastPos = _currentPos;
        _currentPos = _avatarTransform.position;
        float velInst = Vector3.Distance(_lastPos, _currentPos) / Time.deltaTime;

        if (velInst > .2f)
            return true;
        else return false;
    }

    void IsWalkingUpdate()
    {
        _lastPos = _currentPos;
        _currentPos = _avatarTransform.position;
        float velInst = Vector3.Distance(_lastPos, _currentPos) / Time.deltaTime;

        print(_lastPos - _currentPos);
        if ((_lastPos - _currentPos).magnitude > 0.005f)
        {
            isWalking = true;
        }
        else
        {
            isWalking = false;
        }
    }

    #endregion
}
