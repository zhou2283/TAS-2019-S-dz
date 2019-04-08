using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class AutoAgentBehavior : MonoBehaviour
{
    public Vector3 moveDirection;
    public Vector3 moveDirectionLastFrame;
    public float moveVelocityMagnitude;

    public Transform myModelTransform;

    [Range(0.0f, 1.0f)] public float clumpStrength;
    [Range(0.0f, 1.0f)] public float alignStrength;
    [Range(0.0f, 1.0f)] public float avoidStrength;
    [Range(0.0f, 1.0f)] public float originStrength;

    MeshRenderer _myMR;

    void Start()
    {
        myModelTransform = transform.GetChild(0);
        _myMR = transform.GetChild(0).GetChild(0).GetComponent<MeshRenderer>();
        _myMR.material.SetFloat("_TimeOffset", Random.Range(0,6.28f));
        float hA = Random.Range(0, 0.02f);
        float vA = 0.02f - hA;
        _myMR.material.SetFloat("_HAmplitude", hA);
        _myMR.material.SetFloat("_HAmplitude", vA);
        /*
        float aO = Random.Range(0, 6.28f);
        _myMR.material.SetFloat("_HAmplitudeOffset", aO);
        _myMR.material.SetFloat("_VAmplitudeOffset", aO);
        */
    }

    public void PassArrayOfContext(Collider[] context, Transform contextForAvoidance)
    {
        // use context

        List<Collider> contextWithoutMe = new List<Collider>();

        foreach (Collider c in context)
        {
            if (c.gameObject != gameObject)
                contextWithoutMe.Add(c);
        }
        

        CalcMyDir(contextWithoutMe.ToArray(), contextForAvoidance);

        MoveInMyAssignedDirection(moveDirection, moveVelocityMagnitude);
    }
    
    

    void CalcMyDir(Collider[] context, Transform contextForAvoidance)
    {
        moveDirection = Vector3.Lerp(
            moveDirection, 
            Vector3.Normalize(
                ClumpDir(context) * clumpStrength +
                Align(context) * alignStrength +
                Avoidance(contextForAvoidance) * avoidStrength +
                MoveTowardsOrigin() * originStrength * Vector3.Magnitude(transform.position)/500 ), 
            .03f);
    }

    Vector3 ClumpDir (Collider[] context)
    {
        Vector3 midpoint = Vector3.zero;

        foreach (Collider c in context)
        {
            midpoint += c.transform.position;
        }

        midpoint /= context.Length;

        Vector3 dirIWantToGo = midpoint - transform.position;

        Vector3 normalizedDirIWantToGo = Vector3.Normalize(dirIWantToGo);

        return normalizedDirIWantToGo;
    }

    Vector3 Align (Collider[] context)
    {
        Vector3 headings = Vector3.zero;

        foreach (Collider c in context)
        {
            headings += c.transform.forward;
        }

        headings /= context.Length;

        return Vector3.Normalize(headings);
    }

    Vector3 Avoidance (Transform context)
    {
        if (context == null)
        {
            return Vector3.zero;
        }

        Vector3 dirIWantToGo = context.position - transform.position;
        

        Vector3 normalizedDirIWantToGo = Vector3.Normalize(dirIWantToGo);

        return (transform.forward-normalizedDirIWantToGo);
    }

    Vector3 MoveTowardsOrigin()
    {
        return transform.parent.GetComponent<FlockManager>().gatheringCenterObj.transform.position - transform.position;
    }

    void MoveInMyAssignedDirection(Vector3 direction, float magnitude)
    {
        transform.position += direction * magnitude * Time.deltaTime;
        transform.rotation = Quaternion.LookRotation(direction);
    }


    private void Update()
    {
        Vector3 HVDiff = moveDirection - Vector3.Dot(moveDirectionLastFrame, moveDirection) / Vector3.Magnitude(moveDirectionLastFrame) *
                         moveDirectionLastFrame;
        float H = HVDiff.x * 2.0f;
        float V = HVDiff.y * 2.0f;
        
        
        _myMR.material.SetFloat("_HTwist", H);
        _myMR.material.SetFloat("_VTwist", V);

        moveDirectionLastFrame = moveDirection;
    }
}
