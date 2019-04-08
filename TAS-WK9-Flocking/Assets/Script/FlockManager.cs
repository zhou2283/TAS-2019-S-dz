using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlockManager : MonoBehaviour
{
    public GameObject myAutoAgentPrefab;
    public GameObject gatheringCenterObj;

    [Range(1, 5000)] public int numberOfSpawns;

    List<GameObject> _allMyAgents = new List<GameObject>();
    
    void Start()
    {
        float rCubed = 3 * numberOfSpawns / (4 * Mathf.PI * .01f); // .01 per unit volume
        float r = Mathf.Pow(rCubed, .33f);

        for (int i = 0; i < numberOfSpawns; i++)
        {
            _allMyAgents.Add(Instantiate(myAutoAgentPrefab, Random.insideUnitSphere * r, Quaternion.identity, transform));
        }
    }

    Collider[] collInRad = new Collider[1];
    Collider[] collInRadForAviodance = new Collider[1];

    void Update()
    {
        foreach(GameObject g in _allMyAgents)
        {
            AutoAgentBehavior a = g.GetComponent<AutoAgentBehavior>();
            
            Physics.OverlapSphereNonAlloc(g.transform.position, 6, collInRad);
            Physics.OverlapSphereNonAlloc(g.transform.position, 3, collInRadForAviodance);

            Collider nearestCol = null;
            float nearestColLen = 9999f;
            foreach (var child in collInRadForAviodance)
            {
                if (child.transform.gameObject == g)
                {
                    continue;
                }
                var currentLen = Vector3.Magnitude(child.transform.position - g.transform.position);
                if (currentLen < nearestColLen)
                {
                    nearestCol = child;
                    nearestColLen = currentLen;
                }
                
            }

            // Currently getting a ref to itself so may do something weird

            if(nearestCol != null)
                a.PassArrayOfContext(collInRad, nearestCol.transform);
            else
            {
                a.PassArrayOfContext(collInRad, null);
            }
        }
    }
}
